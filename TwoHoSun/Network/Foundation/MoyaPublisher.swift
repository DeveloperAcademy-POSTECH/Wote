//
//  MoyaPublisher.swift
//  TwoHoSun
//
//  Created by 235 on 11/10/23.
//
import Combine
import SwiftUI

import Moya

internal class MoyaPublisher<Output>: Publisher {

    internal typealias Failure = MoyaError

    private class Subscription: Combine.Subscription {
        private let performCall: () -> Moya.Cancellable?
        private var cancellable: Moya.Cancellable?

        init(subscriber: AnySubscriber<Output, MoyaError>, callback: @escaping (AnySubscriber<Output, MoyaError>) -> Moya.Cancellable?) {
            performCall = { callback(subscriber) }
        }

        func request(_ demand: Subscribers.Demand) {
            guard demand > .none else { return }

            cancellable = performCall()
        }

        func cancel() {
            cancellable?.cancel()
        }
    }

    private let callback: (AnySubscriber<Output, MoyaError>) -> Moya.Cancellable?

    init(callback: @escaping (AnySubscriber<Output, MoyaError>) -> Moya.Cancellable?) {
        self.callback = callback
    }

    internal func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = Subscription(subscriber: AnySubscriber(subscriber), callback: callback)
        subscriber.receive(subscription: subscription)
    }
}
public extension MoyaProvider {
    func requestPublisher(_ target: Target, callbackQueue: DispatchQueue? = nil) -> AnyPublisher<Response, MoyaError> {
          return MoyaPublisher { [weak self] subscriber in
                  return self?.request(target, callbackQueue: callbackQueue, progress: nil) { result in
                      switch result {
                      case let .success(response):
                          _ = subscriber.receive(response)
                          subscriber.receive(completion: .finished)
                      case let .failure(error):
                          subscriber.receive(completion: .failure(error))
                      }
                  }
              }
              .eraseToAnyPublisher()
      }
}
