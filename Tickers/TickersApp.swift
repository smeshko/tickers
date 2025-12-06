import SwiftUI

@main
struct TickersApp: App {
    @StateObject private var viewModel: PriceFeedViewModel

    init() {
        // TODO: Add proper dependency injection
        let webSocketService = WebSocketService()
        let repository = PriceFeedRepository(webSocketService: webSocketService)
        _viewModel = StateObject(wrappedValue: PriceFeedViewModel(repository: repository))
    }

    var body: some Scene {
        WindowGroup {
            FeedView()
                .environmentObject(viewModel)
        }
    }
}
