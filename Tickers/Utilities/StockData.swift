import Foundation

enum StockData {
    static let stocks: [StockInfoDTO] = [
        StockInfoDTO(
            symbol: "AAPL",
            name: "Apple Inc.",
            description: "Apple designs, manufactures, and markets smartphones, personal computers, tablets, wearables, and accessories. The company also offers digital content and services.",
            basePrice: 175.0
        ),
        StockInfoDTO(
            symbol: "MSFT",
            name: "Microsoft Corporation",
            description: "Microsoft develops and supports software, services, devices, and solutions. The company's products include operating systems, cloud services, and productivity applications.",
            basePrice: 375.0
        ),
        StockInfoDTO(
            symbol: "GOOGL",
            name: "Alphabet Inc.",
            description: "Alphabet is a holding company that owns Google and other businesses. Google's core products include Search, YouTube, Android, Chrome, and Google Cloud.",
            basePrice: 140.0
        ),
        StockInfoDTO(
            symbol: "AMZN",
            name: "Amazon.com Inc.",
            description: "Amazon is an e-commerce and cloud computing company. The company operates through online stores, physical stores, third-party seller services, and AWS.",
            basePrice: 180.0
        ),
        StockInfoDTO(
            symbol: "NVDA",
            name: "NVIDIA Corporation",
            description: "NVIDIA designs and manufactures graphics processors and related software. The company is a leader in AI computing, gaming graphics, and data center solutions.",
            basePrice: 450.0
        ),
        StockInfoDTO(
            symbol: "META",
            name: "Meta Platforms Inc.",
            description: "Meta builds technologies that help people connect. The company's products include Facebook, Instagram, WhatsApp, and virtual reality hardware and software.",
            basePrice: 350.0
        ),
        StockInfoDTO(
            symbol: "TSLA",
            name: "Tesla Inc.",
            description: "Tesla designs, manufactures, and sells electric vehicles and energy storage systems. The company also offers solar energy generation and storage products.",
            basePrice: 250.0
        ),
        StockInfoDTO(
            symbol: "BRK.B",
            name: "Berkshire Hathaway",
            description: "Berkshire Hathaway is a holding company owning subsidiaries in insurance, utilities, rail transportation, manufacturing, and retail businesses.",
            basePrice: 360.0
        ),
        StockInfoDTO(
            symbol: "JPM",
            name: "JPMorgan Chase",
            description: "JPMorgan Chase is a global financial services firm offering investment banking, financial services, asset management, and commercial banking.",
            basePrice: 195.0
        ),
        StockInfoDTO(
            symbol: "V",
            name: "Visa Inc.",
            description: "Visa operates a global payments technology network enabling electronic funds transfers through credit, debit, and prepaid cards.",
            basePrice: 275.0
        ),
        StockInfoDTO(
            symbol: "UNH",
            name: "UnitedHealth Group",
            description: "UnitedHealth Group provides health care products and insurance services. The company operates through UnitedHealthcare and Optum segments.",
            basePrice: 525.0
        ),
        StockInfoDTO(
            symbol: "JNJ",
            name: "Johnson & Johnson",
            description: "Johnson & Johnson researches, develops, manufactures, and sells health care products in pharmaceuticals, medical devices, and consumer health.",
            basePrice: 155.0
        ),
        StockInfoDTO(
            symbol: "WMT",
            name: "Walmart Inc.",
            description: "Walmart operates retail stores and e-commerce businesses worldwide. The company offers a wide variety of merchandise and services at everyday low prices.",
            basePrice: 165.0
        ),
        StockInfoDTO(
            symbol: "PG",
            name: "Procter & Gamble",
            description: "Procter & Gamble manufactures and markets consumer goods including beauty, grooming, health care, fabric care, and home care products.",
            basePrice: 160.0
        ),
        StockInfoDTO(
            symbol: "MA",
            name: "Mastercard Inc.",
            description: "Mastercard is a technology company in the global payments industry connecting consumers, financial institutions, merchants, and governments.",
            basePrice: 450.0
        ),
        StockInfoDTO(
            symbol: "HD",
            name: "Home Depot",
            description: "Home Depot is a home improvement retailer selling building materials, home improvement products, lawn and garden products, and décor items.",
            basePrice: 345.0
        ),
        StockInfoDTO(
            symbol: "CVX",
            name: "Chevron Corporation",
            description: "Chevron is an integrated energy company engaged in the exploration, production, and transportation of crude oil and natural gas.",
            basePrice: 155.0
        ),
        StockInfoDTO(
            symbol: "MRK",
            name: "Merck & Co.",
            description: "Merck is a global healthcare company delivering innovative health solutions through prescription medicines, vaccines, and animal health products.",
            basePrice: 125.0
        ),
        StockInfoDTO(
            symbol: "KO",
            name: "Coca-Cola Company",
            description: "Coca-Cola manufactures, markets, and sells nonalcoholic beverages including sparkling soft drinks, water, juice, and ready-to-drink coffee and tea.",
            basePrice: 60.0
        ),
        StockInfoDTO(
            symbol: "PEP",
            name: "PepsiCo Inc.",
            description: "PepsiCo manufactures, markets, and sells beverages and convenient foods including chips, branded dips, and other snacks globally.",
            basePrice: 175.0
        ),
        StockInfoDTO(
            symbol: "ABBV",
            name: "AbbVie Inc.",
            description: "AbbVie is a research-based biopharmaceutical company developing and commercializing therapies for immunology, oncology, and neuroscience.",
            basePrice: 170.0
        ),
        StockInfoDTO(
            symbol: "COST",
            name: "Costco Wholesale",
            description: "Costco operates membership warehouses offering a selection of branded and private-label products at substantially lower prices than conventional retailers.",
            basePrice: 575.0
        ),
        StockInfoDTO(
            symbol: "CRM",
            name: "Salesforce Inc.",
            description: "Salesforce provides enterprise cloud computing solutions including customer relationship management, analytics, and application development.",
            basePrice: 265.0
        ),
        StockInfoDTO(
            symbol: "NFLX",
            name: "Netflix Inc.",
            description: "Netflix is a streaming entertainment service offering a wide variety of TV series, documentaries, feature films, and games across various genres.",
            basePrice: 475.0
        ),
        StockInfoDTO(
            symbol: "DIS",
            name: "Walt Disney Company",
            description: "Disney is a diversified entertainment company operating theme parks, media networks, studio entertainment, and direct-to-consumer streaming services.",
            basePrice: 95.0
        )
    ]

    static func createInitialStocks() -> [StockDTO] {
        stocks.map { info in
            StockDTO(
                symbol: info.symbol,
                name: info.name,
                price: info.basePrice,
                previousPrice: info.basePrice - Double.random(in: 0...10)
            )
        }
    }

    static func stockInfo(for symbol: String) -> StockInfoDTO? {
        stocks.first { $0.symbol == symbol }
    }
}
