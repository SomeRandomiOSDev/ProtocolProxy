//
//  ProtocolProxyBasicTests.m
//  ProtocolProxyTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

@import ObjectiveC;
@import ProtocolProxy;
@import ProtocolProxyTestsBase;
@import XCTest;

#pragma mark - ProtocolProxyBasicTests Interface

@interface ProtocolProxyBasicTests: XCTestCase
@end

#pragma mark - ProtocolProxyBasicTests Implementation

@implementation ProtocolProxyBasicTests

#pragma mark Test Methods

- (void)testProtocolAdoption {
    NSArray<Protocol *> * const allProtocols = @[
        @protocol(BasicTestProtocol),
        @protocol(NSCopying),
        @protocol(NSMutableCopying),
        @protocol(NSCoding),
        @protocol(NSSecureCoding),
        @protocol(NSFastEnumeration)
    ];

    [self iterateAllPermutationsOfObjects:allProtocols usingBlock:^(NSArray<Protocol *> *protocols) {
        ProtocolProxy *proxy;

        if (protocols.count == 1)
            proxy = [[ProtocolProxy alloc] initWithProtocol:protocols.firstObject implementer:nil];
        else
            proxy = [[ProtocolProxy alloc] initWithProtocols:protocols implementer:nil];

        for (Protocol *protocol in allProtocols) {
            XCTAssertEqual([proxy.adoptedProtocols containsObject:protocol], [proxy conformsToProtocol:protocol], @"Failure when comparing protocol conformances: [%@]", [[self namesForProtocols:protocols] componentsJoinedByString:@", "]);
        }
    }];
}

- (void)testRespondsToSelector {
    NSArray<Protocol *> * const allProtocols = @[
        @protocol(BasicTestProtocol),
        @protocol(NSCopying),
        @protocol(NSMutableCopying),
        @protocol(NSCoding),
        @protocol(NSFastEnumeration)
    ];

    NSDictionary<NSString *, NSArray<NSString *> *> *allSelectors = @{
        [NSString stringWithUTF8String:protocol_getName(@protocol(BasicTestProtocol))]: @[[NSString stringWithUTF8String:sel_getName(@selector(foobar))]],
        [NSString stringWithUTF8String:protocol_getName(@protocol(NSCopying))]: @[[NSString stringWithUTF8String:sel_getName(@selector(copyWithZone:))]],
        [NSString stringWithUTF8String:protocol_getName(@protocol(NSMutableCopying))]: @[[NSString stringWithUTF8String:sel_getName(@selector(mutableCopyWithZone:))]],
        [NSString stringWithUTF8String:protocol_getName(@protocol(NSCoding))]: @[[NSString stringWithUTF8String:sel_getName(@selector(encodeWithCoder:))], [NSString stringWithUTF8String:sel_getName(@selector(initWithCoder:))]],
        [NSString stringWithUTF8String:protocol_getName(@protocol(NSFastEnumeration))]: @[[NSString stringWithUTF8String:sel_getName(@selector(countByEnumeratingWithState:objects:count:))]]
    };

    [self iterateAllPermutationsOfObjects:allProtocols usingBlock:^(NSArray<Protocol *> *protocols) {
        ProtocolProxy *proxy;

        if (protocols.count == 1)
            proxy = [[ProtocolProxy alloc] initWithProtocol:protocols.firstObject implementer:nil];
        else
            proxy = [[ProtocolProxy alloc] initWithProtocols:protocols implementer:nil];

        for (Protocol *protocol in allProtocols) {
            NSString * const protocolName = [NSString stringWithUTF8String:protocol_getName(protocol)];
            NSArray<NSString *> * const selectors = allSelectors[protocolName];

            for (NSString *selector in selectors) {
                XCTAssertEqual([proxy.adoptedProtocols containsObject:protocol], [proxy respondsToSelector:sel_registerName(selector.UTF8String)], @"Failure when checking response to selector: `%@` | [%@]", selector, [[self namesForProtocols:protocols] componentsJoinedByString:@", "]);
            }
        }
    }];

    {
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate alloc] init]];

        XCTAssertTrue([proxy respondsToSelector:@selector(foobar)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(maybeFoobar)]); // -maybeFoobar is optional and the proxy's implementer doesn't implement it
        XCTAssertFalse([proxy respondsToSelector:@selector(copyWithZone:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(mutableCopyWithZone:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(encodeWithCoder:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(initWithCoder:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(countByEnumeratingWithState:objects:count:)]);
    }
    {
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate2 alloc] init]];

        XCTAssertTrue([proxy respondsToSelector:@selector(foobar)]);
        XCTAssertTrue([proxy respondsToSelector:@selector(maybeFoobar)]); // -maybeFoobar is optional and the proxy's implementer does implement it
        XCTAssertFalse([proxy respondsToSelector:@selector(copyWithZone:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(mutableCopyWithZone:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(encodeWithCoder:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(initWithCoder:)]);
        XCTAssertFalse([proxy respondsToSelector:@selector(countByEnumeratingWithState:objects:count:)]);
    }
    {
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate alloc] init]];
        XCTAssertFalse(proxy.respondsToSelectorsWithObservers); // Default value

        id<BasicTestProtocol> const observer = [[BasicTestDelegate2 alloc] init];
        XCTAssertFalse([proxy respondsToSelector:@selector(maybeFoobar)]);

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(maybeFoobar) beforeObservedSelector:YES]);
        XCTAssertFalse([proxy respondsToSelector:@selector(maybeFoobar)]);

        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(maybeFoobar) beforeObservedSelector:NO]);
        XCTAssertFalse([proxy respondsToSelector:@selector(maybeFoobar)]);
    }
    {
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate alloc] init]];
        proxy.respondsToSelectorsWithObservers = YES;

        id<BasicTestProtocol> const observer = [[BasicTestDelegate2 alloc] init];

        XCTAssertFalse([proxy respondsToSelector:@selector(maybeFoobar)]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(maybeFoobar) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy respondsToSelector:@selector(maybeFoobar)]);
    }
    {
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate alloc] init]];
        proxy.respondsToSelectorsWithObservers = YES;

        id<BasicTestProtocol> const observer = [[BasicTestDelegate2 alloc] init];

        XCTAssertFalse([proxy respondsToSelector:@selector(maybeFoobar)]);
        XCTAssertTrue([proxy addObserver:observer forSelector:@selector(maybeFoobar) beforeObservedSelector:NO]);
        XCTAssertTrue([proxy respondsToSelector:@selector(maybeFoobar)]);
    }
    {
        // Selectors declared on the public interface of ProtocolProxy
        const SEL declaredSelectors[] = {
            @selector(implementer),
            @selector(adoptedProtocols),
            @selector(respondsToSelectorsWithObservers),
            @selector(setRespondsToSelectorsWithObservers:),

            @selector(initWithProtocol:implementer:),
            @selector(initWithProtocol:stronglyRetainedImplementer:),
            @selector(initWithProtocols:implementer:),
            @selector(initWithProtocols:stronglyRetainedImplementer:),

            @selector(overrideSelector:withTarget:),
            @selector(overrideSelector:withTarget:targetSelector:),
            @selector(overrideSelector:usingBlock:),

            @selector(addObserver:forSelector:beforeObservedSelector:),
            @selector(addObserver:forSelector:beforeObservedSelector:observerSelector:),
            @selector(addObserverForSelector:beforeObservedSelector:usingBlock:)
        };

        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(NSObject) implementer:nil];

        const NSUInteger selectorCount = sizeof(declaredSelectors) / sizeof(*declaredSelectors);
        for (NSUInteger i = 0; i < selectorCount; ++i) {
            XCTAssertTrue([proxy respondsToSelector:declaredSelectors[i]], @"Expected ProtocolProxy to respond to `-%s`", sel_getName(declaredSelectors[i]));
        }
    }
}

- (void)testInvalidInitializerArguments {
    id const implementer = [[NSObject alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    XCTAssertThrowsSpecificNamed([[ProtocolProxy alloc] initWithProtocol:nil implementer:implementer], NSException, NSInvalidArgumentException);
    XCTAssertThrowsSpecificNamed([[ProtocolProxy alloc] initWithProtocol:nil stronglyRetainedImplementer:implementer], NSException, NSInvalidArgumentException);
    XCTAssertThrowsSpecificNamed([[ProtocolProxy alloc] initWithProtocols:nil implementer:implementer], NSException, NSInvalidArgumentException);
    XCTAssertThrowsSpecificNamed([[ProtocolProxy alloc] initWithProtocols:nil stronglyRetainedImplementer:implementer], NSException, NSInvalidArgumentException);
#pragma clang diagnostic pop

    XCTAssertThrowsSpecificNamed([[ProtocolProxy alloc] initWithProtocols:@[] implementer:implementer], NSException, NSInvalidArgumentException);
    XCTAssertThrowsSpecificNamed([[ProtocolProxy alloc] initWithProtocols:@[] stronglyRetainedImplementer:implementer], NSException, NSInvalidArgumentException);

    // Implementer is allowed to be `nil`
    XCTAssertNoThrow([[ProtocolProxy alloc] initWithProtocol:@protocol(NSObject) implementer:nil]);
    XCTAssertNoThrow([[ProtocolProxy alloc] initWithProtocol:@protocol(NSObject) stronglyRetainedImplementer:nil]);
    XCTAssertNoThrow([[ProtocolProxy alloc] initWithProtocols:@[@protocol(NSObject)] implementer:nil]);
    XCTAssertNoThrow([[ProtocolProxy alloc] initWithProtocols:@[@protocol(NSObject)] stronglyRetainedImplementer:nil]);

    ProtocolProxy *proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(NSObject) implementer:[[NSObject alloc] init]];
    [proxy overrideSelector:@selector(foobar) withTarget:[[NSObject alloc] init]];
}

- (void)testProxyDoesntForwardUnrecognizedSelectors {
    NSKeyedArchiver *archiver;
    if (@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)) {
        archiver = [[NSKeyedArchiver alloc] initRequiringSecureCoding:NO];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:[NSMutableData data]];
#pragma clang diagnostic pop
    }

    {
        // Only implements -foobar
        id<BasicTestProtocol> const proxy = (id<BasicTestProtocol>)[[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate alloc] init]];
        NSFastEnumerationState state;
        id __unsafe_unretained objects;

        XCTAssertNoThrow([proxy foobar]);
        XCTAssertThrowsSpecificNamed([proxy maybeFoobar], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSCopying>)proxy copyWithZone:NULL], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSMutableCopying>)proxy mutableCopyWithZone:NULL], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSCoding>)proxy encodeWithCoder:archiver], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSFastEnumeration>)proxy countByEnumeratingWithState:&state objects:&objects count:0], NSException, NSInvalidArgumentException);
    }
    {
        // Implements -foobar & -maybeFoobar
        id<BasicTestProtocol> const proxy = (id<BasicTestProtocol>)[[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[BasicTestDelegate2 alloc] init]];
        NSFastEnumerationState state;
        id __unsafe_unretained objects;

        XCTAssertNoThrow([proxy foobar]);
        XCTAssertNoThrow([proxy maybeFoobar]);
        XCTAssertThrowsSpecificNamed([(id<NSCopying>)proxy copyWithZone:NULL], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSMutableCopying>)proxy mutableCopyWithZone:NULL], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSCoding>)proxy encodeWithCoder:archiver], NSException, NSInvalidArgumentException);
        XCTAssertThrowsSpecificNamed([(id<NSFastEnumeration>)proxy countByEnumeratingWithState:&state objects:&objects count:0], NSException, NSInvalidArgumentException);
    }

    [archiver finishEncoding];
}

- (void)testBasicForwarding {
    BasicTestClass * const test = [[BasicTestClass alloc] init];

    {
        BasicTestDelegate * const delegate = [[BasicTestDelegate alloc] init];
        test.delegate = delegate;

        XCTAssertEqual(delegate.foobarCount, 0);
        XCTAssertEqual(delegate.maybeFoobarCount, 0);

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 1);
        XCTAssertEqual(delegate.maybeFoobarCount, 0);

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 2);
        XCTAssertEqual(delegate.maybeFoobarCount, 0);

        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:delegate];
        test.delegate = (id<BasicTestProtocol>)proxy;

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 3);
        XCTAssertEqual(delegate.maybeFoobarCount, 0);

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 4);
        XCTAssertEqual(delegate.maybeFoobarCount, 0);
    }
    {
        BasicTestDelegate * const delegate = [[BasicTestDelegate2 alloc] init];
        test.delegate = delegate;

        XCTAssertEqual(delegate.foobarCount, 0);
        XCTAssertEqual(delegate.maybeFoobarCount, 0);

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 1);
        XCTAssertEqual(delegate.maybeFoobarCount, 1);

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 2);
        XCTAssertEqual(delegate.maybeFoobarCount, 2);

        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:delegate];
        test.delegate = (id<BasicTestProtocol>)proxy;

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 3);
        XCTAssertEqual(delegate.maybeFoobarCount, 3);

        [test foobar];
        [test maybeFoobar];
        XCTAssertEqual(delegate.foobarCount, 4);
        XCTAssertEqual(delegate.maybeFoobarCount, 4);
    }
}

- (void)testImplementerIsntLeaked {
    ProtocolProxy *proxy = nil;
    __weak id weakImplementer = nil;

    @autoreleasepool {
        __strong id implementer = [[NSObject alloc] init];
        weakImplementer = implementer;
        XCTAssertNotNil(weakImplementer);

        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:implementer];
        XCTAssertNotNil(weakImplementer);

        implementer = nil;
        XCTAssertNotNil(weakImplementer); // proxy should still be retaining the implementer

        proxy = nil;
    }

    XCTAssertNil(weakImplementer); // proxy should have released the implementer

    //

    @autoreleasepool {
        __strong id implementer = [[NSObject alloc] init];
        weakImplementer = implementer;
        XCTAssertNotNil(weakImplementer);

        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:implementer];
        implementer = nil;
    }

    XCTAssertNotNil(proxy);
    XCTAssertNil(weakImplementer); // proxy shouldn't have retained implementer to begin with
}

- (void)testProtocolProxyProperties {
    ProtocolProxy *proxy;
    id implementer = [[NSObject alloc] init];

    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:nil];

        XCTAssertNil(proxy.implementer);

        NSArray<Protocol *> * const adoptedProtocols = proxy.adoptedProtocols;
        XCTAssertEqual(adoptedProtocols.count, 2);
        XCTAssertTrue([adoptedProtocols containsObject:@protocol(BasicTestProtocol)]);
        XCTAssertTrue([adoptedProtocols containsObject:@protocol(NSObject)]);
    }
    {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:implementer];

        XCTAssertTrue(proxy.implementer == implementer);

        NSArray<Protocol *> * const adoptedProtocols = proxy.adoptedProtocols;
        XCTAssertEqual(adoptedProtocols.count, 2);
        XCTAssertTrue([adoptedProtocols containsObject:@protocol(BasicTestProtocol)]);
        XCTAssertTrue([adoptedProtocols containsObject:@protocol(NSObject)]);
    }

    //

    __weak id weakImplementer;

    @autoreleasepool {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:implementer];
        weakImplementer = proxy.implementer;

        XCTAssertNotNil(weakImplementer);

        implementer = nil;
        proxy = nil;
    }

    XCTAssertNil(weakImplementer);

    //

    @autoreleasepool {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) stronglyRetainedImplementer:[[NSObject alloc] init]];
        weakImplementer = proxy.implementer;

        XCTAssertNotNil(weakImplementer);

        implementer = nil;
        proxy = nil;
    }

    XCTAssertNil(weakImplementer);

    //

    NSArray<Protocol *> *strongReference;
    __weak NSArray<Protocol *> *weakReference;

    @autoreleasepool {
        proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(BasicTestProtocol) implementer:nil];

        strongReference = proxy.adoptedProtocols;
        weakReference = strongReference;

        proxy = nil;
    }

    XCTAssertNotNil(weakReference);

    @autoreleasepool { strongReference = nil; }
    XCTAssertNil(weakReference);
}

- (void)testProtocolProxyPropertiesAreOverridden {
    id const implementerImplementer = [[NSObject alloc] init];
    ProtocolProxyPropertiesProtocolImplementer * const implementer = [[ProtocolProxyPropertiesProtocolImplementer alloc] init];
    implementer.implementer = implementerImplementer;
    implementer.adoptedProtocols = @[@protocol(NSMutableCopying)];
    implementer.respondsToSelectorsWithObservers = YES;

    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];

    XCTAssertFalse(proxy.implementer == implementer); // Expected value if not overridden
    XCTAssertTrue(proxy.implementer == implementerImplementer);

    NSMutableArray * const expectedAdoptedProtocols = [NSMutableArray array];
    [expectedAdoptedProtocols addObject:@protocol(ProtocolProxyPropertiesProtocol)];
    [expectedAdoptedProtocols addObject:@protocol(NSObject)];
    XCTAssertFalse([proxy.adoptedProtocols isEqualToArray:expectedAdoptedProtocols]); // Expected value if not overridden
    XCTAssertTrue([proxy.adoptedProtocols isEqualToArray:@[@protocol(NSMutableCopying)]]);
    XCTAssertTrue([proxy conformsToProtocol:@protocol(NSObject)]);
    XCTAssertTrue([proxy conformsToProtocol:@protocol(ProtocolProxyPropertiesProtocol)]);
    XCTAssertFalse([proxy conformsToProtocol:@protocol(NSMutableCopying)]);

    XCTAssertTrue(proxy.respondsToSelectorsWithObservers);

    //

    id const newImplementer = [[NSObject alloc] init];
    implementer.implementer = newImplementer;
    XCTAssertTrue(proxy.implementer == newImplementer);

    implementer.adoptedProtocols = @[@protocol(NSSecureCoding)];
    XCTAssertTrue([proxy.adoptedProtocols isEqualToArray:@[@protocol(NSSecureCoding)]]);
    XCTAssertTrue([proxy conformsToProtocol:@protocol(NSObject)]);
    XCTAssertTrue([proxy conformsToProtocol:@protocol(ProtocolProxyPropertiesProtocol)]);
    XCTAssertFalse([proxy conformsToProtocol:@protocol(NSSecureCoding)]);

    implementer.respondsToSelectorsWithObservers = NO;
    XCTAssertFalse(proxy.respondsToSelectorsWithObservers);

    //

    { // `proxy` still forwards to the implementer object passed in to its initializer, not to the object returned from `proxy.implementer`
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];
        XCTAssertFalse(proxy.implementer == implementer);
        XCTAssertEqual(implementer.foobarCount, 0);

        [(id<ProtocolProxyPropertiesProtocol>)proxy foobar];
        XCTAssertEqual(implementer.foobarCount, 1);

        [(id<ProtocolProxyPropertiesProtocol>)proxy foobar];
        XCTAssertEqual(implementer.foobarCount, 2);
    }
    { // Setting `proxy.respondsToSelectorsWithObservers` when overridden by an adopted protocol has no affect
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];
        proxy.respondsToSelectorsWithObservers = NO;

        XCTAssertFalse(implementer.respondsToSelectorsWithObservers);
        XCTAssertFalse([proxy respondsToSelector:@selector(dontActuallyImplementThis)]);
        XCTAssertTrue([proxy addObserver:self forSelector:@selector(dontActuallyImplementThis) beforeObservedSelector:YES]);
        XCTAssertFalse([proxy respondsToSelector:@selector(dontActuallyImplementThis)]);
    }
    { // Setting `proxy.respondsToSelectorsWithObservers` when overridden by an adopted protocol has no affect
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];
        proxy.respondsToSelectorsWithObservers = YES;

        XCTAssertTrue(implementer.respondsToSelectorsWithObservers);
        XCTAssertFalse([proxy respondsToSelector:@selector(dontActuallyImplementThis)]);
        XCTAssertTrue([proxy addObserver:self forSelector:@selector(dontActuallyImplementThis) beforeObservedSelector:YES]);
        XCTAssertFalse([proxy respondsToSelector:@selector(dontActuallyImplementThis)]); // `respondsToSelectorsWithObservers` is overridden so the internal instance variable that controls this behavior wasn't actually set.
    }

    //

    { // `implementer` is still accessible via ivar lookup
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];
        XCTAssertFalse(proxy.implementer == implementer);

        Ivar const ivar = class_getInstanceVariable(proxy.class, "_protocolProxyImplementer");

        XCTAssertTrue(ivar != NULL);
        XCTAssertTrue(object_getIvar(proxy, ivar) == implementer);
    }
    { // `adoptedProtocols` is still accessible via ivar lookup
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];
        XCTAssertFalse([proxy.adoptedProtocols isEqualToArray:expectedAdoptedProtocols]);

        Ivar const ivar = class_getInstanceVariable(proxy.class, "_protocolProxyAdoptedProtocols");

        XCTAssertTrue(ivar != NULL);
        XCTAssertTrue([expectedAdoptedProtocols isEqualToArray:(NSArray *)object_getIvar(proxy, ivar)]);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wvoid-pointer-to-int-cast"
    { // `respondsToSelectorsWithObservers` is still accessible via ivar lookup
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];

        Ivar const ivar = class_getInstanceVariable(proxy.class, "_protocolProxyRespondsToSelectorsWithObservers");
        XCTAssertTrue(ivar != NULL);

        implementer.respondsToSelectorsWithObservers = YES;
        XCTAssertFalse((BOOL)(__bridge void *)object_getIvar(proxy, ivar));

        object_setIvar(proxy, ivar, (__bridge id)(void *)YES);
        implementer.respondsToSelectorsWithObservers = NO;
        XCTAssertTrue((BOOL)(__bridge void *)object_getIvar(proxy, ivar));

        //

        XCTAssertFalse(implementer.respondsToSelectorsWithObservers);
        XCTAssertFalse([proxy respondsToSelector:@selector(dontActuallyImplementThis)]); // Implementer doesn't respond and we don't have any observers

        XCTAssertTrue([proxy addObserver:self forSelector:@selector(dontActuallyImplementThis) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy respondsToSelector:@selector(dontActuallyImplementThis)]); // `respondsToSelectorsWithObservers` was set to YES via ivar lookup and we have an observer
    }
#pragma clang diagnostic pop
    { // `respondsToSelectorsWithObservers` is still accessible via ivar offset
        ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(ProtocolProxyPropertiesProtocol) implementer:implementer];

        Ivar const ivar = class_getInstanceVariable(proxy.class, "_protocolProxyRespondsToSelectorsWithObservers");
        const ptrdiff_t offset = ivar_getOffset(ivar);
        XCTAssertTrue(ivar != NULL);

        implementer.respondsToSelectorsWithObservers = YES;
        XCTAssertFalse(*(BOOL *)((uint8_t *)(__bridge void *)proxy + offset));

        *(BOOL *)((uint8_t *)(__bridge void *)proxy + offset) = YES;
        implementer.respondsToSelectorsWithObservers = NO;
        XCTAssertTrue(*(BOOL *)((uint8_t *)(__bridge void *)proxy + offset));

        //

        XCTAssertFalse(implementer.respondsToSelectorsWithObservers);
        XCTAssertFalse([proxy respondsToSelector:@selector(dontActuallyImplementThis)]); // Implementer doesn't respond and we don't have any observers

        XCTAssertTrue([proxy addObserver:self forSelector:@selector(dontActuallyImplementThis) beforeObservedSelector:YES]);
        XCTAssertTrue([proxy respondsToSelector:@selector(dontActuallyImplementThis)]); // `respondsToSelectorsWithObservers` was set to YES via ivar lookup and we have an observer
    }
}

- (void)testAllPropertyAttributesCombinations {
    ProtocolProxy * const proxy = [[ProtocolProxy alloc] initWithProtocol:@protocol(AllPropertyAttributeCombinationsProtocol) implementer:nil];

    { // `assign` properties
        NSIndexSet * const readonlyIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 4)];
        NSIndexSet * const customGetterIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 6)];
        NSIndexSet * const customSetterIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(8, 4)];

        for (NSUInteger i = 0; i < 12; ++i) {
            NSString * const getter = [NSString stringWithFormat:@"assignProperty%lu", (unsigned long)i];
            NSString * const customGetter = [NSString stringWithFormat:@"customAssignProperty%luGetter", (unsigned long)i];

            NSString * const setter = [NSString stringWithFormat:@"setAssignProperty%lu:", (unsigned long)i];
            NSString * const customSetter = [NSString stringWithFormat:@"customAssignProperty%luSetter:", (unsigned long)i];

            if ([customGetterIndexes containsIndex:i]) {
                XCTAssertFalse([proxy respondsToSelector:sel_registerName(getter.UTF8String)], @"Expected ProtocolProxy not to respond to property getter: -[AllPropertyAttributeCombinationsProtocol %@]", getter);
                XCTAssertTrue([proxy respondsToSelector:sel_registerName(customGetter.UTF8String)], @"Expected ProtocolProxy to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol %@]", customGetter);
            } else {
                XCTAssertTrue([proxy respondsToSelector:sel_registerName(getter.UTF8String)], @"Expected ProtocolProxy to respond to property getter: -[AllPropertyAttributeCombinationsProtocol %@]", getter);
                XCTAssertFalse([proxy respondsToSelector:sel_registerName(customGetter.UTF8String)], @"Expected ProtocolProxy not to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol %@]", customGetter);
            }

            if (![readonlyIndexes containsIndex:i]) {
                if ([customSetterIndexes containsIndex:i]) {
                    XCTAssertFalse([proxy respondsToSelector:sel_registerName(setter.UTF8String)], @"Expected ProtocolProxy not to respond to property setter: -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                    XCTAssertTrue([proxy respondsToSelector:sel_registerName(customSetter.UTF8String)], @"Expected ProtocolProxy to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol %@]", customSetter);
                } else {
                    XCTAssertTrue([proxy respondsToSelector:sel_registerName(setter.UTF8String)], @"Expected ProtocolProxy to respond to property setter: -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                    XCTAssertFalse([proxy respondsToSelector:sel_registerName(customSetter.UTF8String)], @"Expected ProtocolProxy not to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol %@]", customSetter);
                }
            } else {
                XCTAssertFalse([proxy respondsToSelector:sel_registerName(setter.UTF8String)], @"Expected ProtocolProxy not to respond to property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                XCTAssertFalse([proxy respondsToSelector:sel_registerName(customSetter.UTF8String)], @"Expected ProtocolProxy not to respond to custom property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol %@]", setter);
            }
        }
    }
    { // `strong`, `copy`, `weak`, and `unsafe_unretained` properties
        for (NSString *referenceAttribute in @[@"strong", @"copy", @"weak", @"unsafeUnretained"]) {
            NSMutableIndexSet * const readonlyIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(2, 4)];
            [readonlyIndexes addIndexesInRange:NSMakeRange(14, 4)];
            NSMutableIndexSet * const customGetterIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(4, 6)];
            [customGetterIndexes addIndexesInRange:NSMakeRange(16, 6)];
            NSMutableIndexSet * const customSetterIndexes = [NSMutableIndexSet indexSetWithIndexesInRange:NSMakeRange(8, 4)];
            [customSetterIndexes addIndexesInRange:NSMakeRange(20, 4)];

            for (NSUInteger i = 0; i < 24; ++i) {
                NSString * const getter = [NSString stringWithFormat:@"%@Property%lu", referenceAttribute, (unsigned long)i];
                NSString * const customGetter = [NSString stringWithFormat:@"custom%@Property%luGetter", [self capitalizeFirstLetterOfString:referenceAttribute], (unsigned long)i];

                NSString * const setter = [NSString stringWithFormat:@"set%@Property%lu:", [self capitalizeFirstLetterOfString:referenceAttribute], (unsigned long)i];
                NSString * const customSetter = [NSString stringWithFormat:@"custom%@Property%luSetter:", [self capitalizeFirstLetterOfString:referenceAttribute], (unsigned long)i];
                
                if ([customGetterIndexes containsIndex:i]) {
                    XCTAssertFalse([proxy respondsToSelector:sel_registerName(getter.UTF8String)], @"Expected ProtocolProxy not to respond to property getter: -[AllPropertyAttributeCombinationsProtocol %@]", getter);
                    XCTAssertTrue([proxy respondsToSelector:sel_registerName(customGetter.UTF8String)], @"Expected ProtocolProxy to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol %@]", customGetter);
                } else {

                    XCTAssertTrue([proxy respondsToSelector:sel_registerName(getter.UTF8String)], @"Expected ProtocolProxy to respond to property getter: -[AllPropertyAttributeCombinationsProtocol %@]", getter);
                    XCTAssertFalse([proxy respondsToSelector:sel_registerName(customGetter.UTF8String)], @"Expected ProtocolProxy not to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol %@]", customGetter);
                }

                if (![readonlyIndexes containsIndex:i]) {
                    if ([customSetterIndexes containsIndex:i]) {
                        XCTAssertFalse([proxy respondsToSelector:sel_registerName(setter.UTF8String)], @"Expected ProtocolProxy not to respond to property setter: -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                        XCTAssertTrue([proxy respondsToSelector:sel_registerName(customSetter.UTF8String)], @"Expected ProtocolProxy to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                    } else {
                        XCTAssertTrue([proxy respondsToSelector:sel_registerName(setter.UTF8String)], @"Expected ProtocolProxy to respond to property setter: -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                        XCTAssertFalse([proxy respondsToSelector:sel_registerName(customSetter.UTF8String)], @"Expected ProtocolProxy not to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                    }
                } else {
                    XCTAssertFalse([proxy respondsToSelector:sel_registerName(setter.UTF8String)], @"Expected ProtocolProxy not to respond to property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                    XCTAssertFalse([proxy respondsToSelector:sel_registerName(customSetter.UTF8String)], @"Expected ProtocolProxy not to respond to custom property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol %@]", setter);
                }
            }
        }
    }
}

#pragma mark Private Methods

- (void)iterateAllPermutationsOfObjects:(NSArray *)objects usingBlock:(void (^NS_NOESCAPE)(NSArray *))block {
    NSOrderedSet<NSArray *> * (^__unsafe_unretained __block iterate)(NSArray *) = nil;
    NSOrderedSet<NSArray *> * (^_iterate)(NSArray *) = ^NSOrderedSet * (NSArray *objects) {
        NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSet];
        [set addObject:objects];

        if (objects.count > 1) {
            for (NSUInteger i = 0; i < objects.count; ++i) {
                NSMutableArray * const subobjects = [NSMutableArray arrayWithArray:objects];
                [subobjects removeObjectAtIndex:i];

                [set unionOrderedSet:iterate(subobjects)];
            }
        }

        return set;
    };

    iterate = _iterate;
    for (NSArray *permutation in iterate(objects).array) {
        block(permutation);
    }
}

- (NSArray<NSString *> *)namesForProtocols:(NSArray<Protocol *> *)protocols {
    NSMutableArray<NSString *> * const names = [NSMutableArray arrayWithCapacity:protocols.count];

    for (Protocol *protocol in protocols) {
        [names addObject:[NSString stringWithUTF8String:protocol_getName(protocol)]];
    }

    return [names copy];
}

- (NSString *)capitalizeFirstLetterOfString:(NSString *)string {
    if (string.length == 0)
        return string;

    return [[[string substringToIndex:1] uppercaseString] stringByAppendingString:[string substringFromIndex:1]];
}

@end
