import Foundation
import Observation

/// The observable state holder for the ProductList feature.
///
/// This replaces the traditional "ViewModel" concept.
/// It owns the state and business logic for this specific screen/feature.
@Observable
@MainActor
final class ProductListModel {
    // MARK: - State

    private(set) var products: [Product] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    // MARK: - Dependencies

    private let service: ProductListService

    // MARK: - Init

    init(service: ProductListService) {
        self.service = service
    }

    // MARK: - Actions

    func loadProducts() async {
        isLoading = true
        errorMessage = nil

        do {
            products = try await service.fetchProducts()
        } catch {
            errorMessage = "Failed to load products. Please try again."
            print("Error loading products: \(error)")
        }

        isLoading = false
    }

    func refresh() async {
        await loadProducts()
    }
}