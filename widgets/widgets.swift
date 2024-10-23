//
//  widgets.swift
//  widgets
//
//  Created by Arron Stothart on 14/10/2024.
//

import WidgetKit
import SwiftUI

struct GrailedListingsEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    let listings: [GrailedListing]
}

struct GrailedListing: Identifiable {
    let id: String
    let imageURL: String
    let imageData: Data? // Add this line
    let name: String
    let designers: [String]
    let currentPrice: String
    let originalPrice: String
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GrailedListingsEntry {
        GrailedListingsEntry(
            date: Date(),
            configuration: ConfigurationAppIntent(),
            listings: [GrailedListing(id: "placeholder", imageURL: "", imageData: nil, name: "", designers: [], currentPrice: "", originalPrice: "")]
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GrailedListingsEntry {
        GrailedListingsEntry(
            date: Date(),
            configuration: configuration,
            listings: [GrailedListing(id: "snapshot", imageURL: "", imageData: nil, name: "", designers: [], currentPrice: "", originalPrice: "")]
        )
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GrailedListingsEntry> {
        let urls = getURLsForWidget(context)
        
        do {
            var listings: [GrailedListing] = []
            for url in urls {
                let (imageURL, name, designers, currentPrice, originalPrice) = try await WebScraperService.scrapeProductInfo(from: url)
                let listing = GrailedListing(
                    id: UUID().uuidString,
                    imageURL: imageURL, 
                    imageData: try? Data(contentsOf: URL(string: imageURL)!),
                    name: name, 
                    designers: designers, 
                    currentPrice: currentPrice, 
                    originalPrice: originalPrice
                )
                listings.append(listing)
            }
            
            let entry = GrailedListingsEntry(date: Date(), configuration: configuration, listings: listings)
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            print("Error scraping product info: \(error)")
            let errorEntry = GrailedListingsEntry(
                date: Date(),
                configuration: configuration,
                listings: [GrailedListing(id: "error", imageURL: "", imageData: nil, name: "Error", designers: [], currentPrice: "", originalPrice: "")]
            )
            return Timeline(entries: [errorEntry], policy: .atEnd)
        }
    }
    
    private func getURLsForWidget(_ context: Context) -> [URL] {
        switch context.family {
        case .systemLarge:
            return [
                URL(string: "https://www.grailed.com/listings/68038440-yohji-yamamoto-x-spotted-horse-craft-painted-z-denim-trucker-jacket")!,
                URL(string: "https://www.grailed.com/listings/68911170-rare-reptilian-wallet")!,
                URL(string: "https://www.grailed.com/listings/51600699-gildan-x-streetwear-x-vintage-2018-strath-haven-field-hockey-gildan-premium-cotton-hoodie")!
            ]
        default:
            return [URL(string: "https://www.grailed.com/listings/68911170-rare-reptilian-wallet")!]
        }
    }
}

struct widgetsEntryView : View {
    var entry: GrailedListingsEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemLarge:
            LargeWidgetView(entry: entry)
        default:
            SmallWidgetView(entry: entry)
        }
    }
}

struct widgets: Widget {
    let kind: String = "widgets"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            widgetsEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    Color.white
                }
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .systemLarge) {
    widgets()
} timeline: {
    GrailedListingsEntry(
        date: Date(),
        configuration: .smiley,
        listings: [
            GrailedListing(
                id: UUID().uuidString,
                imageURL: "https://media-assets.grailed.com/prd/listing/temp/9d660ca2c3794b8ab6aed64c50b0ded2?w=1600",
                imageData: try? Data(contentsOf: URL(string: "https://media-assets.grailed.com/prd/listing/temp/9d660ca2c3794b8ab6aed64c50b0ded2?w=1600")!),
                name: "VINTAGE 90s HYSTERIC GLAMOUR TRASH NAKED GIRL",
                designers: ["Hysteric Glamour", "Japanese Brand", "Streetwear"],
                currentPrice: "$287",
                originalPrice: "$350"
            ),
            GrailedListing(
                id: UUID().uuidString,
                imageURL: "https://media-assets.grailed.com/prd/listing/temp/588f3557c935412fb6478750e360801a?w=1600",
                imageData: try? Data(contentsOf: URL(string: "https://media-assets.grailed.com/prd/listing/temp/588f3557c935412fb6478750e360801a?w=1600")!),
                name: "2018 STRATH HAVEN FIELD HOCKEY GILDAN PREMIUM Cotton Hoodie",
                designers: ["Gildan", "Streetwear", "Vintage"],
                currentPrice: "$49",
                originalPrice: "$59"
            ),
            GrailedListing(
                id: UUID().uuidString,
                imageURL: "https://media-assets.grailed.com/prd/listing/temp/b38219768bc24a328c932f892411b5b2?w=1600",
                imageData: try? Data(contentsOf: URL(string: "https://media-assets.grailed.com/prd/listing/temp/b38219768bc24a328c932f892411b5b2?w=1600")!),
                name: "Painted Z Denim Trucker Jacket",
                designers: ["Yohji Yamamoto", "Spotted Horse Craft"],
                currentPrice: "$1,800",
                originalPrice: "$2,000"
            ),
        ]
    )
}

#Preview(as: .systemSmall) {
    widgets()
} timeline: {
    GrailedListingsEntry(
        date: Date(),
        configuration: .smiley,
        listings: [
            GrailedListing(
                id: UUID().uuidString,
                imageURL: "https://media-assets.grailed.com/prd/listing/temp/9d660ca2c3794b8ab6aed64c50b0ded2?w=1600",
                imageData: try? Data(contentsOf: URL(string: "https://media-assets.grailed.com/prd/listing/temp/9d660ca2c3794b8ab6aed64c50b0ded2?w=1600")!),
                name: "VINTAGE 90s HYSTERIC GLAMOUR TRASH NAKED GIRL",
                designers: ["Hysteric Glamour", "Japanese Brand", "Streetwear"],
                currentPrice: "$287",
                originalPrice: "$350"
            )
        ]
    )
}
