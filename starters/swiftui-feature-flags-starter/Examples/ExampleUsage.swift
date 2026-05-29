import SwiftUI

// MARK: - Example: Root App Setup

/*
@main
struct MyApp: App {
    private let featureFlagService: FeatureFlagService

    init() {
        // 1. Create the real service
        let ldConfig = LaunchDarklyConfiguration(
            mobileKey: "your-mobile-key-here",
            environment: .production
        )
        let ldService = LaunchDarklyFeatureFlagService(configuration: ldConfig)

        // 2. Start LaunchDarkly early
        ldService.configure()

        // 3. (Optional) Wrap with overrides for debug builds
        #if DEBUG
        let overrides = FeatureFlagOverrides()
        self.featureFlagService = FeatureFlagServiceWithOverrides(base: ldService, overrides: overrides)

        // Expose overrides somewhere for your debug menu
        DebugMenu.shared.featureFlagOverrides = overrides
        #else
        self.featureFlagService = ldService
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.featureFlagService, featureFlagService)
        }
    }
}
*/

// MARK: - Example: Using Flags in a View

struct ProductDetailView: View {
    @FeatureFlag(.aiProductRecommendations) private var showAiRecommendations
    @FeatureFlagValue(.maxCartItemsBeforeUpsell) private var maxCartItems

    var body: some View {
        VStack {
            Text("Product Details")

            featureFlag(.newCheckoutFlow) {
                NewCheckoutButton()
            } else: {
                ClassicCheckoutButton()
            }

            if showAiRecommendations {
                AIRecommendationsSection()
            }
        }
    }
}

// MARK: - Example: SwiftUI Preview with Overrides

#Preview("With AI Recommendations Enabled") {
    let overrides = FeatureFlagOverrides()
    overrides.set(.aiProductRecommendations, to: .bool(true))

    let previewService = FeatureFlagServiceWithOverrides(
        base: InMemoryFeatureFlagService(),
        overrides: overrides
    )

    return ProductDetailView()
        .featureFlagService(previewService)
}

// MARK: - Example: Checking Flags Outside Views

final class CheckoutCoordinator {
    private let featureFlagService: FeatureFlagService

    init(featureFlagService: FeatureFlagService) {
        self.featureFlagService = featureFlagService
    }

    func startCheckout() {
        if featureFlagService.isEnabled(.newCheckoutFlow) {
            // Use new flow
        } else {
            // Use legacy flow
        }
    }
}