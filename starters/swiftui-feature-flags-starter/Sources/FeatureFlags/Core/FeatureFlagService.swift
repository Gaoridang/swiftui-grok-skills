import Foundation

/// Protocol that the rest of the application uses to evaluate feature flags.
///
/// ## Design Rationale
/// - The app should depend on this protocol, not on LaunchDarkly directly.
/// - This makes testing trivial (use `InMemoryFeatureFlagService` or `FeatureFlagOverrides`).
/// - It also makes it easier to migrate providers in the future if needed.
///
/// ## Guidelines for Implementations
/// - All evaluations must be fast and non-blocking on the main thread.
/// - Implementations should cache values where appropriate.
/// - Every implementation must support overrides for testing and debugging.
public protocol FeatureFlagService: AnyObject, Sendable {
    /// Returns the current value for the given flag, or the default if not available.
    func value(for flag: FeatureFlag) -> FeatureFlagEvaluation

    /// Boolean convenience. Returns `false` if the underlying value is not a boolean.
    func isEnabled(_ flag: FeatureFlag) -> Bool

    /// Registers a listener that will be called whenever the value of a specific flag changes.
    /// Listeners are weakly held where possible.
    func observe(_ flag: FeatureFlag, onChange: @escaping @Sendable (FeatureFlagEvaluation) -> Void) -> AnyCancellable

    /// Forces a refresh from the remote provider (if supported).
    /// Useful after login or significant context changes.
    func refresh() async
}

/// Minimal cancellable type so we don't force Combine on the whole app.
public protocol AnyCancellable: AnyObject {
    func cancel()
}

// MARK: - Default Convenience

public extension FeatureFlagService {
    func isEnabled(_ flag: FeatureFlag) -> Bool {
        value(for: flag).boolValue ?? false
    }
}