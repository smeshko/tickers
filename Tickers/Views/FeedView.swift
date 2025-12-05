import SwiftUI

struct FeedView: View {
    @EnvironmentObject var viewModel: PriceFeedViewModel

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
                SymbolDetailView(symbol: symbol)
            }
            .listStyle(.plain)
            .navigationTitle("Stocks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    connectionStatusView
                }
                ToolbarItem(placement: .topBarTrailing) {
                    streamToggleButton
                }
            }
        }
    }

    private var connectionStatusView: some View {
        Circle()
            .fill(viewModel.isConnected ? .green : .red.opacity(0.8))
            .frame(width: 8, height: 8)
            .animation(.easeInOut(duration: 0.3), value: viewModel.isConnected)
    }

    private var streamToggleButton: some View {
        Button {
            viewModel.toggleStreaming()
        } label: {
            Text(viewModel.isStreaming ? "Stop" : "Start")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    FeedView()
        .environmentObject(PriceFeedViewModel())
}
