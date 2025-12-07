import SwiftUI

struct FeedView: View {
    @State var viewModel: PriceFeedViewModel

    var body: some View {
        NavigationStack {
            List(viewModel.sortedStocks) { stock in
                NavigationLink(value: stock.symbol) {
                    StockRowView(stock: stock)
                }
                .listRowSeparator(.hidden)
            }
            .animation(.smooth, value: viewModel.sortedStocks.map(\.id))
            .navigationDestination(for: String.self) { symbol in
                SymbolDetailView(viewModel: viewModel, symbol: symbol)
            }
            .listStyle(.plain)
            .navigationTitle("Tickers")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    connectionStatusView
                }
                .sharedBackgroundVisibility(.hidden)
                
                ToolbarItem(placement: .topBarTrailing) {
                    streamToggleButton
                }
                .sharedBackgroundVisibility(.hidden)
            }
        }
    }

    private var connectionStatusView: some View {
        Circle()
            .fill(viewModel.isConnected ? .green : .red.opacity(0.8))
            .frame(width: 8, height: 8)
            .scaleEffect(viewModel.isConnected ? 1.0 : 1.2)
            .animation(
                viewModel.isConnected
                    ? .easeInOut(duration: 0.3)
                    : .easeInOut(duration: 0.6).repeatForever(autoreverses: true),
                value: viewModel.isConnected
            )
    }

    private var streamToggleButton: some View {
        Button {
            viewModel.toggleStreaming()
        } label: {
            Text(viewModel.isStreaming ? "Stop" : "Start")
                .font(.subheadline)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(viewModel.isStreaming ? Color.red.opacity(0.15) : Color.accentColor.opacity(0.15))
                .foregroundStyle(viewModel.isStreaming ? .red : .accentColor)
                .clipShape(Capsule())
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.isStreaming)
    }
}

#Preview {
    FeedView(viewModel: PriceFeedViewModel.preview)
}
