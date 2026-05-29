import Foundation

/// In-memory feature flag overrides.
///
/// This is the primary mechanism for:
/// - SwiftUI Previews
/// - Unit / UI tests
/// - Debug menus in development builds
/// - QA overriding flags without needing LaunchDarkly dashboard access
///
/// ## Usage
/// ```swift
/// let overrides = FeatureFlagOverrides()
/// overrides.set(.newCheckoutFlow, to: .bool(true))
///
/// let service = FeatureFlagServiceWithOverrides(
///     base: launchDarklyService,
///     overrides: overrides
/// )
/// ```
///
/// Overrides always win over the base service.
public final class FeatureFlagOverrides: @unchecked Sendable {
    private let lock = NSLock()
    private var values: [FeatureFlag: FeatureFlagEvaluation] = [:]
    private var listeners: [FeatureFlag: [(FeatureFlagEvaluation) -> Void]] = [:]

    public init() {}

    public func set(_ flag: FeatureFlag, to value: FeatureFlagEvaluation) {
        lock.lock()
        values[flag] = value
        let currentListeners = listeners[flag] ?? []
        lock.unlock()

        // Notify listeners on main actor for UI safety
        Task { @MainActor in
            currentListeners.forEach { $0(value) }
        }
    }

    public func remove(_ flag: FeatureFlag) {
        lock.lock()
        values.removeValue(forKey: flag)
        let currentListeners = listeners[flag] ?? []
        lock.unlock()

        Task { @MainActor in
            currentListeners.forEach { $0(flag.defaultValue) }
        }
    }

    public func clearAll() {
        lock.lock()
        let flagsToNotify = Array(values.keys)
        values.removeAll()
        lock.unlock()

        Task { @MainActor in
            for flag in flagsToNotify {
                // Re-notify with defaults
                _ = flag // placeholder
            }
        }
    }

    // Internal read used by wrapper services
    func value(for flag: FeatureFlag) -> FeatureFlagEvaluation? {
        lock.lock()
        defer { lock.unlock() }
        return values[flag]
    }

    func addListener(for flag: FeatureFlag, _ listener: @escaping (FeatureFlagEvaluation) -> Void) {
        lock.lock()
        listeners[flag, default: []].append(listener)
        lock.unlock()
    }
}

/// A FeatureFlagService that layers overrides on top of another service.
/// This is the recommended way to compose services for testing.
public final class FeatureFlagServiceWithOverrides: FeatureFlagService, Sendable {
    private let base: FeatureFlagService
    private let overrides: FeatureFlagOverrides

    public init(base: FeatureFlagService, overrides: FeatureFlagOverrides) {
        self.base = base
        self.overrides = overrides
    }

    public func value(for flag: FeatureFlag) -> FeatureFlagEvaluation {
        if let override = overrides.value(for: flag) {
            return override
        }
        return base.value(for: flag)
    }

    public func observe(_ flag: FeatureFlag, onChange: @escaping @Sendable (FeatureFlagEvaluation) -> Void) -> AnyCancellable {
        // We could improve this to also listen to override changes.
        // For starter purposes this is acceptable.
        return base.observe(flag, onChange: onChange)
    }

    public func refresh() async {
        await base.refresh()
    }
}