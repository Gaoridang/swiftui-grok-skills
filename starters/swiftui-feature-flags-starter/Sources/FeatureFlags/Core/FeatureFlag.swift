import Foundation

/// Type-safe representation of all feature flags in the app.
///
/// This is the single source of truth. Every feature flag used anywhere
/// in the application must be defined here.
///
/// ## Adding a New Flag
/// 1. Add a new case here with a clear, descriptive name.
/// 2. Document the purpose, owner, and planned removal condition.
/// 3. Provide a safe default value.
/// 4. Update any relevant UI or logic that should react to the flag.
///
/// ## Naming Guidelines
/// - Use clear, intention-revealing names (e.g. `newCheckoutFlow` not `flagA`)
/// - Group related flags with common prefixes when it improves clarity
/// - Prefer past/present tense for experiments (`usingNewSearch`, `showAiRecommendations`)
public enum FeatureFlag: String, CaseIterable, Sendable {
    // MARK: - Example Release Flags

    /// Enables the redesigned checkout experience.
    /// Owner: @design-team
    /// Planned removal: After full rollout is complete and old flow is deleted (est. Q4 2026)
    case newCheckoutFlow

    /// Shows AI-powered product recommendations on the product detail page.
    /// Owner: @growth
    /// Experiment: Part of "AI Recommendations v2" experiment
    case aiProductRecommendations

    /// Enables real-time order tracking updates via WebSocket instead of polling.
    /// Owner: @platform
    /// Kill switch: Yes — critical path
    case realTimeOrderTracking

    // MARK: - Example Ops / Config Flags

    /// Maximum number of items allowed in the shopping cart before showing upsell.
    /// This is a tunable value, not just a boolean.
    case maxCartItemsBeforeUpsell

    // MARK: - Internal / Debug Flags

    /// Shows debug information and quick override controls in the app.
    /// Should only be enabled for internal builds or via debug menu.
    case internalDebugMenu
}

// MARK: - Default Values

public extension FeatureFlag {
    /// Safe, conservative default value when LaunchDarkly is unavailable
    /// or the flag has not been evaluated yet.
    var defaultValue: FeatureFlagEvaluation {
        switch self {
        case .newCheckoutFlow:
            return .bool(false)

        case .aiProductRecommendations:
            return .bool(false)

        case .realTimeOrderTracking:
            return .bool(true) // Safer to have real-time on by default if infrastructure supports it

        case .maxCartItemsBeforeUpsell:
            return .int(5)

        case .internalDebugMenu:
            return .bool(false)
        }
    }

    /// Human-readable description for debugging and internal tools.
    var description: String {
        switch self {
        case .newCheckoutFlow:
            return "Redesigned checkout experience (2026)"
        case .aiProductRecommendations:
            return "AI product recommendations on PDP"
        case .realTimeOrderTracking:
            return "Real-time order tracking via WebSocket"
        case .maxCartItemsBeforeUpsell:
            return "Cart size threshold before showing upsell"
        case .internalDebugMenu:
            return "Internal debug menu and flag overrides"
        }
    }
}

// MARK: - Value Types

/// Supported value types for feature flags.
/// LaunchDarkly supports more types; extend this as needed.
public enum FeatureFlagEvaluation: Sendable, Equatable {
    case bool(Bool)
    case string(String)
    case int(Int)
    case double(Double)
    case json([String: AnySendable])

    /// Convenience accessor. Returns nil if the type does not match.
    public var boolValue: Bool? {
        if case .bool(let value) = self { return value }
        return nil
    }

    public var intValue: Int? {
        if case .int(let value) = self { return value }
        return nil
    }
}

/// Type-erased Sendable wrapper for JSON values coming from LaunchDarkly.
public struct AnySendable: @unchecked Sendable, Equatable {
    public let value: Any

    public init(_ value: Any) {
        self.value = value
    }

    public static func == (lhs: AnySendable, rhs: AnySendable) -> Bool {
        // Best-effort comparison. For production you may want more sophisticated handling.
        String(describing: lhs.value) == String(describing: rhs.value)
    }
}