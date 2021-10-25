//
//  ProtocolProxyBasicTests.swift
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

// MARK: - ProtocolProxyBasicTests Definition

class ProtocolProxySwiftBasicTests: XCTestCase {

    // MARK: Test Methods

    func testProtocolAdoption() {
        let allProtocols: [Protocol] = [BasicTestProtocol.self, NSCopying.self, NSMutableCopying.self, NSCoding.self, NSSecureCoding.self, NSFastEnumeration.self]

        self.iterateAllPermutations(of: allProtocols) { protocols in
            let proxy: ProtocolProxy

            if protocols.count == 1 {
                proxy = ProtocolProxy(protocol: protocols[0], implementer: nil)
            } else {
                proxy = ProtocolProxy(protocols: protocols, implementer: nil)
            }

            for `protocol` in allProtocols {
                XCTAssertEqual(proxy.adoptedProtocols.contains { protocol_isEqual($0, `protocol`) }, proxy.conforms(to: `protocol`), "Failure when comparing protocol conformances: [\(namesForProtocols(protocols).joined(separator: ", "))]")
            }
        }

        do {
            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: nil)

            XCTAssertTrue(proxy is BasicTestProtocol)
            XCTAssertFalse(proxy is NSCopying)
            XCTAssertFalse(proxy is NSMutableCopying)
            XCTAssertFalse(proxy is NSCoding)
            XCTAssertFalse(proxy is NSFastEnumeration)
        }
        do {
            let proxy = ProtocolProxy(protocol: NSCopying.self, implementer: nil)

            XCTAssertFalse(proxy is BasicTestProtocol)
            XCTAssertTrue(proxy is NSCopying)
            XCTAssertFalse(proxy is NSMutableCopying)
            XCTAssertFalse(proxy is NSCoding)
            XCTAssertFalse(proxy is NSFastEnumeration)
        }
        do {
            let proxy = ProtocolProxy(protocol: NSMutableCopying.self, implementer: nil)

            XCTAssertFalse(proxy is BasicTestProtocol)
            XCTAssertFalse(proxy is NSCopying)
            XCTAssertTrue(proxy is NSMutableCopying)
            XCTAssertFalse(proxy is NSCoding)
            XCTAssertFalse(proxy is NSFastEnumeration)
        }
        do {
            let proxy = ProtocolProxy(protocol: NSCoding.self, implementer: nil)

            XCTAssertFalse(proxy is BasicTestProtocol)
            XCTAssertFalse(proxy is NSCopying)
            XCTAssertFalse(proxy is NSMutableCopying)
            XCTAssertTrue(proxy is NSCoding)
            XCTAssertFalse(proxy is NSFastEnumeration)
        }
        do {
            let proxy = ProtocolProxy(protocol: NSFastEnumeration.self, implementer: nil)

            XCTAssertFalse(proxy is BasicTestProtocol)
            XCTAssertFalse(proxy is NSCopying)
            XCTAssertFalse(proxy is NSMutableCopying)
            XCTAssertFalse(proxy is NSCoding)
            XCTAssertTrue(proxy is NSFastEnumeration)
        }
    }

    func testRespondsToSelector() throws {
        let allProtocols: [Protocol] = [BasicTestProtocol.self, NSCopying.self, NSMutableCopying.self, NSCoding.self, NSFastEnumeration.self]
        let allSelectors: [String: Selector] = [
            String(cString: protocol_getName(BasicTestProtocol.self)): #selector(BasicTestProtocol.foobar),
            String(cString: protocol_getName(NSCopying.self)): #selector(NSCopying.copy(with:)),
            String(cString: protocol_getName(NSMutableCopying.self)): #selector(NSMutableCopying.mutableCopy(with:)),
            String(cString: protocol_getName(NSCoding.self)): #selector(NSCoding.encode(with:)),
            String(cString: protocol_getName(NSFastEnumeration.self)): #selector(NSFastEnumeration.countByEnumerating(with:objects:count:))
        ]

        try iterateAllPermutations(of: allProtocols) { protocols in
            let proxy: ProtocolProxy

            if protocols.count == 1 {
                proxy = ProtocolProxy(protocol: protocols[0], implementer: nil)
            } else {
                proxy = ProtocolProxy(protocols: protocols, implementer: nil)
            }

            for `protocol` in allProtocols {
                let protocolName = String(cString: protocol_getName(`protocol`))
                let selector = try XCTUnwrap(allSelectors[protocolName])

                XCTAssertEqual(proxy.adoptedProtocols.contains { protocol_isEqual($0, `protocol`) }, proxy.responds(to: selector), "Failure when checking response to selector: \(NSStringFromSelector(selector)) | [\(namesForProtocols(protocols).joined(separator: ", "))]")
            }
        }

        do {
            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: BasicTestDelegate())

            XCTAssertTrue(proxy.responds(to: #selector(BasicTestProtocol.foobar)))
            XCTAssertFalse(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar))) // -maybeFoobar is optional and the proxy's implementer doesn't implement it
            XCTAssertFalse(proxy.responds(to: #selector(NSCopying.copy(with:))))
            XCTAssertFalse(proxy.responds(to: #selector(NSMutableCopying.mutableCopy(with:))))
            XCTAssertFalse(proxy.responds(to: #selector(NSCoding.encode(with:))))
            XCTAssertFalse(proxy.responds(to: #selector(NSFastEnumeration.countByEnumerating(with:objects:count:))))
        }
        do {
            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: BasicTestDelegate2())

            XCTAssertTrue(proxy.responds(to: #selector(BasicTestProtocol.foobar)))
            XCTAssertTrue(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar))) // -maybeFoobar is optional and the proxy's implementer does implement it
            XCTAssertFalse(proxy.responds(to: #selector(NSCopying.copy(with:))))
            XCTAssertFalse(proxy.responds(to: #selector(NSMutableCopying.mutableCopy(with:))))
            XCTAssertFalse(proxy.responds(to: #selector(NSCoding.encode(with:))))
            XCTAssertFalse(proxy.responds(to: #selector(NSFastEnumeration.countByEnumerating(with:objects:count:))))
        }
        do {
            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: BasicTestDelegate())
            proxy.respondsToSelectorsWithObservers = false // Default value

            let observer = BasicTestDelegate2()
            XCTAssertFalse(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))

            XCTAssertTrue(proxy.addObserver(observer, for: #selector(BasicTestProtocol.maybeFoobar), beforeObservedSelector: true))
            XCTAssertFalse(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))

            XCTAssertTrue(proxy.addObserver(observer, for: #selector(BasicTestProtocol.maybeFoobar), beforeObservedSelector: false))
            XCTAssertFalse(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))
        }
        do {
            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: BasicTestDelegate())
            proxy.respondsToSelectorsWithObservers = true

            let observer = BasicTestDelegate2()

            XCTAssertFalse(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))
            XCTAssertTrue(proxy.addObserver(observer, for: #selector(BasicTestProtocol.maybeFoobar), beforeObservedSelector: true))
            XCTAssertTrue(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))
        }
        do {
            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: BasicTestDelegate())
            proxy.respondsToSelectorsWithObservers = true

            let observer = BasicTestDelegate2()

            XCTAssertFalse(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))
            XCTAssertTrue(proxy.addObserver(observer, for: #selector(BasicTestProtocol.maybeFoobar), beforeObservedSelector: false))
            XCTAssertTrue(proxy.responds(to: #selector(BasicTestProtocol.maybeFoobar)))
        }
    }

    func testRespondsToSelectors() throws {
        // Selectors declared on the public interface of ProtocolProxy
        let declaredSelectors = [
            #selector(getter: ProtocolProxy.implementer),
            #selector(getter: ProtocolProxy.adoptedProtocols),
            #selector(getter: ProtocolProxy.respondsToSelectorsWithObservers),
            #selector(setter: ProtocolProxy.respondsToSelectorsWithObservers),

            #selector(ProtocolProxy.init(protocol:implementer:)),
            #selector(ProtocolProxy.init(protocol:stronglyRetainedImplementer:)),
            #selector(ProtocolProxy.init(protocols:implementer:)),
            #selector(ProtocolProxy.init(protocols:stronglyRetainedImplementer:)),

            "overrideSelector:withTarget:".withCString { sel_registerName($0) }, // NS_REFINED_FOR_SWIFT
            "overrideSelector:withTarget:targetSelector:".withCString { sel_registerName($0) }, // NS_REFINED_FOR_SWIFT
            #selector(ProtocolProxy.override(_:using:)),

            "addObserver:forSelector:beforeObservedSelector:".withCString { sel_registerName($0) }, // NS_REFINED_FOR_SWIFT
            "addObserver:forSelector:beforeObservedSelector:observerSelector:".withCString { sel_registerName($0) }, // NS_REFINED_FOR_SWIFT
            #selector(ProtocolProxy.addObserver(for:beforeObservedSelector:using:))
        ]

        let proxy = ProtocolProxy(protocol: NSObjectProtocol.self, implementer: nil)

        for selector in declaredSelectors {
            XCTAssertTrue(proxy.responds(to: selector), "Expected ProtocolProxy to respond to `-\(String(cString: sel_getName(selector)))`")
        }
    }

    func testBasicForwarding() {
        let test = BasicTestClass()

        do {
            let delegate = BasicTestDelegate()
            test.delegate = delegate

            XCTAssertEqual(delegate.foobarCount, 0)
            XCTAssertEqual(delegate.maybeFoobarCount, 0)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 1)
            XCTAssertEqual(delegate.maybeFoobarCount, 0)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 2)
            XCTAssertEqual(delegate.maybeFoobarCount, 0)

            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: delegate)
            test.delegate = (proxy as? BasicTestProtocol)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 3)
            XCTAssertEqual(delegate.maybeFoobarCount, 0)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 4)
            XCTAssertEqual(delegate.maybeFoobarCount, 0)
        }

        do {
            let delegate = BasicTestDelegate2()
            test.delegate = delegate

            XCTAssertEqual(delegate.foobarCount, 0)
            XCTAssertEqual(delegate.maybeFoobarCount, 0)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 1)
            XCTAssertEqual(delegate.maybeFoobarCount, 1)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 2)
            XCTAssertEqual(delegate.maybeFoobarCount, 2)

            let proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: delegate)
            test.delegate = (proxy as? BasicTestProtocol)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 3)
            XCTAssertEqual(delegate.maybeFoobarCount, 3)

            test.foobar()
            test.maybeFoobar()
            XCTAssertEqual(delegate.foobarCount, 4)
            XCTAssertEqual(delegate.maybeFoobarCount, 4)
        }
    }

    func testImplementerIsntLeaked() {
        var proxy: ProtocolProxy?
        weak var weakImplementer: AnyObject?

        autoreleasepool {
            var implementer: AnyObject? = NSObject()
            weakImplementer = implementer
            XCTAssertNotNil(weakImplementer)

            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: implementer)
            XCTAssertNotNil(weakImplementer)

            implementer = nil
            XCTAssertNotNil(weakImplementer) // proxy should still be retaining the implementer

            proxy = nil
        }

        XCTAssertNil(weakImplementer) // proxy should have released the implementer

        //

        autoreleasepool {
            var implementer: AnyObject? = NSObject()
            weakImplementer = implementer
            XCTAssertNotNil(weakImplementer)

            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: implementer)
            implementer = nil
        }

        XCTAssertNotNil(proxy)
        XCTAssertNil(weakImplementer) // proxy shouldn't have retained implementer to begin with
    }

    func testProtocolProxyProperties() {
        var proxy: ProtocolProxy?
        var implementer: AnyObject? = NSObject()

        do {
            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: nil)
            XCTAssertNil(proxy?.implementer)

            let adoptedProtocols = proxy?.adoptedProtocols
            XCTAssertEqual(adoptedProtocols?.count, 2)
            XCTAssertEqual(adoptedProtocols?.contains { protocol_isEqual($0, BasicTestProtocol.self) }, true)
            XCTAssertEqual(adoptedProtocols?.contains { protocol_isEqual($0, NSObjectProtocol.self) }, true)
        }
        do {
            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: implementer)
            XCTAssertTrue(proxy?.implementer === implementer)

            let adoptedProtocols = proxy?.adoptedProtocols
            XCTAssertEqual(adoptedProtocols?.count, 2)
            XCTAssertEqual(adoptedProtocols?.contains { protocol_isEqual($0, BasicTestProtocol.self) }, true)
            XCTAssertEqual(adoptedProtocols?.contains { protocol_isEqual($0, NSObjectProtocol.self) }, true)
        }

        //

        weak var weakImplementer: AnyObject?

        autoreleasepool {
            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: implementer)
            weakImplementer = proxy?.implementer

            XCTAssertNotNil(weakImplementer)

            implementer = nil
            proxy = nil
        }

        XCTAssertNil(weakImplementer)

        //

        autoreleasepool {
            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, stronglyRetainedImplementer: NSObject())
            weakImplementer = proxy?.implementer

            XCTAssertNotNil(weakImplementer)

            implementer = nil
            proxy = nil
        }

        XCTAssertNil(weakImplementer)

        //

        var strongReference: NSArray?
        weak var weakReference: NSArray?

        autoreleasepool {
            proxy = ProtocolProxy(protocol: BasicTestProtocol.self, implementer: nil)

            strongReference = proxy?.adoptedProtocols as NSArray?
            weakReference = strongReference

            XCTAssertNotNil(weakReference)
            proxy = nil
        }

        XCTAssertNotNil(weakReference)

        autoreleasepool { strongReference = nil }
        XCTAssertNil(weakReference)
    }

    func testProtocolProxyPropertiesAreOverridden() {
        let implementerImplementer = NSObject()
        let implementer = ProtocolProxyPropertiesProtocolImplementer()
        implementer.implementer = implementerImplementer
        implementer.adoptedProtocols = [NSMutableCopying.self]
        implementer.respondsToSelectorsWithObservers = true

        let proxy = ProtocolProxy(protocol: ProtocolProxyPropertiesProtocol.self, implementer: implementer)

        XCTAssertFalse(proxy.implementer === implementer) // Expected value if not overridden
        XCTAssertTrue(proxy.implementer === implementerImplementer)

        XCTAssertFalse(proxy.adoptedProtocols == [ProtocolProxyPropertiesProtocol.self, NSObjectProtocol.self]); // Expected value if not overridden
        XCTAssertTrue(proxy.adoptedProtocols == [NSMutableCopying.self])
        XCTAssertTrue(proxy.conforms(to: NSObjectProtocol.self))
        XCTAssertTrue(proxy.conforms(to: ProtocolProxyPropertiesProtocol.self))
        XCTAssertFalse(proxy.conforms(to: NSMutableCopying.self))

        XCTAssertTrue(proxy.respondsToSelectorsWithObservers)

        //

        let newImplementer = NSObject()
        implementer.implementer = newImplementer
        XCTAssertTrue(proxy.implementer === newImplementer)

        implementer.adoptedProtocols = [NSSecureCoding.self]
        XCTAssertTrue(proxy.adoptedProtocols == [NSSecureCoding.self])
        XCTAssertTrue(proxy.conforms(to: NSObjectProtocol.self))
        XCTAssertTrue(proxy.conforms(to: ProtocolProxyPropertiesProtocol.self))
        XCTAssertFalse(proxy.conforms(to: NSSecureCoding.self))

        implementer.respondsToSelectorsWithObservers = false
        XCTAssertFalse(proxy.respondsToSelectorsWithObservers)

        //

        do {
            let proxy = ProtocolProxy(protocol: ProtocolProxyPropertiesProtocol.self, implementer: implementer)
            XCTAssertFalse(proxy.implementer === implementer)
            XCTAssertEqual(implementer.foobarCount, 0)

            (proxy as? ProtocolProxyPropertiesProtocol)?.foobar()
            XCTAssertEqual(implementer.foobarCount, 1)

            (proxy as? ProtocolProxyPropertiesProtocol)?.foobar()
            XCTAssertEqual(implementer.foobarCount, 2)
        }
        do { // Setting `proxy.respondsToSelectorsWithObservers` when overridden by an adopted protocol has no affect
            let proxy = ProtocolProxy(protocol: ProtocolProxyPropertiesProtocol.self, implementer: implementer)
            proxy.respondsToSelectorsWithObservers = false

            XCTAssertFalse(implementer.respondsToSelectorsWithObservers)
            XCTAssertFalse(proxy.responds(to: #selector(ProtocolProxyPropertiesProtocol.dontActuallyImplementThis)))
            XCTAssertTrue(proxy.addObserver(self, for: #selector(ProtocolProxyPropertiesProtocol.dontActuallyImplementThis), beforeObservedSelector: true))
            XCTAssertFalse(proxy.responds(to: #selector(ProtocolProxyPropertiesProtocol.dontActuallyImplementThis)))
        }
        do { // Setting `proxy.respondsToSelectorsWithObservers` when overridden by an adopted protocol has no affect
            let proxy = ProtocolProxy(protocol: ProtocolProxyPropertiesProtocol.self, implementer: implementer)
            proxy.respondsToSelectorsWithObservers = false

            XCTAssertFalse(implementer.respondsToSelectorsWithObservers)
            XCTAssertFalse(proxy.responds(to: #selector(ProtocolProxyPropertiesProtocol.dontActuallyImplementThis)))
            XCTAssertTrue(proxy.addObserver(self, for: #selector(ProtocolProxyPropertiesProtocol.dontActuallyImplementThis), beforeObservedSelector: true))
            XCTAssertFalse(proxy.responds(to: #selector(ProtocolProxyPropertiesProtocol.dontActuallyImplementThis))) // `respondsToSelectorsWithObservers` is overridden so the internal instance variable that controls this behavior wasn't actually set.
        }
    }

    func testAllPropertyAttributesCombinations() {
        let proxy = ProtocolProxy(protocol: AllPropertyAttributeCombinationsProtocol.self, implementer: nil)

        do { // `assign` properties
            let readonlyIndexes = NSIndexSet(indexesIn: NSRange(location: 2, length: 4))
            let customGetterIndexes = NSIndexSet(indexesIn: NSRange(location: 4, length: 6))
            let customSetterIndexes = NSIndexSet(indexesIn: NSRange(location: 8, length: 4))

            for i in 0 ..< 12 {
                let getter = "assignProperty\(i)"
                let customGetter = "customAssignProperty\(i)Getter"

                let setter = "setAssignProperty\(i):"
                let customSetter = "customAssignProperty\(i)Setter:"

                if customGetterIndexes.contains(i) {
                    XCTAssertTrue(proxy.responds(to: customGetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol \(customGetter)]")
                } else {
                    XCTAssertTrue(proxy.responds(to: getter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to property getter: -[AllPropertyAttributeCombinationsProtocol \(getter)]")
                    XCTAssertFalse(proxy.responds(to: customGetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol \(customGetter)]")
                }

                if !readonlyIndexes.contains(i) {
                    if customSetterIndexes.contains(i) {
                        XCTAssertTrue(proxy.responds(to: customSetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol \(customSetter)]")
                    } else {
                        XCTAssertTrue(proxy.responds(to: setter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to property setter: -[AllPropertyAttributeCombinationsProtocol \(setter)]")
                        XCTAssertFalse(proxy.responds(to: customSetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol \(customSetter)]")
                    }
                } else {
                    XCTAssertFalse(proxy.responds(to: setter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol \(setter)]")
                    XCTAssertFalse(proxy.responds(to: customSetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to custom property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol \(customSetter)]")
                }
            }
        }
        do { // `strong`, `copy`, `weak`, and `unsafe_unretained` properties
            for referenceAttribute in ["strong", "copy", "weak", "unsafeUnretained"] {
                let readonlyIndexes = NSMutableIndexSet(indexesIn: NSRange(location: 2, length: 4))
                readonlyIndexes.add(in: NSRange(location: 14, length: 4))
                let customGetterIndexes = NSMutableIndexSet(indexesIn: NSRange(location: 4, length: 6))
                customGetterIndexes.add(in: NSRange(location: 16, length: 6))
                let customSetterIndexes = NSMutableIndexSet(indexesIn: NSRange(location: 8, length: 4))
                customSetterIndexes.add(in: NSRange(location: 20, length: 4))

                for i in 0 ..< 24 {
                    let getter = "\(referenceAttribute)Property\(i)"
                    let customGetter = "custom\(capitalizeFirstLetter(in: referenceAttribute))Property\(i)Getter"

                    let setter = "set\(capitalizeFirstLetter(in: referenceAttribute))Property\(i):"
                    let customSetter = "custom\(capitalizeFirstLetter(in: referenceAttribute))Property\(i)Setter:"

                    if customGetterIndexes.contains(i) {
                        XCTAssertTrue(proxy.responds(to: customGetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol \(customGetter)]")
                    } else {
                        XCTAssertTrue(proxy.responds(to: getter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to property getter: -[AllPropertyAttributeCombinationsProtocol \(getter)]")
                        XCTAssertFalse(proxy.responds(to: customGetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to custom property getter: -[AllPropertyAttributeCombinationsProtocol \(customGetter)]")
                    }

                    if !readonlyIndexes.contains(i) {
                        if customSetterIndexes.contains(i) {
                            XCTAssertTrue(proxy.responds(to: customSetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol \(customSetter)]")
                        } else {
                            XCTAssertTrue(proxy.responds(to: setter.withCString { sel_registerName($0) }), "Expected ProtocolProxy to respond to property setter: -[AllPropertyAttributeCombinationsProtocol \(setter)]")
                            XCTAssertFalse(proxy.responds(to: customSetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to custom property setter: -[AllPropertyAttributeCombinationsProtocol \(customSetter)]")
                        }
                    } else {
                        XCTAssertFalse(proxy.responds(to: setter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol \(setter)]")
                        XCTAssertFalse(proxy.responds(to: customSetter.withCString { sel_registerName($0) }), "Expected ProtocolProxy not to respond to custom property setter (property is readonly): -[AllPropertyAttributeCombinationsProtocol \(customSetter)]")
                    }
                }
            }
        }
    }

    // MARK: Private Methods

    private func iterateAllPermutations<Element>(of elements: [Element], using block: ([Element]) throws -> Void) rethrows {
        var iterate: (([Element]) -> NSOrderedSet)?
        let iterator: ([Element]) -> NSOrderedSet = { elements in
            let set = NSMutableOrderedSet()
            set.add(elements)

            if elements.count > 1 {
                for i in 0 ..< elements.count {
                    var subelements = elements
                    subelements.remove(at: i)

                    set.union(iterate?(subelements) ?? NSOrderedSet())
                }
            }

            return set
        }

        iterate = iterator
        for permutation in (iterate?(elements).array ?? []) {
            try block((permutation as? [Element]) ?? [])
        }
    }

    private func namesForProtocols(_ protocols: [Protocol]) -> [String] {
        return protocols.map { String(cString: protocol_getName($0)) }
    }

    private func capitalizeFirstLetter(in string: String) -> String {
        return String(string[string.startIndex]).uppercased() + String(string[string.index(after: string.startIndex)...])
    }
}
