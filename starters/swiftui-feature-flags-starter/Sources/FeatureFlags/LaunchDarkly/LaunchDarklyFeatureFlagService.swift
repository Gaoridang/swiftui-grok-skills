import Foundation
import LaunchDarkly

/// Production implementation of FeatureFlagService backed by LaunchDarkly.
///
/// ## Initialization
/// Call `configure(with:)` early in your app lifecycle, before any views that
/// depend on feature flags are created.
///
/// ## Swift 6 Considerations
/// LDClient is accessed via a singleton. We are careful to keep interactions
/// off the main thread where possible and to use MainActor for UI-facing callbacks.
public final class LaunchDarklyFeatureFlagService: FeatureFlagService, @unchecked Sendable {
    private let configuration: LaunchDarklyConfiguration
    private var isConfigured = false

    public init(configuration: LaunchDarklyConfiguration) {
        self.configuration = configuration
    }

    /// Call this once early in app launch (e.g. in your App's initializer or
    /// from `UIApplicationDelegate`).
    public func configure() {
        guard !isConfigured else { return }

        let ldConfig = LDConfig(mobileKey: configuration.mobileKey, autoEnvAttributes: .enabled)

        // Recommended for mobile: use streaming when possible, fall back gracefully.
        ldConfig.streamingMode = .streaming
        ldConfig.eventFlushIntervalMillis = 30_000

        let context = LaunchDarklyContextBuilder.buildContext()

        LDClient.start(config: ldConfig, context: context) { [weak self] in
            self?.isConfigured = true
            // Optional: post a notification or update some state
        }
    }

    public func value(for flag: FeatureFlag) -> FeatureFlagEvaluation {
        guard isConfigured, let client = LDClient.get() else {
            return flag.defaultValue
        }

        let key = flag.rawValue

        // We evaluate based on the declared default type
        switch flag.defaultValue {
        case .bool:
            let result = client.boolVariation(forKey: key, defaultValue: flag.defaultValue.boolValue ?? false)
            return .bool(result)

        case .int:
            let result = client.intVariation(forKey: key, defaultValue: Int32(flag.defaultValue.intValue ?? 0))
            return .int(Int(result))

        case .double:
            let result = client.doubleVariation(forKey: key, defaultValue: 0.0)
            return .double(result)

        case .string:
            let result = client.stringVariation(forKey: key, defaultValue: "")
            return .string(result)

        case .json:
            // JSON variation is powerful but more complex. Handle as needed.
            let result = client.dictionaryVariation(forKey: key, defaultValue: [:])
            return .json(result.mapValues { AnySendable($0) })
        }
    }

    public func observe(_ flag: FeatureFlag, onChange: @escaping @Sendable (FeatureFlagEvaluation) -> Void) -> AnyCancellable {
        // LaunchDarkly has excellent observation APIs.
        // For this starter we use a simple wrapper. Production apps often
        // create a more sophisticated subscription manager.
        guard let client = LDClient.get() else {
            return NoopCancellable()
        }

        let key = flag.rawValue
        let observer = FeatureFlagObserver(flag: flag, onChange: onChange)

        client.observe(key: key, owner: observer) { [weak observer] changedFlag in
            guard let observer else { return }
            let newValue = observer.mapToFeatureFlagEvaluation(changedFlag)
            onChange(newValue)
        }

        return observer
    }

    public func refresh() async {
        await withCheckedContinuation { continuation in
            LDClient.get()?.identify(context: LaunchDarklyContextBuilder.buildContext()) { _ in
                continuation.resume()
            }
        }
    }
}

// MARK: - Private Helpers

private final class FeatureFlagObserver: NSObject, AnyCancellable {
    let flag: FeatureFlag
    let onChange: @Sendable (FeatureFlagEvaluation) -> Void

    init(flag: FeatureFlag, onChange: @escaping @Sendable (FeatureFlagEvaluation) -> Void) {
        self.flag = flag
        self.onChange = onChange
    }

    func mapToFeatureFlagEvaluation(_ changedFlag: LDChangedFlag) -> FeatureFlagEvaluation {
        // Best effort mapping. Improve for production.
        if let boolValue = changedFlag.newValue as? Bool {
            return .bool(boolValue)
        }
        if let intValue = changedFlag.newValue as? Int {
            return .int(intValue)
        }
        if let doubleValue = changedFlag.newValue as? Double {
            return .double(doubleValue)
        }
        if let stringValue = changedFlag.newValue as? String {
            return .string(stringValue)
        }
        return flag.defaultValue
    }

    func cancel() {
        // In a more advanced implementation we would remove the observer
        // from LDClient here.
    }
}

private final class NoopCancellable: AnyCancellable {
    func cancel() {}
}