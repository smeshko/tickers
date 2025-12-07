import SwiftUI

@main
struct TickersApp: App {
    @State private var viewModel: PriceFeedViewModel

    init() {
        // TODO: Add proper dependency injection
        let webSocketService = WebSocketService()
        let repository = PriceFeedRepository(webSocketService: webSocketService)
        _viewModel = State(wrappedValue: PriceFeedViewModel(repository: repository))
    }

    var body: some Scene {
        WindowGroup {
            FeedView(viewModel: viewModel)
        }
    }
}
