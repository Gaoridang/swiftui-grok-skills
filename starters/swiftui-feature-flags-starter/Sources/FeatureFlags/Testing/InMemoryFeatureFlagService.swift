import Foundation

/// Simple in-memory FeatureFlagService useful for:
/// - SwiftUI Previews
/// - Early app bootstrapping before LaunchDarkly is ready
/// - Isolated unit tests
public final class InMemoryFeatureFlagService: FeatureFlagService, Sendable {
    private let values: [FeatureFlag: FeatureFlagEvaluation]

    public init(values: [FeatureFlag: FeatureFlagEvaluation] = [:]) {
        // Start with all defaults, then overlay provided values
        var initial = Dictionary(uniqueKeysWithValues: FeatureFlag.allCases.map { ($0, $0.defaultValue) })
        for (flag, value) in values {
            initial[flag] = value
        }
        self.values = initial
    }

    public func value(for flag: FeatureFlag) -> FeatureFlagEvaluation {
        values[flag] ?? flag.defaultValue
    }

    public func observe(_ flag: FeatureFlag, onChange: @escaping @Sendable (FeatureFlagEvaluation) -> Void) -> AnyCancellable {
        // In-memory version doesn't support live updates in this starter implementation.
        // Real implementations (LaunchDarkly) should support this properly.
        return NoopCancellable()
    }

    public func refresh() async {
        // No-op for in-memory
    }
}

private final class NoopCancellable: AnyCancellable {
    func cancel() {}
}