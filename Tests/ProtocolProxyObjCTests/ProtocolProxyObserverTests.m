//
//  ProtocolProxyObserverTests.m
//  ProtocolProxyTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@import ProtocolProxy;
@import ProtocolProxyTestsBase;
@import XCTest;

#pragma mark - ProtocolProxyObserverTests Interface

@interface ProtocolProxyObserverTests: XCTestCase
@end

#pragma mark - ProtocolProxyObserverTests Implementation

@implementation ProtocolProxyObserverTests

#pragma mark Test Methods

- (void)testObserveBeforeWithBlocksNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;

    XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueNoArguments)];
        XCTAssertEqual(callCount, observerCallCount++);
    }]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
}

- (void)testObserveAfterWithBlocksNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;

    XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:NO usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueNoArguments)];
        XCTAssertEqual(callCount, ++observerCallCount);
    }]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
}

- (void)testObserveBeforeAndAfterWithBlocksNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;

    XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueNoArguments)];
        XCTAssertEqual(callCount, observerCallCount++);
    }]);
    XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:NO usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueNoArguments)];
        XCTAssertEqual(callCount, observerCallCount);
    }]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
}

//

- (void)testObserveBeforeWithTargetNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
}

- (void)testObserveAfterWithTargetNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:NO]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
}

- (void)testObserveBeforeAndAfterWithTargetNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES]);
    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:NO]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 2);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 4);
}

//

- (void)testObserveBeforeWithTargetAndAlternateSelectorNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES observerSelector:@selector(_noReturnValueNoArguments)]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueNoArguments)], 2);
}

- (void)testObserveAfterWithTargetAndAlternateSelectorNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:NO observerSelector:@selector(_noReturnValueNoArguments)]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueNoArguments)], 1);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueNoArguments)], 2);
}

- (void)testObserveBeforeAndAfterWithTargetAndAlternateSelectorNoReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES observerSelector:@selector(_noReturnValueNoArguments)]);
    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:NO observerSelector:@selector(_noReturnValueNoArguments)]);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueNoArguments)], 2);

    [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueNoArguments)], 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueNoArguments)], 4);
}

#pragma mark -

- (void)testObserveBeforeWithBlocksReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;
    id returnValue = nil;

    XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueNoArguments)];
        XCTAssertEqual(callCount, observerCallCount++);
    }]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testObserveAfterWithBlocksReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;
    id returnValue = nil;

    XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueNoArguments)];
        XCTAssertEqual(callCount, ++observerCallCount);
    }]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testObserveBeforeAndAfterWithBlocksReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    __block NSUInteger observerCallCount = 0;
    id returnValue = nil;

    XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueNoArguments)];
        XCTAssertEqual(callCount, observerCallCount++);
    }]);
    XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO usingBlock:^{
        const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueNoArguments)];
        XCTAssertEqual(callCount, observerCallCount);
    }]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

//

- (void)testObserveBeforeWithTargetReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testObserveAfterWithTargetReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testObserveBeforeAndAfterWithTargetReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES]);
    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 4);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

//

- (void)testObserveBeforeWithTargetAndAlternateSelectorReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES observerSelector:@selector(_returnValueNoArguments)]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testObserveAfterWithTargetAndAlternateSelectorReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO observerSelector:@selector(_returnValueNoArguments)]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_returnValueNoArguments)], 1);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

- (void)testObserveBeforeAndAfterWithTargetAndAlternateSelectorReturnValueNoArguments {
    ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

    id returnValue = nil;

    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES observerSelector:@selector(_returnValueNoArguments)]);
    XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO observerSelector:@selector(_returnValueNoArguments)]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 1);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_returnValueNoArguments)], 2);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);

    returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
    XCTAssertEqual([implementer callCountForSelector:@selector(returnValueNoArguments)], 2);
    XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(returnValueNoArguments)], 0);
    XCTAssertEqual([observer callCountForSelector:@selector(_returnValueNoArguments)], 4);
    XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueNoArguments))]);
}

#pragma mark -

- (void)testObserveBeforeWithBlocksNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueOneArgument:)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument == arg);
        }]);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueTwoArguments::)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testObserveAfterWithBlocksNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:NO usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueOneArgument:)];
            XCTAssertEqual(callCount, ++observerCallCount);
            XCTAssertTrue(argument == arg);
        }]);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:NO usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueTwoArguments::)];
            XCTAssertEqual(callCount, ++observerCallCount);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testObserveBeforeAndAfterWithBlocksNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueOneArgument:)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument == arg);
        }]);
        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:NO usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueOneArgument:)];
            XCTAssertEqual(callCount, observerCallCount);
            XCTAssertTrue(argument == arg);
        }]);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueTwoArguments::)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
        }]);
        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:NO usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(noReturnValueTwoArguments::)];
            XCTAssertEqual(callCount, observerCallCount);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

//

- (void)testObserveBeforeWithTargetNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testObserveAfterWithTargetNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:NO]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:NO]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testObserveBeforeAndAfterWithTargetNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:NO]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 4);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:NO]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 4);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

//

- (void)testObserveBeforeWithTargetAndAlternateSelectorNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES observerSelector:@selector(_noReturnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueOneArgument:)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueOneArgument:)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES observerSelector:@selector(_noReturnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testObserveAfterWithTargetAndAlternateSelectorNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:NO observerSelector:@selector(_noReturnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueOneArgument:)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueOneArgument:)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:NO observerSelector:@selector(_noReturnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

- (void)testObserveBeforeAndAfterWithTargetAndAlternateSelectorNoReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES observerSelector:@selector(_noReturnValueOneArgument:)]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:NO observerSelector:@selector(_noReturnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueOneArgument:)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);

        argument = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueOneArgument:)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueOneArgument:)], 4);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueOneArgument:) atIndex:0] == argument);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES observerSelector:@selector(_noReturnValueTwoArguments::)]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:NO observerSelector:@selector(_noReturnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(noReturnValueTwoArguments::)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(noReturnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_noReturnValueTwoArguments::)], 4);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(noReturnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_noReturnValueTwoArguments::) atIndex:1] == argument2);
    }
}

#pragma mark -

- (void)testObserveBeforeWithBlocksReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueOneArgument:)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument == arg);
        }]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueTwoArguments::)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);

            return [[NSObject alloc] init];
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testObserveAfterWithBlocksReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueOneArgument:)];
            XCTAssertEqual(callCount, ++observerCallCount);
            XCTAssertTrue(argument == arg);
        }]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:NO usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueTwoArguments::)];
            XCTAssertEqual(callCount, ++observerCallCount);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);

            return [[NSObject alloc] init];
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testObserveBeforeAndAfterWithBlocksReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueOneArgument:)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument == arg);
        }]);
        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO usingBlock:^(id self, id arg) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueOneArgument:)];
            XCTAssertEqual(callCount, observerCallCount);
            XCTAssertTrue(argument == arg);
        }]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        __block NSUInteger observerCallCount = 0;
        __block id argument1 = nil, argument2 = nil;
        id returnValue = nil;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueTwoArguments::)];
            XCTAssertEqual(callCount, observerCallCount++);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);

            return [[NSObject alloc] init];
        }]);
        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:NO usingBlock:^(id self, id arg1, id arg2) {
            const NSUInteger callCount = [implementer callCountForSelector:@selector(returnValueTwoArguments::)];
            XCTAssertEqual(callCount, observerCallCount);
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);

            return [[NSObject alloc] init];
        }]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

//

- (void)testObserveBeforeWithTargetReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testObserveAfterWithTargetReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:NO]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testObserveBeforeAndAfterWithTargetReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 4);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:NO]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 4);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

//

- (void)testObserveBeforeWithTargetAndAlternateSelectorReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES observerSelector:@selector(_returnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueOneArgument:)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueOneArgument:)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES observerSelector:@selector(_returnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueTwoArguments::)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueTwoArguments::)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testObserveAfterWithTargetAndAlternateSelectorReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO observerSelector:@selector(_returnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueOneArgument:)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueOneArgument:)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:NO observerSelector:@selector(_returnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueTwoArguments::)], 1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueTwoArguments::)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

- (void)testObserveBeforeAndAfterWithTargetAndAlternateSelectorReturnValueAndArguments {
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES observerSelector:@selector(_returnValueOneArgument:)]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO observerSelector:@selector(_returnValueOneArgument:)]);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueOneArgument:)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

        argument = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueOneArgument:)], 4);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueOneArgument:) atIndex:0] == argument);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        ArgsAndReturnValues * const implementer = [[ArgsAndReturnValues alloc] init];
        ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES observerSelector:@selector(_returnValueTwoArguments::)]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:NO observerSelector:@selector(_returnValueTwoArguments::)]);

        id argument1 = [[NSObject alloc] init];
        id argument2 = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 1);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueTwoArguments::)], 2);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);

        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueTwoArguments::)], 2);
        XCTAssertEqual([implementer callCountForSelector:@selector(_returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(returnValueTwoArguments::)], 0);
        XCTAssertEqual([observer callCountForSelector:@selector(_returnValueTwoArguments::)], 4);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0] == argument1);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:0]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:0] == argument1);

        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1] == argument2);
        XCTAssertNil([implementer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1]);
        XCTAssertNil([observer argumentForSelector:@selector(returnValueTwoArguments::) atIndex:1]);
        XCTAssertTrue([observer argumentForSelector:@selector(_returnValueTwoArguments::) atIndex:1] == argument2);
        
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueTwoArguments::))]);
    }
}

#pragma mark -

- (void)testAddObserverFailureCases {
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
    ArgsAndReturnValues * const observer = [[ArgsAndReturnValues alloc] init];

    // nil observer/block
    XCTAssertFalse([proxy addObserver:(id __nonnull)nil forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES]);
    XCTAssertFalse([proxy addObserver:(id __nonnull)nil forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO]);
    XCTAssertFalse([proxy addObserver:(id __nonnull)nil forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES observerSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy addObserver:(id __nonnull)nil forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO observerSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES usingBlock:(id __nonnull)nil]);
    XCTAssertFalse([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO usingBlock:(id __nonnull)nil]);

    // NULL selector
    XCTAssertFalse([proxy addObserver:observer forSelector:(SEL __nonnull)NULL beforeObservedSelector:YES]);
    XCTAssertFalse([proxy addObserver:observer forSelector:(SEL __nonnull)NULL beforeObservedSelector:NO]);
    XCTAssertFalse([proxy addObserver:observer forSelector:(SEL __nonnull)NULL beforeObservedSelector:YES observerSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy addObserver:observer forSelector:(SEL __nonnull)NULL beforeObservedSelector:NO observerSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy addObserverForSelector:(SEL __nonnull)NULL beforeObservedSelector:YES usingBlock:^{ }]);
    XCTAssertFalse([proxy addObserverForSelector:(SEL __nonnull)NULL beforeObservedSelector:NO usingBlock:^{ }]);

    // Selector that isn't part of the adopted protocol(s)
    XCTAssertFalse([proxy addObserver:observer forSelector:@selector(copyWithZone:) beforeObservedSelector:YES]);
    XCTAssertFalse([proxy addObserver:observer forSelector:@selector(copyWithZone:) beforeObservedSelector:NO]);
    XCTAssertFalse([proxy addObserver:observer forSelector:@selector(copyWithZone:) beforeObservedSelector:YES observerSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy addObserver:observer forSelector:@selector(copyWithZone:) beforeObservedSelector:NO observerSelector:@selector(returnValueNoArguments)]);
    XCTAssertFalse([proxy addObserverForSelector:@selector(copyWithZone:) beforeObservedSelector:YES usingBlock:^{ }]);
    XCTAssertFalse([proxy addObserverForSelector:@selector(copyWithZone:) beforeObservedSelector:NO usingBlock:^{ }]);

    // Invalid block type
    XCTAssertFalse([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES usingBlock:[[NSObject alloc] init]]);
    XCTAssertFalse([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO usingBlock:[[NSObject alloc] init]]);
}

- (void)testObserverIsntRetained {
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
    __weak ArgsAndReturnValues *weakObserver = nil;

    @autoreleasepool {
        ArgsAndReturnValues *observer = [[ArgsAndReturnValues alloc] init];
        weakObserver = observer;

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES]);
        observer = nil;
    }

    XCTAssertNil(weakObserver);

    //

    @autoreleasepool {
        ArgsAndReturnValues *observer = [[ArgsAndReturnValues alloc] init];
        weakObserver = observer;

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO]);
        observer = nil;
    }

    XCTAssertNil(weakObserver);

    //

    @autoreleasepool {
        ArgsAndReturnValues *observer = [[ArgsAndReturnValues alloc] init];
        weakObserver = observer;

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueNoArguments) beforeObservedSelector:NO]);
        observer = nil;
    }

    XCTAssertNil(weakObserver);
}

- (void)testObserverIsUnregisteredAfterBeingFreed {
    __weak ArgsAndReturnValues *weakObserver = nil;
    ArgsAndReturnValues *implementer = nil;
    ProtocolProxy *proxy = nil;

    {
        @autoreleasepool {
            implementer = [[ArgsAndReturnValues alloc] init];
            proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

            ArgsAndReturnValues *observer = [[ArgsAndReturnValues alloc] init];
            weakObserver = observer;
            XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES]);

            id argument = [[NSObject alloc] init];
            id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
            XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
            XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 1);
            XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
            XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
            XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

            observer = nil;
        }

        XCTAssertNil(weakObserver);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
    {
        @autoreleasepool {
            implementer = [[ArgsAndReturnValues alloc] init];
            proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:implementer];

            ArgsAndReturnValues *observer = [[ArgsAndReturnValues alloc] init];
            weakObserver = observer;
            XCTAssertTrue([proxy addObserver:observer forSelector:@selector(returnValueOneArgument:) beforeObservedSelector:NO]);

            id argument = [[NSObject alloc] init];
            id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
            XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 1);
            XCTAssertEqual([observer callCountForSelector:@selector(returnValueOneArgument:)], 1);
            XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
            XCTAssertTrue([observer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
            XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);

            observer = nil;
        }

        XCTAssertNil(weakObserver);

        id argument = [[NSObject alloc] init];
        id returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument];
        XCTAssertEqual([implementer callCountForSelector:@selector(returnValueOneArgument:)], 2);
        XCTAssertTrue([implementer argumentForSelector:@selector(returnValueOneArgument:) atIndex:0] == argument);
        XCTAssertTrue([returnValue isEqual:NSStringFromSelector(@selector(returnValueOneArgument:))]);
    }
}

- (void)testObserverWithoutImplementer {
    ProtocolProxy *proxy;
    __block NSUInteger observerCallCount;
    __block id argument1, argument2;
    id returnValue;

    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
        observerCallCount = 0;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueNoArguments) beforeObservedSelector:YES usingBlock:^{
            observerCallCount++;
        }]);

        XCTAssertEqual(observerCallCount, 0);

        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
        XCTAssertEqual(observerCallCount, 1);

        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueNoArguments];
        XCTAssertEqual(observerCallCount, 2);
    }
    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
        observerCallCount = 0;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueOneArgument:) beforeObservedSelector:YES usingBlock:^(id self, id arg) {
            XCTAssertTrue(argument1 == arg);
            observerCallCount++;
        }]);

        XCTAssertEqual(observerCallCount, 0);

        argument1 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument1];
        XCTAssertEqual(observerCallCount, 1);

        argument1 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueOneArgument:argument1];
        XCTAssertEqual(observerCallCount, 2);
    }
    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
        observerCallCount = 0;

        XCTAssertTrue([proxy addObserverForSelector:@selector(noReturnValueTwoArguments::) beforeObservedSelector:YES usingBlock:^(id self, id arg1, id arg2) {
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
            observerCallCount++;
        }]);

        XCTAssertEqual(observerCallCount, 0);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        [(id<ArgsAndReturnValuesProtocol>)proxy noReturnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
    }

    //

    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
        observerCallCount = 0;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueNoArguments) beforeObservedSelector:YES usingBlock:^{
            observerCallCount++;
        }]);

        XCTAssertEqual(observerCallCount, 0);

        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertNil(returnValue);

        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueNoArguments];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertNil(returnValue);
    }
    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
        observerCallCount = 0;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueOneArgument:) beforeObservedSelector:YES usingBlock:^(id self, id arg) {
            XCTAssertTrue(argument1 == arg);
            observerCallCount++;
        }]);

        XCTAssertEqual(observerCallCount, 0);

        argument1 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument1];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertNil(returnValue);

        argument1 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueOneArgument:argument1];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertNil(returnValue);
    }
    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ArgsAndReturnValuesProtocol) implementer:nil];
        observerCallCount = 0;

        XCTAssertTrue([proxy addObserverForSelector:@selector(returnValueTwoArguments::) beforeObservedSelector:YES usingBlock:^(id self, id arg1, id arg2) {
            XCTAssertTrue(argument1 == arg1);
            XCTAssertTrue(argument2 == arg2);
            observerCallCount++;
        }]);

        XCTAssertEqual(observerCallCount, 0);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 1);
        XCTAssertNil(returnValue);

        argument1 = [[NSObject alloc] init];
        argument2 = [[NSObject alloc] init];
        returnValue = [(id<ArgsAndReturnValuesProtocol>)proxy returnValueTwoArguments:argument1 :argument2];
        XCTAssertEqual(observerCallCount, 2);
        XCTAssertNil(returnValue);
    }
}

- (void)testObserverWithoutImplementedMethod {
    BasicTestDelegate * const delegate = [[BasicTestDelegate alloc] init];
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:delegate];
    proxy.respondsToSelectorsWithObservers = YES;
    __block NSUInteger observerCallCount = 0;

    XCTAssertTrue([proxy addObserverForSelector:@selector(maybeFoobar) beforeObservedSelector:YES usingBlock:^{
        observerCallCount++;
    }]);

    XCTAssertEqual(observerCallCount, 0);
    XCTAssertEqual(delegate.maybeFoobarCount, 0);

    XCTAssertNoThrow([(id<BasicTestProtocol>)proxy maybeFoobar]);
    XCTAssertEqual(observerCallCount, 1);
    XCTAssertEqual(delegate.maybeFoobarCount, 0);

    XCTAssertNoThrow([(id<BasicTestProtocol>)proxy maybeFoobar]);
    XCTAssertEqual(observerCallCount, 2);
    XCTAssertEqual(delegate.maybeFoobarCount, 0);
}

@end
