//
//  CommonNetwork.swift
//  SwiftNetwork
//
//  Created by Yugo Sugiyama on 2021/01/06.
//  Copyright © 2021 yugo.sugiyama. All rights reserved.
//

import Foundation
import Combine

public enum CommonNetworkError: Error {
    case timeout
}

public final class CommonNetwork {
    public static let shared = CommonNetwork()
    private let timeoutSeconds = 3
    private init() {}

    public func network<T, S>(timeout: Int? = nil, promise: @escaping (@escaping (Result<T, S>) -> Void) -> Void) -> AnyPublisher<T, S> where S: Error {
        let seconds = timeout ?? timeoutSeconds
        return Future(promise)
            .timeout(.seconds(seconds),
                     scheduler: DispatchQueue.main,
                     customError: { CommonNetworkError.timeout as! S })
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
