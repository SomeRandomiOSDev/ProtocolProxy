//
//  ProtocolProxyOverrideTests.swift
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

// MARK: - ProtocolProxyOverrideTests Definition

class ProtocolProxySwiftOverrideTests: XCTestCase {

    // MARK: Test Methods

    func testOverrideWithBlocksNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0

        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let block: @convention(block) () -> Void = {
            observerCallCount += 1
        }

        XCTAssertTrue(proxy.override(selector, using: block))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 0)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 0)
    }

    func testOverrideWithTargetNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        XCTAssertTrue(proxy.override(selector, target: overrideTarget))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: selector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: selector), 2)
    }

    func testOverrideWithTargetAndAlternateSelectorNoReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueNoArguments)
        let targetSelector = #selector(ArgsAndReturnValues._noReturnValueNoArguments)
        XCTAssertTrue(proxy.override(originalSelector, target: overrideTarget, targetSelector: targetSelector))

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 1)

        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 2)
    }

    // MARK: -

    func testOverrideWithBlocksReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        var observerCallCount = 0
        var overrideValue: Any?, returnValue: Any?

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let block: @convention(block) () -> Any = {
            observerCallCount += 1

            guard let overrideValue = overrideValue else { fatalError("Unwrap error") }
            return overrideValue
        }

        XCTAssertTrue(proxy.override(selector, using: block))

        overrideValue = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 1)
        XCTAssertEqual(implementer.callCount(for: selector), 0)
        XCTAssertTrue((returnValue as AnyObject?) === (overrideValue as AnyObject?))

        overrideValue = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(observerCallCount, 2)
        XCTAssertEqual(implementer.callCount(for: selector), 0)
        XCTAssertTrue((returnValue as AnyObject?) === (overrideValue as AnyObject?))
    }

    func testOverrideWithTargetReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.override(selector, target: overrideTarget))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: selector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: selector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: selector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(selector))
    }

    func testOverrideWithTargetAndAlternateSelectorReturnValueNoArguments() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)
        let targetSelector = #selector(ArgsAndReturnValues._returnValueNoArguments)
        var returnValue: Any?

        XCTAssertTrue(proxy.override(originalSelector, target: overrideTarget, targetSelector: targetSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 1)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(targetSelector))

        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueNoArguments()
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 2)
        XCTAssertEqual(returnValue as? String, NSStringFromSelector(targetSelector))
    }

    // MARK: -

    func testOverrideWithBlocksNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            let block: @convention(block) (AnyObject, AnyObject) -> Void = { _, arg in
                XCTAssertTrue(argument === arg)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.override(selector, using: block))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Void = { _, arg1, arg2 in
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)
                observerCallCount += 1
            }

            XCTAssertTrue(proxy.override(selector, using: block))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)

            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertNil(implementer.argument(for: selector, at: 1))

            //

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)

            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertNil(implementer.argument(for: selector, at: 1))
        }
    }

    func testOverrideWithTargetNoReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let overrideTarget = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
            var argument: AnyObject = NSObject()

            XCTAssertTrue(proxy.override(selector, target: overrideTarget))

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 1)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument)

            argument = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 2)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument)
        }
        do {
            let implementer = ArgsAndReturnValues()
            let overrideTarget = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

            XCTAssertTrue(proxy.override(selector, target: overrideTarget))

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 1)

            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument1)
            XCTAssertNil(implementer.argument(for: selector, at: 1))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 1) as AnyObject?) === argument2)

            argument1 = NSObject()
            argument2 = NSObject()
            (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 2)

            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument1)
            XCTAssertNil(implementer.argument(for: selector, at: 1))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 1) as AnyObject?) === argument2)
        }
    }

    func testOverrideWithTargetAndAlternateSelectorNoReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueOneArgument(_:))
        let targetSelector = #selector(ArgsAndReturnValues._noReturnValueOneArgument(_:))
        var argument: AnyObject = NSObject()

        XCTAssertTrue(proxy.override(originalSelector, target: overrideTarget, targetSelector: targetSelector))

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument)

        argument = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 2)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument)
    }

    func testOverrideWithTargetAndAlternateSelectorNoReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.noReturnValueTwoArguments(_:_:))
        let targetSelector = #selector(ArgsAndReturnValues._noReturnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()

        XCTAssertTrue(proxy.override(originalSelector, target: overrideTarget, targetSelector: targetSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 1))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 1))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 1))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 1) as AnyObject?) === argument2)

        argument1 = NSObject()
        argument2 = NSObject()
        (proxy as? ArgsAndReturnValuesProtocol)?.noReturnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 2)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 1))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 1))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 1))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 1) as AnyObject?) === argument2)
    }

    // MARK: -

    func testOverrideWithBlocksReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument: AnyObject = NSObject()
            var overrideValue: AnyObject = NSObject()
            var returnValue: Any?

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            let block: @convention(block) (AnyObject, AnyObject) -> Any = { _, arg in
                XCTAssertTrue(argument === arg)

                observerCallCount += 1
                return overrideValue
            }

            XCTAssertTrue(proxy.override(selector, using: block))

            argument = NSObject()
            overrideValue = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((returnValue as AnyObject?) === (overrideValue as AnyObject?))

            argument = NSObject()
            overrideValue = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((returnValue as AnyObject?) === (overrideValue as AnyObject?))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            var observerCallCount = 0
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var overrideValue: AnyObject = NSObject()
            var returnValue: Any?

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            let block: @convention(block) (AnyObject, AnyObject, AnyObject) -> Any = { _, arg1, arg2 in
                XCTAssertTrue(argument1 === arg1)
                XCTAssertTrue(argument2 === arg2)

                observerCallCount += 1
                return overrideValue
            }

            XCTAssertTrue(proxy.override(selector, using: block))

            argument1 = NSObject()
            argument2 = NSObject()
            overrideValue = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 1)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertNil(implementer.argument(for: selector, at: 1))
            XCTAssertTrue((returnValue as AnyObject?) === (overrideValue as AnyObject?))

            argument1 = NSObject()
            argument2 = NSObject()
            overrideValue = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(observerCallCount, 2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertNil(implementer.argument(for: selector, at: 1))
            XCTAssertTrue((returnValue as AnyObject?) === (overrideValue as AnyObject?))
        }
    }

    func testOverrideWithTargetReturnValueAndArguments() {
        do {
            let implementer = ArgsAndReturnValues()
            let overrideTarget = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
            var argument: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.override(selector, target: overrideTarget))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 1)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument)
            XCTAssertTrue((returnValue as? String) == NSStringFromSelector(selector))

            argument = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 2)
            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument)
            XCTAssertTrue((returnValue as? String) == NSStringFromSelector(selector))
        }
        do {
            let implementer = ArgsAndReturnValues()
            let overrideTarget = ArgsAndReturnValues()
            let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let selector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
            var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
            var returnValue: Any?

            XCTAssertTrue(proxy.override(selector, target: overrideTarget))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 1)

            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument1)
            XCTAssertNil(implementer.argument(for: selector, at: 1))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 1) as AnyObject?) === argument2)
            XCTAssertTrue((returnValue as? String) == NSStringFromSelector(selector))

            argument1 = NSObject()
            argument2 = NSObject()
            returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
            XCTAssertEqual(implementer.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 2)

            XCTAssertNil(implementer.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument1)
            XCTAssertNil(implementer.argument(for: selector, at: 1))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 1) as AnyObject?) === argument2)
            XCTAssertTrue((returnValue as? String) == NSStringFromSelector(selector))
        }
    }

    func testOverrideWithTargetAndAlternateSelectorReturnValueAndArgument() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))
        let targetSelector = #selector(ArgsAndReturnValues._returnValueOneArgument(_:))
        var argument: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.override(originalSelector, target: overrideTarget, targetSelector: targetSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument)
        XCTAssertTrue((returnValue as? String) == NSStringFromSelector(targetSelector))

        argument = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 2)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument)
        XCTAssertTrue((returnValue as? String) == NSStringFromSelector(targetSelector))
    }

    func testOverrideWithTargetAndAlternateSelectorReturnValueAndArguments() {
        let implementer = ArgsAndReturnValues()
        let overrideTarget = ArgsAndReturnValues()
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

        let originalSelector = #selector(ArgsAndReturnValuesProtocol.returnValueTwoArguments(_:_:))
        let targetSelector = #selector(ArgsAndReturnValues._returnValueTwoArguments(_:_:))
        var argument1: AnyObject = NSObject(), argument2: AnyObject = NSObject()
        var returnValue: Any?

        XCTAssertTrue(proxy.override(originalSelector, target: overrideTarget, targetSelector: targetSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 1))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 1))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 1))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 1) as AnyObject?) === argument2)

        XCTAssertTrue((returnValue as? String) == NSStringFromSelector(targetSelector))

        argument1 = NSObject()
        argument2 = NSObject()
        returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueTwoArguments(argument1, argument2)
        XCTAssertEqual(implementer.callCount(for: originalSelector), 0)
        XCTAssertEqual(implementer.callCount(for: targetSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: originalSelector), 0)
        XCTAssertEqual(overrideTarget.callCount(for: targetSelector), 2)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 0))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 0))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 0))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 0) as AnyObject?) === argument1)

        XCTAssertNil(implementer.argument(for: originalSelector, at: 1))
        XCTAssertNil(implementer.argument(for: targetSelector, at: 1))
        XCTAssertNil(overrideTarget.argument(for: originalSelector, at: 1))
        XCTAssertTrue((overrideTarget.argument(for: targetSelector, at: 1) as AnyObject?) === argument2)

        XCTAssertTrue((returnValue as? String) == NSStringFromSelector(targetSelector))
    }

    // MARK: -

    func testOverrideFailureCases() {
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)
        let overrideTarget = ArgsAndReturnValues()
        let block: @convention(block) () -> Void = { }

        // Selector that isn't part of the adopted protocol(s)
        XCTAssertFalse(proxy.override(#selector(NSCopying.copy(with:)), target: overrideTarget))
        XCTAssertFalse(proxy.override(#selector(NSCopying.copy(with:)), target: overrideTarget, targetSelector: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)))
        XCTAssertFalse(proxy.override(#selector(NSCopying.copy(with:)), using: block))

        // Invalid block type
        let cFunction: @convention(c) () -> Void = { }
        let explicitClosure: @convention(swift) () -> Void = { }
        let implicitClosure: () -> Void = { }

        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), using: NSObject()))
        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), using: cFunction))
        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), using: explicitClosure))
        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), using: implicitClosure))

        // Selector is already overridden with the proxy
        XCTAssertTrue(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), using: block))
        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), target: overrideTarget))
        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), target: overrideTarget, targetSelector: #selector(ArgsAndReturnValuesProtocol.returnValueNoArguments)))
        XCTAssertFalse(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), using: block))
    }

    func testOverrideTargetIsntRetained() {
        let proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: nil)
        weak var weakOverrideTarget: ArgsAndReturnValues?

        autoreleasepool {
            let overrideTarget = ArgsAndReturnValues()
            weakOverrideTarget = overrideTarget

            XCTAssertTrue(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), target: overrideTarget))
        }

        XCTAssertNil(weakOverrideTarget)

        //

        autoreleasepool {
            let overrideTarget = ArgsAndReturnValues()
            weakOverrideTarget = overrideTarget

            XCTAssertTrue(proxy.override(#selector(ArgsAndReturnValuesProtocol.returnValueNoArguments), target: overrideTarget, targetSelector: #selector(ArgsAndReturnValues._returnValueNoArguments)))
        }

        XCTAssertNil(weakOverrideTarget)
    }

    func testOverrideIsUnregisteredAfterBeingFreed() {
        let selector = #selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:))

        weak var weakOverrideTarget: ArgsAndReturnValues?
        var implementer: ArgsAndReturnValues?
        var proxy: ProtocolProxy?

        autoreleasepool {
            implementer = ArgsAndReturnValues()
            proxy = ProtocolProxy(protocol: ArgsAndReturnValuesProtocol.self, implementer: implementer)

            let overrideTarget = ArgsAndReturnValues()
            weakOverrideTarget = overrideTarget
            XCTAssertTrue(proxy?.override(#selector(ArgsAndReturnValuesProtocol.returnValueOneArgument(_:)), target: overrideTarget) == true)

            let argument = NSObject()
            let returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
            XCTAssertEqual(implementer?.callCount(for: selector), 0)
            XCTAssertEqual(overrideTarget.callCount(for: selector), 1)
            XCTAssertNil(implementer?.argument(for: selector, at: 0))
            XCTAssertTrue((overrideTarget.argument(for: selector, at: 0) as AnyObject?) === argument)
            XCTAssertTrue((returnValue as? String) == NSStringFromSelector(selector))
        }

        XCTAssertNil(weakOverrideTarget)

        let argument = NSObject()
        let returnValue = (proxy as? ArgsAndReturnValuesProtocol)?.returnValueOneArgument(argument)
        XCTAssertEqual(implementer?.callCount(for: selector), 1)
        XCTAssertTrue((implementer?.argument(for: selector, at: 0) as AnyObject?) === argument)
        XCTAssertTrue((returnValue as? String) == NSStringFromSelector(selector))
    }
}
