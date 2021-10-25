//
//  ProtocolProxyOverrideTests.m
//  ProtocolProxyTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@import ProtocolProxy;
@import ProtocolProxyTestsBase;
@import XCTest;

#pragma mark - ProtocolProxyOverrideTests Interface

@interface ProtocolProxyOverrideTests: XCTestCase
@end

#pragma mark - ProtocolProxyOverrideTests Implementation

@implementation ProtocolProxyOverrideTests

#pragma mark Test Methods

- (void)testOverrideWithBlocksNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;

    XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueNoArguments) usingBlock:^{
        observerCallCount++;
    }]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 0);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
}

- (void)testOverrideWithTargetNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueNoArguments) withTarget:overrideTarget]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueNoArguments)], 2);
}

- (void)testOverrideWithTargetAndAlternateSelectorNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueNoArguments) withTarget:overrideTarget targetSelector:@selector(_noReturnValueNoArguments)]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(_noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(_noReturnValueNoArguments)], 2);
}

#pragma mark -

- (void)testOverrideWithBlocksReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;
    __block NSObject *overrideValue;
    id returnValue = nil;

    XCTAssertTrue([proxy overrideSelector:@selector(returnValueNoArguments) usingBlock:^id {
        observerCallCount++;
        return overrideValue;
    }]);

    overrideValue = [[NSObject alloc] init];
    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertTrue([returnValue isEqual:overrideValue]);

    overrideValue = [[NSObject alloc] init];
    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertTrue([returnValue isEqual:overrideValue]);
}

- (void)testOverrideWithTargetReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:overrideTarget]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testOverrideWithTargetAndAlternateSelectorReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:overrideTarget targetSelector:@selector(_returnValueNoArguments)]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(_returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(_returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([overrideTarget callCountForSelector:@selector(_returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(_returnValueNoArguments))]);
}

#pragma mark -

- (void)testOverrideWithBlocksNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;

        XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueOneArgument:) usingBlock:^(id self, id arg) {
            XCTAssertTrue(argument == arg);
            observerCallCount++;
        }]);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;

        XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueTwoArguments::) usingBlock:^(id self, id arg1, id arg2) {
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
            observerCallCount++;
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
    }
}

- (void)testOverrideWithTargetNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueOneArgument:) withTarget:overrideTarget]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueTwoArguments::) withTarget:overrideTarget]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testOverrideWithTargetAndAlternateSelectorNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueOneArgument:) withTarget:overrideTarget targetSelector:@selector(_noReturnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_noReturnValueOneArgument:)], 1);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_noReturnValueOneArgument:)], 2);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(noReturnValueTwoArguments::) withTarget:overrideTarget targetSelector:@selector(_noReturnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_noReturnValueTwoArguments::)], 1);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_noReturnValueTwoArguments::)], 2);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertNil([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

#pragma mark -

- (void)testOverrideWithBlocksReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block NSObject *overrideValue;
        __block id argument = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueOneArgument:) usingBlock:^id (id self, id arg) {
            XCTAssertTrue(argument == arg);
            observerCallCount++;

            return overrideValue;
        }]);

        argument = [[NSObject alloc] init];
        overrideValue = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([returnValue isEqual:overrideValue]);

        argument = [[NSObject alloc] init];
        overrideValue = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([returnValue isEqual:overrideValue]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;
        __block NSObject *overrideValue;
        id returnValue = nil;

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueTwoArguments::) usingBlock:^id (id self, id arg1, id arg2) {
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
            observerCallCount++;

            return overrideValue;
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        overrideValue = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([returnValue isEqual:overrideValue]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        overrideValue = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([returnValue isEqual:overrideValue]);
    }
}

- (void)testOverrideWithTargetReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueOneArgument:) withTarget:overrideTarget]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueTwoArguments::) withTarget:overrideTarget]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueTwoArguments::)], 1);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testOverrideWithTargetAndAlternateSelectorReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueOneArgument:) withTarget:overrideTarget targetSelector:@selector(_returnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_returnValueOneArgument:)], 1);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(_returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_returnValueOneArgument:)], 2);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(_returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueTwoArguments::) withTarget:overrideTarget targetSelector:@selector(_returnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_returnValueTwoArguments::)], 1);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(_returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(_returnValueTwoArguments::)], 2);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertNil([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([overrideTarget argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(_returnValueTwoArguments::))]);
    }
}

#pragma mark -

- (void)testOverrideFailureCases {
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
    ArgsAndReturnValues * const overrideTarget = [[ArgsAndReturnValues alloc] init];

    // nil observer/block
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:(id __nonnull)nil]);
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:(id __nonnull)nil targetSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) usingBlock:(id __nonnull)nil]);

    // NULL selector
    XCTAssertFalse([proxy overrideSelector:(SEL __nonnull)NULL withTarget:overrideTarget]);
    XCTAssertFalse([proxy overrideSelector:(SEL __nonnull)NULL withTarget:overrideTarget targetSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy overrideSelector:(SEL __nonnull)NULL usingBlock:^{ }]);

    // Selector that isn't part of the adopted protocol(s)
    XCTAssertFalse([proxy overrideSelector:@selector(copyWithZone:) withTarget:overrideTarget]);
    XCTAssertFalse([proxy overrideSelector:@selector(copyWithZone:) withTarget:overrideTarget targetSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy overrideSelector:@selector(copyWithZone:) usingBlock:^{ }]);

    // Invalid block type
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) usingBlock:[[NSObject alloc] init]]);

    // Selector is already overridden with the proxy
    XCTAssertTrue([proxy overrideSelector:@selector(returnValueNoArguments) usingBlock:^id { return nil; }]);
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:overrideTarget]);
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:overrideTarget targetSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy overrideSelector:@selector(returnValueNoArguments) usingBlock:^{ }]);
}

- (void)testOverrideTargetIsntRetained {
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
    __weak ArgsAndReturnValues *weakOverrideTarget = nil;

    @autoreleasepool {
        ArgsAndReturnValues *overrideTarget = [[ArgsAndReturnValues alloc] init];
        weakOverrideTarget = overrideTarget;

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:overrideTarget]);
        overrideTarget = nil;
    }

    XCTAssertNil(weakOverrideTarget);

    //

    @autoreleasepool {
        ArgsAndReturnValues *overrideTarget = [[ArgsAndReturnValues alloc] init];
        weakOverrideTarget = overrideTarget;

        XCTAssertTrue([proxy overrideSelector:@selector(returnValueNoArguments) withTarget:overrideTarget targetSelector:@selector(_returnValueNoArguments)]);
        overrideTarget = nil;
    }

    XCTAssertNil(weakOverrideTarget);
}

- (void)testOverrideIsUnregisteredAfterBeingFreed {
    __weak ArgsAndReturnValues *weakOverrideTarget = nil;
    ArgsAndReturnValues *implementer = nil;
    ProtocolProxy *proxy = nil;

    @autoreleasepool {
        implementer = [[ArgsAndReturnValues alloc] init];
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        ArgsAndReturnValues *overrideTarget = [[ArgsAndReturnValues alloc] init];
        weakOverrideTarget = overrideTarget;
        XCTAssertTrue([proxy overrideSelector:@selector(returnValueOneArgument:) withTarget:overrideTarget]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([overrideTarget callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertNil([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([overrideTarget argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        overrideTarget = nil;
    }

    XCTAssertNil(weakOverrideTarget);

    id argument = [[NSObject alloc] init];
    id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
    XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
}

@end
