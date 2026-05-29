import SwiftUI

// MARK: - Environment Key

@MainActor
struct FeatureFlagServiceKey: EnvironmentKey {
    static let defaultValue: FeatureFlagService = InMemoryFeatureFlagService()
}

public extension EnvironmentValues {
    /// The current feature flag service available to the view hierarchy.
    ///
    /// Inject a real implementation (usually wrapping LaunchDarkly) at the root of your app:
    ///
    /// ```swift
    /// @main
    /// struct YourApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .environment(\.featureFlagService, launchDarklyService)
    ///         }
    ///     }
    /// }
    /// ```
    var featureFlagService: FeatureFlagService {
        get { self[FeatureFlagServiceKey.self] }
        set { self[FeatureFlagServiceKey.self] = newValue }
    }
}

// MARK: - Convenient View Modifiers and Property Wrappers

public extension View {
    /// Injects a FeatureFlagService into the environment.
    func featureFlagService(_ service: FeatureFlagService) -> some View {
        environment(\.featureFlagService, service)
    }
}

/// Property wrapper that gives a view read-only access to a boolean flag.
///
/// Example:
/// ```swift
/// struct ProductDetailView: View {
///     @FeatureFlag(.aiProductRecommendations) private var showRecommendations
///
///     var body: some View {
///         if showRecommendations {
///             RecommendationsSection()
///         }
///     }
/// }
/// ```
@propertyWrapper
public struct FeatureFlag: DynamicProperty {
    @Environment(\.featureFlagService) private var service
    private let flag: FeatureFlag

    public init(_ flag: FeatureFlag) {
        self.flag = flag
    }

    public var wrappedValue: Bool {
        service.isEnabled(flag)
    }
}

/// Property wrapper for non-boolean flag values.
///
/// Usage:
/// ```swift
/// @FeatureFlagValue(.maxCartItemsBeforeUpsell) private var threshold
/// ```
@propertyWrapper
public struct FeatureFlagValue: DynamicProperty {
    @Environment(\.featureFlagService) private var service
    private let flag: FeatureFlag

    public init(_ flag: FeatureFlag) {
        self.flag = flag
    }

    public var wrappedValue: FeatureFlagEvaluation {
        service.value(for: flag)
    }
}

// MARK: - View Modifier for Conditional Rendering

public extension View {
    /// Conditionally renders content based on a feature flag.
    ///
    /// This is preferred over wrapping large view bodies in `if` statements
    /// when the flag controls major UI branches.
    @ViewBuilder
    func featureFlag(_ flag: FeatureFlag, then: () -> some View) -> some View {
        @FeatureFlag(flag) var isEnabled
        if isEnabled {
            then()
        }
    }

    @ViewBuilder
    func featureFlag(_ flag: FeatureFlag, then: () -> some View, else: () -> some View) -> some View {
        @FeatureFlag(flag) var isEnabled
        if isEnabled {
            then()
        } else {
            `else`()
        }
    }
}