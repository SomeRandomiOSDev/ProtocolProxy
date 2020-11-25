//
//  ProtocolProxyTestsBase.swift
//  ProtocolProxy
//
//  Created by Joseph Newton on 11/16/20.
//  Copyright © 2020 SomeRandomiOSDev. All rights reserved.
//

import ObjectiveC

// MARK: - Protocol Extension

extension Protocol: Equatable {

    // MARK: Equatable Protocol Requirements

    public static func ==(lhs: Protocol, rhs: Protocol) -> Bool {
        return protocol_isEqual(lhs, rhs)
    }
}
