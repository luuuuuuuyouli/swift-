//
//  Namespace.swift
//  Base
//
//  Created by daihz on 2019/2/1.
//  Copyright © 2019年 daihz. All rights reserved.
//

import UIKit

public protocol NamespaceWrappable {
    associatedtype WrapperType
    var gd: WrapperType { get }
    static var gd: WrapperType.Type { get }
}

public extension NamespaceWrappable {
    var gd: NamespaceWrapper<Self> {
        return NamespaceWrapper(value: self)
    }
    
    static var gd: NamespaceWrapper<Self>.Type {
        return NamespaceWrapper.self
    }
}

public protocol TypeWrapperProtocol {
    associatedtype WrappedType
    var wrappedValue: WrappedType { get }
    init(value: WrappedType)
}

public struct NamespaceWrapper<T>: TypeWrapperProtocol {
    public let wrappedValue: T
    public init(value: T) {
        self.wrappedValue = value
    }
}

extension String: NamespaceWrappable {}
extension TypeWrapperProtocol where WrappedType == String {
     
}
