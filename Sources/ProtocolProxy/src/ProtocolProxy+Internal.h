//
//  ProtocolProxy+Internal.h
//  ProtocolProxy
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <os/log.h>

#import "ProtocolProxy.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Preprocessor Definitions

#if __has_attribute(objc_runtime_name)
# define OBJC_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define OBJC_RUNTIME_NAME(X)
#endif

#pragma mark - MethodDescriptor Interface

OBJC_RUNTIME_NAME("__ProtocolProxyMethodDescriptor")
@interface MethodDescriptor: NSObject

@property (nonatomic, assign, readonly) SEL name;
@property (nonatomic, assign, readonly) const char *objCTypes NS_RETURNS_INNER_POINTER;
@property (nonatomic, assign, readonly) BOOL isRequired;

+ (instancetype)descriptorWithName:(SEL)name objCTypes:(const char *)objCTypes isRequired:(BOOL)isRequired;

@end

#pragma mark - MethodCallbackInfo Interface

OBJC_RUNTIME_NAME("__ProtocolProxyMethodCallbackInfo")
@interface MethodCallbackInfo: NSObject

@property (nonatomic, assign, readonly)           BOOL isOverride;
@property (nonatomic, assign, readonly)           BOOL invokeBefore;
@property (nonatomic, strong, readonly)           MethodDescriptor *descriptor;

@property (nonatomic, weak, readonly, nullable)   id target;
@property (nonatomic, assign, readonly, nullable) SEL targetSelector;

@property (nonatomic, strong, readonly, nullable) id block;

+ (instancetype)callbackInfoWithDescriptor:(MethodDescriptor *)descriptor invokeBefore:(BOOL)invokeBefore target:(id __nullable)target targetSelector:(SEL __nullable)targetSelector block:(id __nullable)block;
+ (instancetype)overrideCallbackInfoWithDescriptor:(MethodDescriptor *)descriptor target:(id __nullable)target targetSelector:(SEL __nullable)targetSelector block:(id __nullable)block;

- (void)invoke:(NSInvocation *)invocation;

@end

#pragma mark - ProtocolProxy Extension

@interface ProtocolProxy() {
@package
    NSArray<MethodDescriptor *> *_descriptors;
    NSMutableArray<MethodCallbackInfo *> *_callbacks;
}

@end

#pragma mark - Function Declarations

id __nullable UnbalancedRetain(__nullable id);
void UnbalancedRelease(__nullable id);

NSInvocation *copyInvocation(NSInvocation *);

API_AVAILABLE(macos(10.12), ios(10.0), watchos(3.0), tvos(10.0))
os_log_t protocolProxyLog(void);

NSArray<MethodDescriptor *> *buildMethodDescriptorList(NSArray<Protocol *> *, NSArray<Protocol *> * __nullable * __nullable);
void ignoringReturnValuesForInvocation(NSInvocation *, void (^NS_NOESCAPE)(void));
MethodDescriptor * __nullable lookupMethodDescriptorForSelector(SEL, ProtocolProxy *);
NSArray<MethodCallbackInfo *> * __nullable lookupMethodCallbacksForSelector(SEL, ProtocolProxy *);

NS_ASSUME_NONNULL_END
