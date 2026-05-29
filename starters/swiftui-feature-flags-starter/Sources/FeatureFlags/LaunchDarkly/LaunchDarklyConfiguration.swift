import Foundation
import LaunchDarkly

/// Configuration and context building for LaunchDarkly on iOS.
///
/// ## Important Notes for iOS 18+ / Swift 6
/// - LaunchDarkly iOS SDK 9.x has improved Swift concurrency support.
/// - Always build a proper `LDContext` — anonymous contexts are fine for many apps.
/// - Consider privacy: do not send PII in the key unless the user is logged in.
public struct LaunchDarklyConfiguration {
    public let mobileKey: String
    public let environment: LaunchDarklyEnvironment

    public init(mobileKey: String, environment: LaunchDarklyEnvironment = .production) {
        self.mobileKey = mobileKey
        self.environment = environment
    }
}

public enum LaunchDarklyEnvironment: String, Sendable {
    case production
    case staging
    case development
}

/// Builds the LaunchDarkly context for the current user/device.
///
/// Customize this heavily for your app. Good context attributes dramatically
/// improve targeting capabilities in the LaunchDarkly dashboard.
@MainActor
public struct LaunchDarklyContextBuilder {
    public static func buildContext(
        userId: String? = nil,
        email: String? = nil,
        isPremium: Bool = false,
        appVersion: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    ) -> LDContext {
        var builder: LDContextBuilder

        if let userId {
            // Identified user
            builder = LDContextBuilder(key: userId)
            builder.kind("user")
            if let email { builder.trySetValue("email", email) }
            builder.trySetValue("isPremium", isPremium)
        } else {
            // Anonymous user — still very useful for targeting
            builder = LDContextBuilder(key: UUID().uuidString)
            builder.kind("user")
            builder.anonymous(true)
        }

        // Device & app attributes (very valuable)
        builder.trySetValue("platform", "iOS")
        builder.trySetValue("appVersion", appVersion)
        builder.trySetValue("osVersion", UIDevice.current.systemVersion)

        // Add any custom attributes your product needs for targeting

        do {
            return try builder.build().get()
        } catch {
            // Fallback to a minimal anonymous context if building fails
            let fallback = LDContextBuilder(key: UUID().uuidString)
            fallback.kind("user")
            fallback.anonymous(true)
            return try! fallback.build().get()
        }
    }
}