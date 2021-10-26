//
//  ProtocolProxyTestsBase.m
//  ProtocolProxyTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

#import "ProtocolProxyTestsBase.h"

#pragma mark - BasicTestClass Implementation

@implementation BasicTestClass

#pragma mark Property Synthesis

@synthesize delegate = _delegate;

#pragma mark Public Methods

- (void)foobar {
    [_delegate foobar];
}

- (void)maybeFoobar {
    if ([_delegate respondsToSelector:@selector(maybeFoobar)])
        [_delegate maybeFoobar];
}

@end

#pragma mark - BasicTestDelegate Implementation

@implementation BasicTestDelegate
{
    @protected
    NSUInteger _maybeFoobarCount;
}

#pragma mark Property Synthesis

@synthesize foobarCount = _foobarCount, maybeFoobarCount = _maybeFoobarCount;

#pragma mark BasicTestProtocol Protocol Requirements

- (void)foobar {
    _foobarCount++;
}

@end

#pragma mark - BasicTestDelegate2 Implementation

@implementation BasicTestDelegate2

#pragma mark BasicTestProtocol Protocol Requirements

- (void)maybeFoobar {
    _maybeFoobarCount++;
}

@end

#pragma mark - ArgsAndReturnValues Implementation

@implementation ArgsAndReturnValues {
    NSMutableDictionary<NSString *, NSArray *> *_lastMethodCalls;
}

#pragma mark Initialization

- (instancetype)init {
    if (self = [super init])
        _lastMethodCalls = [NSMutableDictionary dictionaryWithCapacity:5];

    return self;
}

#pragma mark Public Methods

- (NSInteger)callCountForSelector:(SEL)selector {
    return ((NSNumber *)_lastMethodCalls[NSStringFromSelector(selector)].firstObject).integerValue;
}

- (nullable id)argumentForSelector:(SEL)selector atIndex:(NSInteger)index {
    index++; // account for 'count' object in array

    if (index < _lastMethodCalls[NSStringFromSelector(selector)].count)
        return [_lastMethodCalls[NSStringFromSelector(selector)] objectAtIndex:index];

    return nil;
}

//

- (void)_noReturnValueNoArguments {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1)];
}

- (void)_noReturnValueOneArgument:(id)argument {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument];
}

- (void)_noReturnValueTwoArguments:(id)argument1 :(id)argument2 {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument1, argument2];
}

- (id)_returnValueNoArguments {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1)];
    return key;
}

- (id)_returnValueOneArgument:(id)argument {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument];
    return key;
}

- (id)_returnValueTwoArguments:(id)argument1 :(id)argument2 {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument1, argument2];
    return key;
}

#pragma mark ArgsAndReturnValuesProtocol Protocol Requirements

- (void)noReturnValueNoArguments {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1)];
}

- (void)noReturnValueOneArgument:(id)argument {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument];
}

- (void)noReturnValueTwoArguments:(id)argument1 :(id)argument2 {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument1, argument2];
}

- (id)returnValueNoArguments {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1)];
    return key;
}

- (id)returnValueOneArgument:(id)argument {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument];
    return key;
}

- (id)returnValueTwoArguments:(id)argument1 :(id)argument2 {
    NSString * const key = NSStringFromSelector(_cmd);
    NSNumber * const lastCallCount = _lastMethodCalls[key].firstObject;

    _lastMethodCalls[key] = @[@(lastCallCount.unsignedIntegerValue + 1), argument1, argument2];
    return key;
}

@end

#pragma mark - ProtocolProxyPropertiesProtocolImplementer Implementation

@implementation ProtocolProxyPropertiesProtocolImplementer

#pragma mark Property Synthesis

@synthesize implementer, adoptedProtocols, respondsToSelectorsWithObservers, foobarCount = _foobarCount;

- (void)foobar {
    _foobarCount++;
}

@end
