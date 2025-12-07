# Tickers

A real-time stock price tracker built with SwiftUI that displays live price updates for 25 stock symbols using WebSocket communication.

## Features

- Real-time price updates via WebSocket (`wss://ws.postman-echo.com/raw`)
- Feed screen with sorted stock list (highest price first) and price change indicators
- Symbol detail screen with company description
- Connection status indicator and start/stop streaming toggle
- Price flash animations on updates
- Light and dark theme support

## Architecture

MVVM with Combine for reactive data flow. Protocol-based services enable dependency injection and testability.

```
WebSocketService → PriceFeedRepository → PriceFeedViewModel → Views
```

- **WebSocketService**: Manages the WebSocket connection and exposes message/connection publishers
- **PriceFeedRepository**: Generates price updates, sends them through WebSocket, decodes echoed responses, and emits domain models
- **PriceFeedViewModel**: Holds UI state, subscribes to repository publishers, and applies updates to the stock list
- **Views**: Observe the view model via `@EnvironmentObject`, ensuring both screens share the same data stream

## Testing

26 unit tests covering models, price generation logic, and view model state management.

```bash
xcodebuild test -scheme Tickers -destination 'platform=iOS Simulator,name=iPhone 16'
```
