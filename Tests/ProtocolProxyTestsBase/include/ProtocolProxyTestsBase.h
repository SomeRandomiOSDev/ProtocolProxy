//
//  ProtocolProxyTestsBase.h
//  ProtocolProxyTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - BasicTestProtocol Definition

@protocol BasicTestProtocol <NSObject>
@required
- (void)foobar;

@optional
- (void)maybeFoobar;
@end

#pragma mark - ArgsAndReturnValuesProtocol Definition

@protocol ArgsAndReturnValuesProtocol <NSObject>

- (void)noReturnValueNoArguments;
- (void)noReturnValueOneArgument:(id)argument;
- (void)noReturnValueTwoArguments:(id)argument1 :(id)argument2;

- (nullable id)returnValueNoArguments;
- (nullable id)returnValueOneArgument:(id)argument;
- (nullable id)returnValueTwoArguments:(id)argument1 :(id)argument2;

@end

#pragma mark - ProtocolProxyPropertiesProtocol Definition

@protocol ProtocolProxyPropertiesProtocol <NSObject>
@required

@property (nonatomic, weak, readonly, nullable) id implementer;
@property (nonatomic, strong, readonly)         NSArray<Protocol *> *adoptedProtocols;
@property (nonatomic, assign)                   BOOL respondsToSelectorsWithObservers;

@property (nonatomic, assign, readonly)         NSUInteger foobarCount;
- (void)foobar;

@optional
- (void)dontActuallyImplementThis;

@end

#pragma mark - AllPropertyAttributeCombinationsProtocol Definition

@protocol AllPropertyAttributeCombinationsProtocol <NSObject>

@property (nonatomic, assign)                                                                          NSInteger assignProperty0;
@property (atomic,    assign)                                                                          NSInteger assignProperty1;
@property (nonatomic, assign, readonly)                                                                NSInteger assignProperty2;
@property (atomic,    assign, readonly)                                                                NSInteger assignProperty3;
@property (nonatomic, assign, readonly, getter=customAssignProperty4Getter)                            NSInteger assignProperty4;
@property (atomic,    assign, readonly, getter=customAssignProperty5Getter)                            NSInteger assignProperty5;
@property (nonatomic, assign, getter=customAssignProperty6Getter)                                      NSInteger assignProperty6;
@property (atomic,    assign, getter=customAssignProperty7Getter)                                      NSInteger assignProperty7;
@property (nonatomic, assign, setter=customAssignProperty8Setter:, getter=customAssignProperty8Getter) NSInteger assignProperty8;
@property (atomic,    assign, setter=customAssignProperty9Setter:, getter=customAssignProperty9Getter) NSInteger assignProperty9;
@property (nonatomic, assign, setter=customAssignProperty10Setter:)                                    NSInteger assignProperty10;
@property (atomic,    assign, setter=customAssignProperty11Setter:)                                    NSInteger assignProperty11;

//

@property (nonatomic, strong)                                                                                      id strongProperty0;
@property (atomic,    strong)                                                                                      id strongProperty1;
@property (nonatomic, strong, readonly)                                                                            id strongProperty2;
@property (atomic,    strong, readonly)                                                                            id strongProperty3;
@property (nonatomic, strong, readonly, getter=customStrongProperty4Getter)                                        id strongProperty4;
@property (atomic,    strong, readonly, getter=customStrongProperty5Getter)                                        id strongProperty5;
@property (nonatomic, strong, getter=customStrongProperty6Getter)                                                  id strongProperty6;
@property (atomic,    strong, getter=customStrongProperty7Getter)                                                  id strongProperty7;
@property (nonatomic, strong, setter=customStrongProperty8Setter:, getter=customStrongProperty8Getter)             id strongProperty8;
@property (atomic,    strong, setter=customStrongProperty9Setter:, getter=customStrongProperty9Getter)             id strongProperty9;
@property (nonatomic, strong, setter=customStrongProperty10Setter:)                                                id strongProperty10;
@property (atomic,    strong, setter=customStrongProperty11Setter:)                                                id strongProperty11;
@property (nonatomic, strong, nullable)                                                                            id strongProperty12;
@property (atomic,    strong, nullable)                                                                            id strongProperty13;
@property (nonatomic, strong, readonly, nullable)                                                                  id strongProperty14;
@property (atomic,    strong, readonly, nullable)                                                                  id strongProperty15;
@property (nonatomic, strong, readonly, getter=customStrongProperty16Getter, nullable)                             id strongProperty16;
@property (atomic,    strong, readonly, getter=customStrongProperty17Getter, nullable)                             id strongProperty17;
@property (nonatomic, strong, getter=customStrongProperty18Getter, nullable)                                       id strongProperty18;
@property (atomic,    strong, getter=customStrongProperty19Getter, nullable)                                       id strongProperty19;
@property (nonatomic, strong, setter=customStrongProperty20Setter:, getter=customStrongProperty20Getter, nullable) id strongProperty20;
@property (atomic,    strong, setter=customStrongProperty21Setter:, getter=customStrongProperty21Getter, nullable) id strongProperty21;
@property (nonatomic, strong, setter=customStrongProperty22Setter:, nullable)                                      id strongProperty22;
@property (atomic,    strong, setter=customStrongProperty23Setter:, nullable)                                      id strongProperty23;

//

@property (nonatomic, weak)                                                                                  id weakProperty0;
@property (atomic,    weak)                                                                                  id weakProperty1;
@property (nonatomic, weak, readonly)                                                                        id weakProperty2;
@property (atomic,    weak, readonly)                                                                        id weakProperty3;
@property (nonatomic, weak, readonly, getter=customWeakProperty4Getter)                                      id weakProperty4;
@property (atomic,    weak, readonly, getter=customWeakProperty5Getter)                                      id weakProperty5;
@property (nonatomic, weak, getter=customWeakProperty6Getter)                                                id weakProperty6;
@property (atomic,    weak, getter=customWeakProperty7Getter)                                                id weakProperty7;
@property (nonatomic, weak, setter=customWeakProperty8Setter:, getter=customWeakProperty8Getter)             id weakProperty8;
@property (atomic,    weak, setter=customWeakProperty9Setter:, getter=customWeakProperty9Getter)             id weakProperty9;
@property (nonatomic, weak, setter=customWeakProperty10Setter:)                                              id weakProperty10;
@property (atomic,    weak, setter=customWeakProperty11Setter:)                                              id weakProperty11;
@property (nonatomic, weak, nullable)                                                                        id weakProperty12;
@property (atomic,    weak, nullable)                                                                        id weakProperty13;
@property (nonatomic, weak, readonly, nullable)                                                              id weakProperty14;
@property (atomic,    weak, readonly, nullable)                                                              id weakProperty15;
@property (nonatomic, weak, readonly, getter=customWeakProperty16Getter, nullable)                           id weakProperty16;
@property (atomic,    weak, readonly, getter=customWeakProperty17Getter, nullable)                           id weakProperty17;
@property (nonatomic, weak, getter=customWeakProperty18Getter, nullable)                                     id weakProperty18;
@property (atomic,    weak, getter=customWeakProperty19Getter, nullable)                                     id weakProperty19;
@property (nonatomic, weak, setter=customWeakProperty20Setter:, getter=customWeakProperty20Getter, nullable) id weakProperty20;
@property (atomic,    weak, setter=customWeakProperty21Setter:, getter=customWeakProperty21Getter, nullable) id weakProperty21;
@property (nonatomic, weak, setter=customWeakProperty22Setter:, nullable)                                    id weakProperty22;
@property (atomic,    weak, setter=customWeakProperty23Setter:, nullable)                                    id weakProperty23;

//

@property (nonatomic, copy)                                                                                  id copyProperty0;
@property (atomic,    copy)                                                                                  id copyProperty1;
@property (nonatomic, copy, readonly)                                                                        id copyProperty2;
@property (atomic,    copy, readonly)                                                                        id copyProperty3;
@property (nonatomic, copy, readonly, getter=customCopyProperty4Getter)                                      id copyProperty4;
@property (atomic,    copy, readonly, getter=customCopyProperty5Getter)                                      id copyProperty5;
@property (nonatomic, copy, getter=customCopyProperty6Getter)                                                id copyProperty6;
@property (atomic,    copy, getter=customCopyProperty7Getter)                                                id copyProperty7;
@property (nonatomic, copy, setter=customCopyProperty8Setter:, getter=customCopyProperty8Getter)             id copyProperty8;
@property (atomic,    copy, setter=customCopyProperty9Setter:, getter=customCopyProperty9Getter)             id copyProperty9;
@property (nonatomic, copy, setter=customCopyProperty10Setter:)                                              id copyProperty10;
@property (atomic,    copy, setter=customCopyProperty11Setter:)                                              id copyProperty11;
@property (nonatomic, copy, nullable)                                                                        id copyProperty12;
@property (atomic,    copy, nullable)                                                                        id copyProperty13;
@property (nonatomic, copy, readonly, nullable)                                                              id copyProperty14;
@property (atomic,    copy, readonly, nullable)                                                              id copyProperty15;
@property (nonatomic, copy, readonly, getter=customCopyProperty16Getter, nullable)                           id copyProperty16;
@property (atomic,    copy, readonly, getter=customCopyProperty17Getter, nullable)                           id copyProperty17;
@property (nonatomic, copy, getter=customCopyProperty18Getter, nullable)                                     id copyProperty18;
@property (atomic,    copy, getter=customCopyProperty19Getter, nullable)                                     id copyProperty19;
@property (nonatomic, copy, setter=customCopyProperty20Setter:, getter=customCopyProperty20Getter, nullable) id copyProperty20;
@property (atomic,    copy, setter=customCopyProperty21Setter:, getter=customCopyProperty21Getter, nullable) id copyProperty21;
@property (nonatomic, copy, setter=customCopyProperty22Setter:, nullable)                                    id copyProperty22;
@property (atomic,    copy, setter=customCopyProperty23Setter:, nullable)                                    id copyProperty23;

//

@property (nonatomic, unsafe_unretained)                                                                                                          id unsafeUnretainedProperty0;
@property (atomic,    unsafe_unretained)                                                                                                          id unsafeUnretainedProperty1;
@property (nonatomic, unsafe_unretained, readonly)                                                                                                id unsafeUnretainedProperty2;
@property (atomic,    unsafe_unretained, readonly)                                                                                                id unsafeUnretainedProperty3;
@property (nonatomic, unsafe_unretained, readonly, getter=customUnsafeUnretainedProperty4Getter)                                                  id unsafeUnretainedProperty4;
@property (atomic,    unsafe_unretained, readonly, getter=customUnsafeUnretainedProperty5Getter)                                                  id unsafeUnretainedProperty5;
@property (nonatomic, unsafe_unretained, getter=customUnsafeUnretainedProperty6Getter)                                                            id unsafeUnretainedProperty6;
@property (atomic,    unsafe_unretained, getter=customUnsafeUnretainedProperty7Getter)                                                            id unsafeUnretainedProperty7;
@property (nonatomic, unsafe_unretained, setter=customUnsafeUnretainedProperty8Setter:, getter=customUnsafeUnretainedProperty8Getter)             id unsafeUnretainedProperty8;
@property (atomic,    unsafe_unretained, setter=customUnsafeUnretainedProperty9Setter:, getter=customUnsafeUnretainedProperty9Getter)             id unsafeUnretainedProperty9;
@property (nonatomic, unsafe_unretained, setter=customUnsafeUnretainedProperty10Setter:)                                                          id unsafeUnretainedProperty10;
@property (atomic,    unsafe_unretained, setter=customUnsafeUnretainedProperty11Setter:)                                                          id unsafeUnretainedProperty11;
@property (nonatomic, unsafe_unretained, nullable)                                                                                                id unsafeUnretainedProperty12;
@property (atomic,    unsafe_unretained, nullable)                                                                                                id unsafeUnretainedProperty13;
@property (nonatomic, unsafe_unretained, readonly, nullable)                                                                                      id unsafeUnretainedProperty14;
@property (atomic,    unsafe_unretained, readonly, nullable)                                                                                      id unsafeUnretainedProperty15;
@property (nonatomic, unsafe_unretained, readonly, getter=customUnsafeUnretainedProperty16Getter, nullable)                                       id unsafeUnretainedProperty16;
@property (atomic,    unsafe_unretained, readonly, getter=customUnsafeUnretainedProperty17Getter, nullable)                                       id unsafeUnretainedProperty17;
@property (nonatomic, unsafe_unretained, getter=customUnsafeUnretainedProperty18Getter, nullable)                                                 id unsafeUnretainedProperty18;
@property (atomic,    unsafe_unretained, getter=customUnsafeUnretainedProperty19Getter, nullable)                                                 id unsafeUnretainedProperty19;
@property (nonatomic, unsafe_unretained, setter=customUnsafeUnretainedProperty20Setter:, getter=customUnsafeUnretainedProperty20Getter, nullable) id unsafeUnretainedProperty20;
@property (atomic,    unsafe_unretained, setter=customUnsafeUnretainedProperty21Setter:, getter=customUnsafeUnretainedProperty21Getter, nullable) id unsafeUnretainedProperty21;
@property (nonatomic, unsafe_unretained, setter=customUnsafeUnretainedProperty22Setter:, nullable)                                                id unsafeUnretainedProperty22;
@property (atomic,    unsafe_unretained, setter=customUnsafeUnretainedProperty23Setter:, nullable)                                                id unsafeUnretainedProperty23;

@end

#pragma mark - BasicTestClass Interface

@interface BasicTestClass: NSObject

#pragma mark Properties

@property (nonatomic, weak) id<BasicTestProtocol> delegate;

#pragma mark Methods

- (void)foobar;
- (void)maybeFoobar;

@end

#pragma mark - BasicTestDelegate Interface

@interface BasicTestDelegate: NSObject<BasicTestProtocol>

#pragma mark Properties

@property (nonatomic, assign, readonly) NSUInteger foobarCount;
@property (nonatomic, assign, readonly) NSUInteger maybeFoobarCount;

@end

#pragma mark - BasicTestDelegate2 Interface

@interface BasicTestDelegate2: BasicTestDelegate
@end

#pragma mark - ArgsAndReturnValues Interface

@interface ArgsAndReturnValues: NSObject<ArgsAndReturnValuesProtocol>

#pragma mark Methods

- (NSInteger)callCountForSelector:(SEL)selector;
- (nullable id)argumentForSelector:(SEL)selector atIndex:(NSInteger)index;

- (void)_noReturnValueNoArguments;
- (void)_noReturnValueOneArgument:(id)argument;
- (void)_noReturnValueTwoArguments:(id)argument1 :(id)argument2;

- (id)_returnValueNoArguments;
- (id)_returnValueOneArgument:(id)argument;
- (id)_returnValueTwoArguments:(id)argument1 :(id)argument2;

@end

#pragma mark - ProtocolProxyPropertiesProtocolImplementer Interface

@interface ProtocolProxyPropertiesProtocolImplementer: NSObject<ProtocolProxyPropertiesProtocol>

@property (nonatomic, weak, nullable) id implementer;
@property (nonatomic, strong)         NSArray<Protocol *> *adoptedProtocols;
@property (nonatomic, assign)         BOOL respondsToSelectorsWithObservers;

@end

NS_ASSUME_NONNULL_END
