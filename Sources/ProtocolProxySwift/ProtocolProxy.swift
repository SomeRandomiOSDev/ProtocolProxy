//
//  ProtocolProxy.swift
//  ProtocolProxy
//
//  Created by Joseph Newton on 11/20/20.
//  Copyright © 2020 Some Random iOS Dev. All rights reserved.
//

#if SWIFT_PACKAGE
import ObjectiveC
import ProtocolProxy
#endif // #if SWIFT_PACKAGE

// MARK: - ProtocolProxy Extension

extension ProtocolProxy {

    // MARK: Public Methods

    public func override(_ selector: Selector, target: Any, targetSelector: Selector? = nil) -> Bool {
        return __overrideSelector(selector, withTarget: target, targetSelector: targetSelector)
    }

    public func addObserver(_ observer: Any, for selector: Selector, beforeObservedSelector: Bool, observerSelector: Selector? = nil) -> Bool {
        return __addObserver(observer, for: selector, beforeObservedSelector: beforeObservedSelector, observerSelector: observerSelector)
    }
}
