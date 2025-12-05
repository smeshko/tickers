import SwiftUI

struct SymbolDetailView: View {
    let stock: Stock

    private var stockInfo: StockInfo? {
        StockData.stockInfo(for: stock.symbol)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                priceSection
                Divider()
                aboutSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(stock.symbol)
        .navigationBarTitleDisplayMode(.large)
    }

    private var priceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stockInfo?.name ?? stock.name)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(stock.price, format: .currency(code: "USD"))
                .font(.system(size: 34, weight: .bold))
                .monospacedDigit()

            changeBadge
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var changeBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: directionIcon)
                .font(.subheadline)
                .fontWeight(.semibold)

            Text(stock.priceChange, format: .currency(code: "USD").sign(strategy: .always()))
                .monospacedDigit()

            Text("(\(stock.priceChangePercent, format: .percent.sign(strategy: .always()).precision(.fractionLength(2))))")
                .monospacedDigit()
        }
        .font(.subheadline)
        .fontWeight(.medium)
        .foregroundStyle(priceColor)
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

    private var directionIcon: String {
        switch stock.priceDirection {
        case .up: "arrow.up"
        case .down: "arrow.down"
        case .unchanged: "minus"
        }
    }

    private var priceColor: Color {
        switch stock.priceDirection {
        case .up: .green
        case .down: .red
        case .unchanged: .secondary
        }
    }
}

#Preview {
    NavigationStack {
        SymbolDetailView(
            stock: Stock(symbol: "AAPL", name: "Apple Inc.", price: 178.50, previousPrice: 175.00)
        )
    }
}
