import SwiftUI

struct StockRowView: View {
    let stock: Stock
    @State private var isFlashing = false

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(stock.symbol)
                    .font(.body)
                    .fontWeight(.semibold)
                Text(stock.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            VStack(alignment: .trailing, spacing: 4) {
                Text(stock.price, format: .currency(code: "USD"))
                    .font(.body)
                    .fontWeight(.medium)
                    .monospacedDigit()
                    .foregroundStyle(isFlashing ? stock.priceDirection.color : .primary)

                changeBadge
            }
        }
        .padding(.vertical, 8)
        .onChange(of: stock.price) {
            triggerFlash()
        }
    }

    private func triggerFlash() {
        withAnimation(.easeIn(duration: 0.1)) {
            isFlashing = true
        }

        Task {
            try? await Task.sleep(for: .seconds(1))
            withAnimation(.easeOut(duration: 0.3)) {
                isFlashing = false
            }
        }
    }

    private var changeBadge: some View {
        HStack(spacing: 3) {
            Image(systemName: stock.priceDirection.iconName)
                .font(.caption2)
                .fontWeight(.bold)
            Text(stock.priceChangePercent, format: .percent.sign(strategy: .always()).precision(.fractionLength(2)))
                .font(.caption)
                .fontWeight(.medium)
                .monospacedDigit()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(stock.priceDirection.color.opacity(0.15))
        .foregroundStyle(stock.priceDirection.color)
        .clipShape(Capsule())
    }
}

#Preview {
    List {
        StockRowView(stock: Stock(symbol: "AAPL", name: "Apple Inc.", price: 178.50, previousPrice: 175.00))
        StockRowView(stock: Stock(symbol: "NVDA", name: "NVIDIA Corporation", price: 445.00, previousPrice: 450.00))
        StockRowView(stock: Stock(symbol: "MSFT", name: "Microsoft Corporation", price: 375.00))
        StockRowView(stock: Stock(symbol: "COST", name: "Costco Wholesale", price: 580.25, previousPrice: 575.00))
    }
}
