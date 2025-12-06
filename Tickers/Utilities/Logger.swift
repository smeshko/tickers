import OSLog

enum Log {
    static let websocket = Logger(subsystem: "Tickers", category: "websocket")
    static let repository = Logger(subsystem: "Tickers", category: "repository")
    static let viewModel = Logger(subsystem: "Tickers", category: "viewmodel")
}
