import Foundation
import SwiftUI

/// The composition root for the application.
///
/// This is the single place where we wire up all dependencies.
/// Features should receive their dependencies through initialization, never through singletons.

@MainActor
final class DependencyContainer {
    // MARK: - Shared Services (example)

    // lazy var analytics: AnalyticsService = PostHogAnalyticsService()
    // lazy var featureFlags: FeatureFlagService = ... (injected from setup-swiftui-feature-flags)

    // MARK: - Feature Factories

    /// Example: Creates a fully wired ProductListModel for the ProductList feature.
    func makeProductListModel() -> ProductListModel {
        // In a real app you would inject real services here
        let service = MockProductListService()   // or RealProductListService(...)
        return ProductListModel(service: service)
    }

    // Add more factory methods for other features below
}

// MARK: - Environment Injection (Recommended pattern)

private struct DependencyContainerKey: EnvironmentKey {
    static let defaultValue = DependencyContainer()
}

extension EnvironmentValues {
    var container: DependencyContainer {
        get { self[DependencyContainerKey.self] }
        set { self[DependencyContainerKey.self] = newValue }
    }
}

extension View {
    func dependencyContainer(_ container: DependencyContainer) -> some View {
        environment(\ .container, container)
    }
}