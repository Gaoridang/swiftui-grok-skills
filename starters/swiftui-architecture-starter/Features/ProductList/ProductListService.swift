import Foundation

// MARK: - Protocol (This is what the feature depends on)

/// Service responsible for fetching products.
/// Defined by the feature itself → high cohesion and easy to mock.
protocol ProductListService: Sendable {
    func fetchProducts() async throws -> [Product]
}

// MARK: - Domain Model (can live here or move to Core/Models if shared)

struct Product: Identifiable, Sendable, Equatable {
    let id: String
    let name: String
    let price: Decimal
    let imageURL: URL?
}

// MARK: - Real Implementation Example

final class RealProductListService: ProductListService {
    // In real life this would use your networking layer
    func fetchProducts() async throws -> [Product] {
        // Call API here...
        return []
    }
}

// MARK: - Mock Implementation (great for previews and tests)

final class MockProductListService: ProductListService {
    var productsToReturn: [Product] = [
        .init(id: "1", name: "Wireless Headphones", price: 89.99, imageURL: nil),
        .init(id: "2", name: "USB-C Cable", price: 12.50, imageURL: nil),
    ]

    func fetchProducts() async throws -> [Product] {
        // Simulate network delay
        try await Task.sleep(for: .milliseconds(400))
        return productsToReturn
    }
}