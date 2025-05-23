/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2019-Present Datadog, Inc.
 */

#if os(iOS)
import Foundation
import DatadogInternal

/// An observer notifying on`RUMContext` changes.
internal protocol RUMContextObserver {
    /// Starts notifying on distinct changes to `RUMContext`.
    ///
    /// - Parameters:
    ///   - queue: a queue to call `notify` block on
    ///   - notify: a closure receiving new `RUMContext` or `nil` if current RUM session is not sampled
    func observe(on queue: Queue, notify: @escaping (RUMCoreContext?) -> Void)
}

/// Receives RUM context from `DatadogCore` and notifies it through `RUMContextObserver` interface.
internal class RUMContextReceiver: FeatureMessageReceiver, RUMContextObserver {
    /// Notifies new `RUMContext` or `nil` if current RUM session is not sampled.
    private var onNew: ((RUMCoreContext?) -> Void)?
    private var previous: RUMCoreContext?

    // MARK: - FeatureMessageReceiver

    func receive(message: FeatureMessage, from core: DatadogCoreProtocol) -> Bool {
        guard case let .context(context) = message else {
            return false
        }

        let new = context.additionalContext(ofType: RUMCoreContext.self)

        // Notify only if it has changed:
        if new != previous {
            onNew?(new)
            previous = new
        }

        return true
    }

    // MARK: - RUMContextObserver

    func observe(on queue: Queue, notify: @escaping (RUMCoreContext?) -> Void) {
        onNew = { new in
            queue.run {
                notify(new)
            }
        }
    }
}

#endif
