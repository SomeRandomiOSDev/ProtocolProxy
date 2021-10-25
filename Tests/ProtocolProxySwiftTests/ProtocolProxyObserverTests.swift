//
//  ProtocolProxyObserverTests.swift
//  ProtocolProxyTests
//
//  Copyright © 2021 SomeRandomiOSDev. All rights reserved.
//

import ProtocolProxy
import ProtocolProxyTestsBase
import XCTest

#if SWIFT_PACKAGE
import ProtocolProxySwift
#endif // #if SWIFT_PACKAGE

// MARK: - ProtocolProxyObserverTests Definition

class ProtocolProxySwiftObserverTests: XCTestCase {

    // MARK: Test Methods

    func testObserveBeforeWithBlocksNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let block: @convention(block) () -> Void = {
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            observerCallCount += 1
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: block))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
    }

    func testObserveAfterWithBlocksNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let block: @convention(block) () -> Void = {
            observerCallCount += 1
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: block))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
    }

    func testObserveBeforeAndAfterWithBlocksNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let before: @convention(block) () -> Void = {
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            observerCallCount += 1
        }
        let after: @convention(block) () -> Void = {
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: before))
        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: after))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
    }

    //

    func testObserveBeforeWithTargetNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)
        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)

        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(observer.callCount(for: selector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(observer.callCount(for: selector), 2)
    }

    func testObserveAfterWithTargetNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)
        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)

        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(observer.callCount(for: selector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(observer.callCount(for: selector), 2)
    }

    func testObserveBeforeAndAfterWithTargetNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)
        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)

        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))
        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(observer.callCount(for: selector), 2)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(observer.callCount(for: selector), 4)
    }

    //

    func testObserveBeforeWithTargetAndAlternateSelectorNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)
        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueNoArguments)

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)
    }

    func testObserveAfterWithTargetAndAlternateSelectorNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)
        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueNoArguments)

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)
    }

    func testObserveBeforeAndAfterWithTargetAndAlternateSelectorNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)
        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueNoArguments)

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))
        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 4)
    }

    // MARK: -

    func testObserveBeforeWithBlocksReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        var returnValue: Any?

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let block: @convention(block) () -> Void = {
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            observerCallCount += 1
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: block))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    func testObserveAfterWithBlocksReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        var returnValue: Any?

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let block: @convention(block) () -> Void = {
            observerCallCount += 1
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: block))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    func testObserveBeforeAndAfterWithBlocksReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        var returnValue: Any?

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let before: @convention(block) () -> Void = {
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            observerCallCount += 1
        }
        let after: @convention(block) () -> Void = {
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: before))
        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: after))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    //

    func testObserveBeforeWithTargetReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(observer.callCount(for: selector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(observer.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    func testObserveAfterWithTargetReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(observer.callCount(for: selector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(observer.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    func testObserveBeforeAndAfterWithTargetReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))
        XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertEqual(observer.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertEqual(observer.callCount(for: selector), 4)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    //

    func testObserveBeforeWithTargetAndAlternateSelectorReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let observerSelector = #selector(ArgsAndReturnValues._returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveAfterWithTargetAndAlternateSelectorReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let observerSelector = #selector(ArgsAndReturnValues._returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveBeforeAndAfterWithTargetAndAlternateSelectorReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let observerSelector = #selector(ArgsAndReturnValues._returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))
        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 4)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    // MARK: -

    func testObserveBeforeWithBlocksNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument === arg)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: block))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: block))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
        }
    }

    func testObserveAfterWithBlocksNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                observerCallCount += 1
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument === arg)
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: block))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                observerCallCount += 1
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: block))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
        }
    }

    func testObserveBeforeAndAfterWithBlocksNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            let before: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument === arg)
                observerCallCount += 1
            }
            let after: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument === arg)
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: before))
            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: after))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            let before: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
                observerCallCount += 1
            }
            let after: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: before))
            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: after))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
        }
    }

    //

    func testObserveBeforeWithTargetNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            var argument: AnyObject = NSObject()

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
        }
    }

    func testObserveAfterWithTargetNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            var argument: AnyObject = NSObject()

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
        }
    }

    func testObserveBeforeAndAfterWithTargetNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            var argument: AnyObject = NSObject()

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))
            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 4)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))
            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 4)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
        }
    }

    //

    func testObserveBeforeWithTargetAndAlternateSelectorNoReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueOneArgument(_:))
        var argument: AnyObject = NSObject()

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)
    }

    func testObserveBeforeWithTargetAndAlternateSelectorNoReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)
    }

    func testObserveAfterWithTargetAndAlternateSelectorNoReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueOneArgument(_:))
        var argument: AnyObject = NSObject()

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)
    }

    func testObserveAfterWithTargetAndAlternateSelectorNoReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)
    }

    func testObserveBeforeAndAfterWithTargetAndAlternateSelectorNoReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueOneArgument(_:))
        var argument: AnyObject = NSObject()

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))
        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 4)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)
    }

    func testObserveBeforeAndAfterWithTargetAndAlternateSelectorNoReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
        let observerSelector = #selector(ArgsAndReturnValues._noReturnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))
        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 4)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)
    }

    // MARK: -

    func testObserveBeforeWithBlocksReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument === arg)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: block))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: block))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
    }

    func testObserveAfterWithBlocksReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                observerCallCount += 1
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument === arg)
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: block))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                observerCallCount += 1
                XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
            }

            XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: block))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
    }

    func testObserveBeforeAndAfterWithBlocksReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        var argument: AnyObject = NSObject()
        var returnValue: Any?

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
        let before: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            XCTAssertTrue(argument === arg)
            observerCallCount += 1
        }
        let after: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            XCTAssertTrue(argument === arg)
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: before))
        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: after))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    func testObserveBeforeAndAfterWithBlocksReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
        var returnValue: Any?

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
        let before: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            XCTAssertTrue(argument1 === arg1)
            XCTAssertTrue(argument2 === arg2)
            observerCallCount += 1
        }
        let after: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
            XCTAssertEqual(observerCallCount, implementer.callCount(for: selector))
            XCTAssertTrue(argument1 === arg1)
            XCTAssertTrue(argument2 === arg2)
        }

        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: true, using: before))
        XCTAssertTrue(proxy.addObserver(for: selector, beforeObservedSelector: false, using: after))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 1)
        XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
        XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 2)
        XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
        XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    //

    func testObserveBeforeWithTargetReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
    }

    func testObserveAfterWithTargetReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 1)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
    }

    func testObserveBeforeAndAfterWithTargetReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))
            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 4)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let observer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: true))
            XCTAssertTrue(proxy.addObserver(observer, for: selector, beforeObservedSelector: false))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 1)
            XCTAssertEqual(observer.callCount(for: selector), 2)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 2)
            XCTAssertEqual(observer.callCount(for: selector), 4)
            XCTAssertTrue((implementer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((observer.argument(for: selector, at: 0) as? NSObject) === argument1)
            XCTAssertTrue((implementer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertTrue((observer.argument(for: selector, at: 1) as? NSObject) === argument2)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
    }

    //

    func testObserveBeforeWithTargetAndAlternateSelectorReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
        let observerSelector = #selector(ArgsAndReturnValues._returnValueOneArgument(_:))
        var argument: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveBeforeWithTargetAndAlternateSelectorReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
        let observerSelector = #selector(ArgsAndReturnValues._returnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveAfterWithTargetAndAlternateSelectorReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
        let observerSelector = #selector(ArgsAndReturnValues._returnValueOneArgument(_:))
        var argument: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveAfterWithTargetAndAlternateSelectorReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
        let observerSelector = #selector(ArgsAndReturnValues._returnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveBeforeAndAfterWithTargetAndAlternateSelectorReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
        let observerSelector = #selector(ArgsAndReturnValues._returnValueOneArgument(_:))
        var argument: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))
        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 4)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    func testObserveBeforeAndAfterWithTargetAndAlternateSelectorReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let observer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
        let observerSelector = #selector(ArgsAndReturnValues._returnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: true, observerSelector: observerSelector))
        XCTAssertTrue(proxy.addObserver(observer, for: originalSelector, beforeObservedSelector: false, observerSelector: observerSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 1)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 2)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 2)
        XCTAssertEqual(implementer.callCount(for: observerSelector), 0)
        XCTAssertEqual(observer.callCount(for: originalSelector), 0)
        XCTAssertEqual(observer.callCount(for: observerSelector), 4)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 0) as? NSObject) === argument1)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 0))
        XCTAssertNil(observer.argument(for: originalSelector, at: 0))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 0) as? NSObject) === argument1)

        XCTAssertTrue((implementer.argument(for: originalSelector, at: 1) as? NSObject) === argument2)
        XCTAssertNil(implementer.argument(for: observerSelector, at: 1))
        XCTAssertNil(observer.argument(for: originalSelector, at: 1))
        XCTAssertTrue((observer.argument(for: observerSelector, at: 1) as? NSObject) === argument2)

        XCTAssertEqual(returnValue as? String, NSStringFromSelector(originalSelector))
    }

    // MARK: -

    func testAddObserverFailureCases() {
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)
        let observer = ArgsAndReturnValues()
        let block: @convention(block) () -> Void = { }

        // Selector that isn't part of the adopted protocol(s)
        XCTAssertFalse(proxy.addObserver(observer, for: #selector(NSCopying.copy(with:)), beforeObservedSelector: true))
        XCTAssertFalse(proxy.addObserver(observer, for: #selector(NSCopying.copy(with:)), beforeObservedSelector: false))
        XCTAssertFalse(proxy.addObserver(observer, for: #selector(NSCopying.copy(with:)), beforeObservedSelector: true, observerSelector: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)))
        XCTAssertFalse(proxy.addObserver(observer, for: #selector(NSCopying.copy(with:)), beforeObservedSelector: false, observerSelector: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)))
        XCTAssertFalse(proxy.addObserver(for: #selector(NSCopying.copy(with:)), beforeObservedSelector: true, using: block))
        XCTAssertFalse(proxy.addObserver(for: #selector(NSCopying.copy(with:)), beforeObservedSelector: false, using: block))

        // Invalid block type
        let cFunction: @convention(c) () -> Void = { }
        let explicitClosure: @convention(swift) () -> Void = { }
        let implicitClosure: () -> Void = { }

        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true, using: NSObject()))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false, using: NSObject()))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true, using: cFunction))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false, using: cFunction))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true, using: explicitClosure))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false, using: explicitClosure))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true, using: implicitClosure))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false, using: implicitClosure))
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true) { } /* inline closure */)
        XCTAssertFalse(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false) { } /* inline closure */)
    }

    func testObserverIsntRetained() {
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)
        weak var weakObserver: ArgsAndReturnValues?

        autoreleasepool {
            let observer = ArgsAndReturnValues()
            weakObserver = observer

            XCTAssertTrue(proxy.addObserver(observer, for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true))
        }

        XCTAssertNil(weakObserver)

        //

        autoreleasepool {
            let observer = ArgsAndReturnValues()
            weakObserver = observer

            XCTAssertTrue(proxy.addObserver(observer, for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false))
        }

        XCTAssertNil(weakObserver)

        //

        autoreleasepool {
            let observer = ArgsAndReturnValues()
            weakObserver = observer

            XCTAssertTrue(proxy.addObserver(observer, for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true))
            XCTAssertTrue(proxy.addObserver(observer, for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: false))
        }

        XCTAssertNil(weakObserver)
    }

    func testObserverIsUnregisteredAfterBeingFreed() {
        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))

        weak var weakObserver: ArgsAndReturnValues?
        var implementer: ArgsAndReturnValues?
        var proxy: ProtocolProxy?

        do {
            autoreleasepool {
                implementer = ArgsAndReturnValues()
                proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

                let observer = ArgsAndReturnValues()
                weakObserver = observer

                XCTAssertEqual(proxy?.addObserver(observer, for: selector, beforeObservedSelector: true), true)

                let argument = NSObject()
                let returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)

                XCTAssertEqual(implementer?.callCount(for: selector), 1)
                XCTAssertEqual(observer.callCount(for: selector), 1)
                XCTAssertTrue((implementer?.argument(for: selector, at: 0) as AnyObject?) === argument)
                XCTAssertTrue((observer.argument(for: selector, at: 0) as AnyObject?) === argument)
                XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
            }

            XCTAssertNil(weakObserver)

            let argument = NSObject()
            let returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)

            XCTAssertEqual(implementer?.callCount(for: selector), 2)
            XCTAssertTrue((implementer?.argument(for: selector, at: 0) as AnyObject?) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
        do {
            autoreleasepool {
                implementer = ArgsAndReturnValues()
                proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

                let observer = ArgsAndReturnValues()
                weakObserver = observer

                XCTAssertEqual(proxy?.addObserver(observer, for: selector, beforeObservedSelector: true), true)

                let argument = NSObject()
                let returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)

                XCTAssertEqual(implementer?.callCount(for: selector), 1)
                XCTAssertEqual(observer.callCount(for: selector), 1)
                XCTAssertTrue((implementer?.argument(for: selector, at: 0) as AnyObject?) === argument)
                XCTAssertTrue((observer.argument(for: selector, at: 0) as AnyObject?) === argument)
                XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
            }

            XCTAssertNil(weakObserver)

            let argument = NSObject()
            let returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)

            XCTAssertEqual(implementer?.callCount(for: selector), 2)
            XCTAssertTrue((implementer?.argument(for: selector, at: 0) as AnyObject?) === argument)
            XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
        }
    }

    func testObserverWithoutImplementer() {
        do {
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)

            var observerCallCount = 0
            let block: @convention(block) () -> Void = {
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments), beforeObservedSelector: true, using: block))
            XCTAssertEqual(observerCallCount, 0)

            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
            XCTAssertEqual(observerCallCount, 1)

            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
            XCTAssertEqual(observerCallCount, 2)
        }
        do {
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()
            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertTrue(argument === arg)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:)), beforeObservedSelector: true, using: block))
            XCTAssertEqual(observerCallCount, 0)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
        }
        do {
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:)), beforeObservedSelector: true, using: block))
            XCTAssertEqual(observerCallCount, 0)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
        }
    }

    func testAdditionalObserverWithoutImplementer() {
        do {
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)

            var observerCallCount = 0
            var returnValue: Any?
            let block: @convention(block) () -> Void = {
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), beforeObservedSelector: true, using: block))
            XCTAssertEqual(observerCallCount, 0)

            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertNil(returnValue)

            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertNil(returnValue)
        }
        do {
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertTrue(argument === arg)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:)), beforeObservedSelector: true, using: block))
            XCTAssertEqual(observerCallCount, 0)

            argument = NSObject()
            XCTAssertNil((proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument))
            XCTAssertEqual(observerCallCount, 1)
//            XCTAssertNil(returnValue)

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertNil(returnValue)
        }
        do {
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.addObserver(for: #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:)), beforeObservedSelector: true, using: block))
            XCTAssertEqual(observerCallCount, 0)

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertNil(returnValue)

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertNil(returnValue)
        }
    }

    func testObserverWithoutImplementedMethod() {
        let delegate = BasicTestDelegate()
        let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: delegate)
        proxy.respondsToSelectorsWithObservers = true

        var observerCallCount = 0
        let block: @convention(block) () -> Void = {
            observerCallCount += 1
        }

        XCTAssertTrue(proxy.addObserver(for: #selector(BasicTestProtocol.maybeFoobar), beforeObservedSelector: true, using: block))

        XCTAssertEqual(observerCallCount, 0)
        XCTAssertEqual(delegate.maybeFoobarCount, 0)

        (proxy as? BasicTestProtocol)?.maybeFoobar?()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(delegate.maybeFoobarCount, 0)

        (proxy as? BasicTestProtocol)?.maybeFoobar?()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(delegate.maybeFoobarCount, 0)
    }
}
