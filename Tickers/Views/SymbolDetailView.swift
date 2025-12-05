import SwiftUI

struct SymbolDetailView: View {
    @EnvironmentObject var viewModel: PriceFeedViewModel
    let symbol: String

    private var stock: Stock? {
        viewModel.stock(for: symbol)
    }

    private var stockInfo: StockInfo? {
        StockData.stockInfo(for: symbol)
    }

    var body: some View {
        Group {
            if let stock {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        priceSection(for: stock)
                        Divider()
                        aboutSection
                    }
                    .padding()
                }
                .background(Color(.systemGroupedBackground))
            } else {
                ContentUnavailableView("Stock Not Found", systemImage: "chart.line.downtrend.xyaxis")
            }
        }
        .navigationTitle(symbol)
        .navigationBarTitleDisplayMode(.large)
    }

    private func priceSection(for stock: Stock) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stockInfo?.name ?? stock.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(stock.price, format: .currency(code: "USD"))
                .font(.system(size: 34, weight: .bold))
                .monospacedDigit()
                .contentTransition(.numericText())

            changeBadge(for: stock)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .animation(.smooth, value: stock.price)
    }

    private func changeBadge(for stock: Stock) -> some View {
        HStack(spacing: 4) {
            Image(systemName: directionIcon(for: stock))
                .font(.subheadline)
                .fontWeight(.semibold)
                .contentTransition(.symbolEffect(.replace))

            Text(stock.priceChange, format: .currency(code: "USD").sign(strategy: .always()))
                .monospacedDigit()
                .contentTransition(.numericText())

            Text("(\(stock.priceChangePercent, format: .percent.sign(strategy: .always()).precision(.fractionLength(2))))")
                .monospacedDigit()
                .contentTransition(.numericText())
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundStyle(priceColor(for: stock))
        .animation(.smooth, value: stock.price)
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("About")
                .font(.headline)

            Text(stockInfo?.description ?? "No description available.")
                .font(.body)
                .foregroundStyle(.secondary)
                .lineSpacing(4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private func directionIcon(for stock: Stock) -> String {
        switch stock.priceDirection {
        case .up: "arrow.up"
        case .down: "arrow.down"
        case .unchanged: "minus"
        }
    }

    private func priceColor(for stock: Stock) -> Color {
        switch stock.priceDirection {
        case .up: .green
        case .down: .red
        case .unchanged: .secondary
        }
    }
}

#Preview {
    NavigationStack {
        SymbolDetailView(symbol: "AAPL")
            .environmentObject(PriceFeedViewModel())
    }
}
