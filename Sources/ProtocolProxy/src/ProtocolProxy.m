//
//  ProtocolProxy.m
//  ProtocolProxy
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import "ProtocolProxy.h"
#import "ProtocolProxy+Internal.h"

#import <objc/runtime.h>
#import <objc/message.h>
#import <os/log.h>

#pragma mark - Preprocessor Definitions

#define _adoptedProtocols                 _protocolProxyAdoptedProtocols
#define _implementer                      _protocolProxyImplementer
#define _respondsToSelectorsWithObservers _protocolProxyRespondsToSelectorsWithObservers

#pragma mark - ProtocolProxy Implementation

@implementation ProtocolProxy {
    NSArray<Protocol *> *_adoptedProtocols;
    __weak id _implementer;

    BOOL _respondsToSelectorsWithObservers;
    BOOL _strongRetention;
}

#pragma mark Property Synthesis

@dynamic implementer, adoptedProtocols, respondsToSelectorsWithObservers;

#pragma mark Initialization

- (instancetype)initWithProtocol:(Protocol *)protocol implementer:(nullable id)implementer {
    if (protocol == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`protocol` cannot be nil" userInfo:nil];

    return [self initWithProtocols:@[protocol] implementer:implementer];
}

- (instancetype)initWithProtocol:(Protocol *)protocol stronglyRetainedImplementer:(nullable id)implementer {
    if (protocol == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`protocol` cannot be nil" userInfo:nil];
    
    return [self initWithProtocols:@[protocol] stronglyRetainedImplementer:implementer];
}

//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-designated-initializers" // NSProxy doesn't have initializers
- (instancetype)initWithProtocols:(NSArray<Protocol *> *)protocols implementer:(nullable id)implementer {
    if (protocols == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`protocols` cannot be nil" userInfo:nil];
    if (protocols.count == 0)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`protocols` must contain at least one valid protocol" userInfo:nil];

    NSArray<Protocol *> *adoptedProtocols;

    _descriptors = buildMethodDescriptorList(protocols, &adoptedProtocols);
    _adoptedProtocols = adoptedProtocols;
    _callbacks = [NSMutableArray array];

    _implementer = implementer;
    _strongRetention = NO;

    return self;
}

- (instancetype)initWithProtocols:(NSArray<Protocol *> *)protocols stronglyRetainedImplementer:(nullable id)implementer {
    if (protocols == nil)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`protocols` cannot be nil" userInfo:nil];
    if (protocols.count == 0)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"`protocols` must contain at least one valid protocol" userInfo:nil];

    NSArray<Protocol *> *adoptedProtocols;

    _descriptors = buildMethodDescriptorList(protocols, &adoptedProtocols);
    _adoptedProtocols = adoptedProtocols;
    _callbacks = [NSMutableArray array];

    _implementer = UnbalancedRetain(implementer);
    _strongRetention = YES;

    return self;
}
#pragma clang diagnostic pop

- (void)dealloc {
    if (_strongRetention)
        UnbalancedRelease(_implementer);
}

#pragma mark - NSProxy Overrides

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSArray<MethodCallbackInfo *> * const callbacks = lookupMethodCallbacksForSelector(invocation.selector, self);
    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(invocation.selector, self);
    __strong id const implementer = _implementer;

    if (descriptor != nil) {
        @try { // Before
            NSArray<MethodCallbackInfo *> * const beforeCallbacks = [callbacks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (MethodCallbackInfo *callback, id _) {
                return !callback.isOverride && callback.invokeBefore;
            }]];

            if (beforeCallbacks.count > 0) {
                NSInvocation * const beforeInvocation = copyInvocation(invocation);

                for (MethodCallbackInfo *callback in beforeCallbacks) {
                    [callback invoke:beforeInvocation];
                }
            }
        } @catch(...) {
            // Observing callbacks aren't supposed to interrupt the normal flow of things; as
            // such, exceptions thrown from here are suppressed.
        }

        @try { // Invoke
            MethodCallbackInfo * const override = [callbacks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (MethodCallbackInfo *callback, id _) { return callback.isOverride; }]].firstObject;

            if (override != nil) {
                [override invoke:invocation];
            } else if (implementer != nil && (descriptor.isRequired || callbacks.count == 0 || [implementer respondsToSelector:invocation.selector])) {
                [invocation invokeWithTarget:implementer];
            } else {
                const NSUInteger returnLength = invocation.methodSignature.methodReturnLength;

                if (returnLength > 0) {
                    uint8_t returnValue[returnLength];
                    memset((void *)returnValue, 0, returnLength);

                    [invocation setReturnValue:(void *)returnValue];
                }
            }
        } @finally {
            @try { // After
                NSArray<MethodCallbackInfo *> * const afterCallbacks = [callbacks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (MethodCallbackInfo *callback, id _) {
                    return !callback.isOverride && !callback.invokeBefore;
                }]];

                if (afterCallbacks.count > 0) {
                    NSInvocation * const afterInvocation = copyInvocation(invocation);

                    for (MethodCallbackInfo *callback in afterCallbacks) {
                        [callback invoke:afterInvocation];
                    }
                }
            } @catch(...) {
                // Observing callbacks aren't supposed to interrupt the normal flow of things; as
                // such, exceptions thrown from here are suppressed.
            }
        }
    } else if (sel_isEqual(invocation.selector, @selector(implementer))) {
        [invocation setReturnValue:&_implementer];
    } else if (sel_isEqual(invocation.selector, @selector(adoptedProtocols))) {
        [invocation setReturnValue:&_adoptedProtocols];
    } else if (sel_isEqual(invocation.selector, @selector(respondsToSelectorsWithObservers))) {
        [invocation setReturnValue:&_respondsToSelectorsWithObservers];
    } else if (sel_isEqual(invocation.selector, @selector(setRespondsToSelectorsWithObservers:))) {
        [invocation getArgument:&_respondsToSelectorsWithObservers atIndex:2];
    }
}

- (nullable NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(selector, self);
    NSMethodSignature *methodSignature = nil;
    __strong id implementer = nil;

    if (descriptor != nil) {
        BOOL isImplemented = descriptor.isRequired;

        if (!isImplemented) {
            isImplemented = lookupMethodCallbacksForSelector(selector, self) != nil && _respondsToSelectorsWithObservers;
        }

        if (!isImplemented && ((implementer = self->_implementer))) {
            methodSignature = [implementer methodSignatureForSelector:selector];
            isImplemented = (methodSignature != nil);
        }

        if (isImplemented && methodSignature == nil)
            methodSignature = [NSMethodSignature signatureWithObjCTypes:descriptor.objCTypes];
    } else {
        if (sel_isEqual(selector, @selector(implementer)) || sel_isEqual(selector, @selector(adoptedProtocols))) {
            methodSignature = [NSMethodSignature signatureWithObjCTypes:"@@:"];
        } else if (sel_isEqual(selector, @selector(respondsToSelectorsWithObservers))) {
            methodSignature = [NSMethodSignature signatureWithObjCTypes:"B@:"];
        } else if (sel_isEqual(selector, @selector(setRespondsToSelectorsWithObservers:))) {
            methodSignature = [NSMethodSignature signatureWithObjCTypes:"v@:B"];
        }
    }

    return methodSignature;
}

- (BOOL)conformsToProtocol:(Protocol *)protocol {
    for (Protocol *adoptedProtocol in _adoptedProtocols) {
        if (protocol_isEqual(protocol, adoptedProtocol))
            return YES;
    }

    return NO;
}

- (BOOL)respondsToSelector:(SEL)selector {
    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(selector, self);
    BOOL isImplemented = (descriptor != nil && descriptor.isRequired);
    __strong id implementer = nil;

    if (!isImplemented) {
        isImplemented = lookupMethodCallbacksForSelector(selector, self) != nil && _respondsToSelectorsWithObservers;
    }
    if (!isImplemented && ((implementer = self->_implementer))) {
        isImplemented = [implementer respondsToSelector:selector];
    }
    if (!isImplemented) {
        isImplemented = class_getInstanceMethod(self.class, selector) != NULL;
    }
    if (!isImplemented) {
        isImplemented = sel_isEqual(selector, @selector(implementer)) ||
                        sel_isEqual(selector, @selector(adoptedProtocols)) ||
                        sel_isEqual(selector, @selector(respondsToSelectorsWithObservers)) ||
                        sel_isEqual(selector, @selector(setRespondsToSelectorsWithObservers:));
    }

    return isImplemented;
}

#pragma mark - Public Methods

- (BOOL)overrideSelector:(SEL)selector withTarget:(id)target {
    return [self overrideSelector:selector withTarget:target targetSelector:NULL];
}

- (BOOL)overrideSelector:(SEL)selector withTarget:(id)target targetSelector:(SEL __nullable)targetSelector {
    if (target == nil || selector == NULL)
        return NO;

    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(selector, self);
    BOOL success = (descriptor != nil);

    if (success) {
        NSArray<MethodCallbackInfo *> * const callbacks = lookupMethodCallbacksForSelector(selector, self);
        NSArray<MethodCallbackInfo *> * const overrides = [callbacks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (MethodCallbackInfo *callback, id _) {
            return callback.isOverride;
        }]];

        success = (overrides.count == 0);

        if (success)
            [_callbacks addObject:[MethodCallbackInfo overrideCallbackInfoWithDescriptor:descriptor target:target targetSelector:targetSelector block:nil]];
    }

    return success;
}

- (BOOL)overrideSelector:(SEL)selector usingBlock:(id)block {
    if (block == nil || selector == NULL)
        return NO;

    if (![block isKindOfClass:objc_getClass("NSBlock")]) { // We weren't given an Objective-C block
        if ([block isKindOfClass:NSClassFromString(@"__SwiftValue")]) { // Most likely a Swift closure
            if (@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)) {
                os_log_info(protocolProxyLog(), "-[<ProtocolProxy: %p> overrideSelector:usingBlock:] | Invalid block type. Did you forget to add `@convention(block)` to your closure?", self);
            }
        }

        return NO;
    }

    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(selector, self);
    BOOL success = (descriptor != nil);

    if (success) {
        NSArray<MethodCallbackInfo *> * const callbacks = lookupMethodCallbacksForSelector(selector, self);
        NSArray<MethodCallbackInfo *> * const overrides = [callbacks filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL (MethodCallbackInfo *callback, id _) {
            return callback.isOverride;
        }]];

        success = (overrides.count == 0);

        if (success)
            [_callbacks addObject:[MethodCallbackInfo overrideCallbackInfoWithDescriptor:descriptor target:nil targetSelector:NULL block:block]];
    }

    return success;
}

//

- (BOOL)addObserver:(id)observer forSelector:(SEL)selector beforeObservedSelector:(BOOL)before {
    return [self addObserver:observer forSelector:selector beforeObservedSelector:before observerSelector:NULL];
}

- (BOOL)addObserver:(id)observer forSelector:(SEL)selector beforeObservedSelector:(BOOL)before observerSelector:(SEL __nullable)observerSelector {
    if (observer == nil || selector == NULL)
        return NO;

    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(selector, self);
    const BOOL success = (descriptor != nil);

    if (success)
        [_callbacks addObject:[MethodCallbackInfo callbackInfoWithDescriptor:descriptor invokeBefore:before target:observer targetSelector:observerSelector block:nil]];

    return success;
}

- (BOOL)addObserverForSelector:(SEL)selector beforeObservedSelector:(BOOL)before usingBlock:(id)block {
    if (block == nil || selector == NULL)
        return NO;

    if (![block isKindOfClass:objc_getClass("NSBlock")]) { // We weren't given an Objective-C block
        if ([block isKindOfClass:NSClassFromString(@"__SwiftValue")]) { // Most likely a Swift closure
            if (@available(macOS 10.12, iOS 10.0, watchOS 3.0, tvOS 10.0, *)) {
                os_log_info(protocolProxyLog(), "-[<ProtocolProxy: %p> addObserverForSelector:beforeObservedSelector:usingBlock:] | Invalid block type. Did you forget to add `@convention(block)` to your closure?", self);
            }
        }

        return NO;
    }

    MethodDescriptor * const descriptor = lookupMethodDescriptorForSelector(selector, self);
    const BOOL success = (descriptor != nil);

    if (success)
        [_callbacks addObject:[MethodCallbackInfo callbackInfoWithDescriptor:descriptor invokeBefore:before target:nil targetSelector:NULL block:block]];

    return success;
}

@end
