import Foundation
import LaunchDarkly

/// Lightweight namespace for LaunchDarkly client access and common operations.
///
/// Many teams prefer going through a thin wrapper like this instead of
/// touching `LDClient` directly from feature code.
public enum LaunchDarklyClient {
    /// Returns the current LaunchDarkly client if it has been started.
    public static var current: LDClient? {
        LDClient.get()
    }

    /// Whether the client has finished initializing.
    public static var isInitialized: Bool {
        current?.isInitialized ?? false
    }

    /// Force identify with a new context (e.g. after user logs in or out).
    public static func identify(userId: String?, email: String? = nil, isPremium: Bool = false) {
        let context = LaunchDarklyContextBuilder.buildContext(
            userId: userId,
            email: email,
            isPremium: isPremium
        )
        LDClient.get()?.identify(context: context)
    }

    /// Track a custom event (useful for connecting feature flags to metrics).
    public static func trackEvent(key: String, data: [String: Any]? = nil) {
        LDClient.get()?.track(key: key, data: data)
    }
}