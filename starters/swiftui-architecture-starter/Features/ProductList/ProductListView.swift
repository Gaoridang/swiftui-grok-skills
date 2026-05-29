import SwiftUI

struct ProductListView: View {
    @State private var model: ProductListModel

    init(model: ProductListModel) {
        _model = State(initialValue: model)
    }

    var body: some View {
        NavigationStack {
            Group {
                if model.isLoading && model.products.isEmpty {
                    ProgressView("Loading products...")
                } else if let error = model.errorMessage {
                    ErrorView(message: error) {
                        Task { await model.loadProducts() }
                    }
                } else {
                    List(model.products) { product in
                        ProductRow(product: product)
                    }
                    .refreshable {
                        await model.refresh()
                    }
                }
            }
            .navigationTitle("Products")
        }
        .task {
            if model.products.isEmpty {
                await model.loadProducts()
            }
        }
    }
}

// MARK: - Supporting Views (can be moved to DesignSystem later)

private struct ProductRow: View {
    let product: Product

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text(product.price, format: .currency(code: "USD"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

private struct ErrorView: View {
    let message: String
    let retry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
            Text(message)
            Button("Try Again", action: retry)
        }
        .padding()
    }
}

// MARK: - Preview

#Preview {
    let mockService = MockProductListService()
    let model = ProductListModel(service: mockService)

    return ProductListView(model: model)
        .dependencyContainer(DependencyContainer()) // from App/DependencyContainer
}