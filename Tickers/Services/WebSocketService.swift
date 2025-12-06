import Foundation
import Combine

protocol WebSocketServiceProtocol {
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
    var messagePublisher: AnyPublisher<String, Never> { get }
    func connect()
    func disconnect()
    func send(_ message: String)
}

final class WebSocketService: WebSocketServiceProtocol {
    private let isConnectedSubject = CurrentValueSubject<Bool, Never>(false)
    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    private var webSocketTask: URLSessionWebSocketTask?
    private let session: URLSession
    private let url: URL

    private let messageSubject = PassthroughSubject<String, Never>()
    var messagePublisher: AnyPublisher<String, Never> {
        messageSubject.eraseToAnyPublisher()
    }

    init(
        session: URLSession = .shared,
        // TODO: Move to configuration
        url: URL = URL(string: "wss://ws.postman-echo.com/raw")!
    ) {
        self.session = session
        self.url = url
    }

    func connect() {
        guard webSocketTask == nil else { return }

        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        isConnectedSubject.send(true)
        receiveMessage()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        isConnectedSubject.send(false)
    }

    func send(_ message: String) {
        guard let webSocketTask, isConnectedSubject.value else { return }

        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask.send(message) { [weak self] error in
            if let error {
                print("WebSocket send error: \(error.localizedDescription)")
                self?.handleDisconnection()
            }
        }
    }

    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    self.messageSubject.send(text)
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        self.messageSubject.send(text)
                    }
                @unknown default:
                    break
                }
                self.receiveMessage()

            case .failure(let error):
                print("WebSocket receive error: \(error.localizedDescription)")
                self.handleDisconnection()
            }
        }
    }

    private func handleDisconnection() {
        webSocketTask = nil
        isConnectedSubject.send(false)
    }
}
