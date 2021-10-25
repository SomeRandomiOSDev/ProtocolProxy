//
//  ProtocolProxy+Internal.m
//  ProtocolProxy
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import "ProtocolProxy+Internal.h"
#import <objc/runtime.h>

#pragma mark - MethodDescriptor Implementation

@implementation MethodDescriptor

#pragma mark Property Synthesis

@synthesize name = _name, objCTypes = _objCTypes, isRequired = _isRequired;

#pragma mark Factory Methods

+ (instancetype)descriptorWithName:(SEL)name objCTypes:(const char *)objCTypes isRequired:(BOOL)isRequired {
    MethodDescriptor * const descriptor = [[MethodDescriptor alloc] init];

    descriptor->_name = name;
    descriptor->_isRequired = isRequired;

    const size_t len = strlen(objCTypes);
    char *types = calloc(len + 1, sizeof(char));
    memcpy(types, objCTypes, len);

    descriptor->_objCTypes = types;

    return descriptor;
}

#pragma mark Initilization

- (void)dealloc {
    if (_objCTypes != NULL)
        free((void *)_objCTypes);
}

@end

#pragma mark - MethodCallbackInfo Implementation

@implementation MethodCallbackInfo

#pragma mark Property Synthesis

@synthesize descriptor = _descriptor, isOverride = _isOverride, invokeBefore = _invokeBefore, target = _target, targetSelector = _targetSelector, block = _block;

#pragma mark Factory Methods

+ (instancetype)callbackInfoWithDescriptor:(MethodDescriptor *)descriptor invokeBefore:(BOOL)invokeBefore target:(id __nullable)target targetSelector:(SEL __nullable)targetSelector block:(id __nullable)block {
    MethodCallbackInfo * const callbackInfo = [[MethodCallbackInfo alloc] init];

    callbackInfo->_descriptor = descriptor;
    callbackInfo->_isOverride = NO;
    callbackInfo->_invokeBefore = invokeBefore;
    callbackInfo->_target = target;
    callbackInfo->_targetSelector = targetSelector;

    if (block != nil)
        callbackInfo->_block = (__bridge id)_Block_copy((__bridge const void *)block);
    else
        callbackInfo->_block = nil;

    return callbackInfo;
}

+ (instancetype)overrideCallbackInfoWithDescriptor:(MethodDescriptor *)descriptor target:(id __nullable)target targetSelector:(SEL __nullable)targetSelector block:(id __nullable)block {
    MethodCallbackInfo * const callbackInfo = [[MethodCallbackInfo alloc] init];

    callbackInfo->_descriptor = descriptor;
    callbackInfo->_isOverride = YES;
    callbackInfo->_target = target;
    callbackInfo->_targetSelector = targetSelector;

    if (block != nil)
        callbackInfo->_block = (__bridge id)_Block_copy((__bridge const void *)block);
    else
        callbackInfo->_block = nil;

    return callbackInfo;
}

#pragma mark Initialization

- (void)dealloc {
    if (_block != nil)
        _Block_release((__bridge const void *)_block);
}

#pragma mark Methods

- (void)invoke:(NSInvocation *)invocation {
    __strong id target = _target;

    if (target != nil) {
        SEL const originalSelector = invocation.selector;
        if (_targetSelector != NULL)
            invocation.selector = _targetSelector;

        @try {
            [invocation invokeWithTarget:target];
        } @finally {
            if (_targetSelector != NULL)
                invocation.selector = originalSelector;
        }
    } else if (_block != nil) {
        NSString * const temporaryClassName = [NSString stringWithFormat:@"ProtocolProxy_block_invoke_%@", [[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:@""]];
        Class const temporaryClass = objc_allocateClassPair(NSProxy.class, temporaryClassName.UTF8String, 0);

        IMP const implementation = imp_implementationWithBlock(_block);
        class_addMethod(temporaryClass, invocation.selector, implementation, _descriptor.objCTypes);
        objc_registerClassPair(temporaryClass);

        id const proxy = [NSProxy alloc];
        Class originalClass = Nil;

        @try {
            originalClass = object_setClass(proxy, temporaryClass);
            [invocation invokeWithTarget:proxy];
        } @finally {
            object_setClass(proxy, originalClass);
            objc_disposeClassPair(temporaryClass);
            imp_removeBlock(implementation);
        }
    }
}

@end

#pragma mark - Private Function Declarations

static NSArray<MethodDescriptor *> *accessorMethodsForProperty(objc_property_t, BOOL);
static NSArray<Protocol *> *buildAdoptedProtocolsList(NSArray<Protocol *> *);

#pragma mark - Functions Definitions

id __nullable UnbalancedRetain(id __nullable object) {
    if (object != nil)
        object = (__bridge id)(__bridge_retained void *)object;

    return object;
}

void UnbalancedRelease(id __nullable object) {
    if (object != nil) {
        @autoreleasepool {
            object = (__bridge_transfer id)(__bridge void *)object;
            object = nil;
        }
    }
}

//

NSInvocation *copyInvocation(NSInvocation *invocation) {
    NSMethodSignature * const methodSignature = invocation.methodSignature;
    NSInvocation * const copy = [NSInvocation invocationWithMethodSignature:methodSignature];
    copy.selector = invocation.selector;

    uint8_t argumentStack[methodSignature.frameLength];

    for (NSUInteger i = 0; i < methodSignature.numberOfArguments; ++i) {
        [invocation getArgument:(void *)argumentStack atIndex:i];
        [copy setArgument:(void *)argumentStack atIndex:i];
    }

    return copy;
}

//

API_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
os_log_t protocolProxyLog(void) {
    static os_log_t log = NULL;
    static dispatch_once_t onceToken = 0;

    dispatch_once(&onceToken, ^{
        log = os_log_create("com.somerandomiosdev.protocolproxy", "ProtocolProxy");
    });

    return log;
}

//

NSArray<MethodDescriptor *> *buildMethodDescriptorList(NSArray<Protocol *> *protocols, NSArray<Protocol *> **adoptedProtocols) {
    NSArray<Protocol *> * const adoptedProtocolsList = buildAdoptedProtocolsList(protocols);
    const NSUInteger protocolCount = adoptedProtocolsList.count;

    if (adoptedProtocols != nil)
        *adoptedProtocols = adoptedProtocolsList;

    struct method_list { unsigned int count; const struct objc_method_description *methods; } completeMethodList[protocolCount][2];
    memset(completeMethodList, 0, sizeof(struct method_list) * protocolCount * 2);

    struct property_list { unsigned int count; const objc_property_t *properties; } completePropertyList[protocolCount][2];
    memset(completePropertyList, 0, sizeof(struct property_list) * protocolCount * 2);

    NSUInteger totalCount = 0;
    unsigned int protocolIndex = 0;
    for (Protocol *protocol in adoptedProtocolsList) {
        for (NSUInteger i = 0; i < 2; ++i) {
            const BOOL isRequired = (i == 0);
            unsigned int count = 0;

            {
                completeMethodList[protocolIndex][i].methods = protocol_copyMethodDescriptionList(protocol, isRequired, YES, &count);
                completeMethodList[protocolIndex][i].count = count;
            }

            if (@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)) {
                completePropertyList[protocolIndex][i].properties = protocol_copyPropertyList2(protocol, &count, isRequired, YES);
                completePropertyList[protocolIndex][i].count = count;
            }
            else if (i == 0) {
                completePropertyList[protocolIndex][i].properties = protocol_copyPropertyList(protocol, &count);
                completePropertyList[protocolIndex][i].count = count;
            }
            else {
                completePropertyList[protocolIndex][i].properties = NULL;
                completePropertyList[protocolIndex][i].count = 0;
            }

            totalCount += count;
        }

        protocolIndex++;
    }

    NSMutableArray<MethodDescriptor *> * const descriptorList = [NSMutableArray arrayWithCapacity:totalCount];

    for (NSUInteger protocolIndex = 0; protocolIndex < protocolCount; ++protocolIndex) {
        for (NSUInteger i = 0; i < 2; ++i) {
            const BOOL isRequired = (i == 0);

            const struct objc_method_description * const methods = completeMethodList[protocolIndex][i].methods;
            const NSUInteger methodCount = completeMethodList[protocolIndex][i].count;

            if (methods != NULL) {
                for (NSUInteger methodIndex = 0; methodIndex < methodCount; ++methodIndex) {
                    [descriptorList addObject:[MethodDescriptor descriptorWithName:methods[methodIndex].name
                                                                         objCTypes:methods[methodIndex].types
                                                                        isRequired:isRequired]];
                }

                free((void *)methods);
            }
        }
    }
    for (NSUInteger protocolIndex = 0; protocolIndex < protocolCount; ++protocolIndex) {
        for (NSUInteger mapIndex = 0; mapIndex < 2; ++mapIndex) {
            BOOL isRequired;

            if (@available(macOS 10.12, iOS 10.0, tvOS 10.0, watchOS 3.0, *)) {
                isRequired = (mapIndex == 0);
            } else if (mapIndex == 0) {
                isRequired = YES;
            } else {
                break;
            }

            const objc_property_t * const properties = completePropertyList[protocolIndex][mapIndex].properties;
            const NSUInteger propertyCount = completeMethodList[protocolIndex][mapIndex].count;

            if (properties != NULL) {
                for (NSUInteger propertyIndex = 0; propertyIndex < propertyCount && properties[propertyIndex] != NULL; ++propertyIndex) {
                    for (MethodDescriptor *propertyAccessor in accessorMethodsForProperty(properties[propertyIndex], isRequired)) {
                        const NSUInteger index = [descriptorList indexOfObjectPassingTest:^BOOL (MethodDescriptor *descriptor, NSUInteger i, BOOL *_) {
                            return sel_isEqual(descriptor.name, propertyAccessor.name);
                        }];
                        MethodDescriptor * const existingDescriptor = (index != NSNotFound ? [descriptorList objectAtIndex:index] : nil);

                        if (existingDescriptor == nil) {
                            [descriptorList addObject:propertyAccessor];
                        } else if (!existingDescriptor.isRequired && propertyAccessor.isRequired) {
                            MethodDescriptor * const descriptor = [MethodDescriptor descriptorWithName:existingDescriptor.name
                                                                                             objCTypes:existingDescriptor.objCTypes
                                                                                            isRequired:YES];

                            [descriptorList replaceObjectAtIndex:index withObject:descriptor];
                        }
                    }
                }

                free((void *)properties);
            }
        }
    }

    return [descriptorList copy];
}

MethodDescriptor * __nullable lookupMethodDescriptorForSelector(SEL selector, ProtocolProxy *self) {
    for (MethodDescriptor *descriptor in self->_descriptors) {
        if (sel_isEqual(selector, descriptor.name))
            return descriptor;
    }

    return nil;
}

NSArray<MethodCallbackInfo *> * __nullable lookupMethodCallbacksForSelector(SEL selector, ProtocolProxy *self) {
    NSMutableArray<MethodCallbackInfo *> * const callbacks = [NSMutableArray arrayWithCapacity:self->_callbacks.count];
    NSMutableIndexSet * const indexesToRemove = [NSMutableIndexSet indexSet];

    [self->_callbacks enumerateObjectsUsingBlock:^(MethodCallbackInfo *callback, NSUInteger i, BOOL *_) {
        if (callback.target == nil && callback.block == nil)
            [indexesToRemove addIndex:i];
        else if (sel_isEqual(selector, callback.descriptor.name))
            [callbacks addObject:callback];
    }];

    if (indexesToRemove.count > 0)
        [self->_callbacks removeObjectsAtIndexes:indexesToRemove];

    return callbacks.count > 0 ? [callbacks copy] : nil;
}

#pragma mark - Private Function Declarations

static NSArray<MethodDescriptor *> *accessorMethodsForProperty(objc_property_t property, BOOL isRequired) {
    const char *propertyName = property_getName(property);
    const char *attributes = property_getAttributes(property);

    BOOL isReadonly = NO;
    SEL getter = NULL, setter = NULL;
    NSString *types = nil;

    if (attributes != NULL) {
        for (NSString *attribute in [[NSString stringWithUTF8String:attributes] componentsSeparatedByString:@","]) {
            if ([attribute hasPrefix:@"R"]) { // readonly
                isReadonly = YES;
            } else if ([attribute hasPrefix:@"G"]) { // getter=<custom_getter>
                NSString * const customGetter = [attribute substringFromIndex:1];
                getter = sel_registerName(customGetter.UTF8String);
            } else if ([attribute hasPrefix:@"S"]) { // setter=<custom_setter:>
                NSString * const customSetter = [attribute substringFromIndex:1];
                setter = sel_registerName(customSetter.UTF8String);
            } else if ([attribute hasPrefix:@"T"]) {
                types = [attribute substringFromIndex:1];
            }
        }
    }

    if (getter == NULL) {
        getter = sel_registerName(propertyName);
    }
    if (setter == NULL && !isReadonly) {
        char setterName[strlen(propertyName) + 5];
        snprintf(setterName, strlen(propertyName) + 5, "set%c%s:", (char)toupper(propertyName[0]), (propertyName + 1));

        setter = sel_registerName(setterName);
    }

    NSMutableArray<MethodDescriptor *> * const descriptors = [NSMutableArray arrayWithCapacity:2];

    {
        const NSUInteger len = types.length + 3;
        char getterTypes[len];

        snprintf(getterTypes, len, "%s@:", types.UTF8String);

        [descriptors addObject:[MethodDescriptor descriptorWithName:getter
                                                          objCTypes:getterTypes
                                                         isRequired:isRequired]];
    }

    if (setter != NULL) {
        const size_t len = types.length + 4;
        char setterTypes[len];

        snprintf(setterTypes, len, "v@:%s", types.UTF8String);

        [descriptors addObject:[MethodDescriptor descriptorWithName:setter
                                                          objCTypes:setterTypes
                                                         isRequired:isRequired]];
    }

    return [descriptors copy];
}

static NSOrderedSet<Protocol *> *_buildAdoptedProtocolsList(Protocol *protocol) {
    NSMutableOrderedSet<Protocol *> * const adoptedProtocols = [NSMutableOrderedSet orderedSetWithObject:protocol];

    unsigned int protocolCount = 0;
    Protocol * const * const protocolList = protocol_copyProtocolList(protocol, &protocolCount);

    if (protocolList != NULL) {
        for (unsigned int i = 0; i < protocolCount; ++i) {
            [adoptedProtocols unionOrderedSet:_buildAdoptedProtocolsList(protocolList[i])];
        }

        free((void *)protocolList);
    }

    return adoptedProtocols;
}

static NSArray<Protocol *> *buildAdoptedProtocolsList(NSArray<Protocol *> *protocols) {
    NSMutableOrderedSet<Protocol *> * const adoptedProtocols = [NSMutableOrderedSet orderedSetWithCapacity:protocols.count];

    for (Protocol *protocol in protocols) {
        [adoptedProtocols unionOrderedSet:_buildAdoptedProtocolsList(protocol)];
    }

    return [NSArray arrayWithArray:adoptedProtocols.array];
}
