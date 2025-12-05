import SwiftUI

struct FeedView: View {
    @State private var isConnected = false
    @State private var isStreaming = false
    @State private var stocks: [Stock] = StockData.createInitialStocks()
    
    private var sortedStocks: [Stock] {
        stocks.sorted { $0.price > $1.price }
    }
    
    var body: some View {
        NavigationStack {
            List(sortedStocks) { stock in
                StockRowView(stock: stock)
                    .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .navigationTitle("Stocks")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    connectionStatusView
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem(placement: .topBarTrailing) {
                    streamToggleButton
                }
            }
        }
    }
    
    private var connectionStatusView: some View {
        Circle()
            .fill(isConnected ? .green : .red.opacity(0.8))
            .frame(width: 8, height: 8)
    }
    
    private var streamToggleButton: some View {
        Button {
            isStreaming.toggle()
            isConnected = isStreaming
        } label: {
            Text(isStreaming ? "Stop" : "Start")
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    FeedView()
}
