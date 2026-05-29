import SwiftUI

struct RootView: View {
    @Environment(\ .container) private var container

    var body: some View {
        // This is where you would put your main navigation (TabView, NavigationSplitView, etc.)
        ProductListView(model: container.makeProductListModel())
    }
}