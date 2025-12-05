import SwiftUI

@main
struct TickersApp: App {
    @StateObject private var viewModel = PriceFeedViewModel()

    var body: some Scene {
        WindowGroup {
            FeedView()
                .environmentObject(viewModel)
        }
    }
}
