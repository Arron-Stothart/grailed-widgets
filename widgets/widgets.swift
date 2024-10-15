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
            listings: [GrailedListing(id: "placeholder", imageURL: "", name: "", designers: [], currentPrice: "", originalPrice: "")]
        )
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GrailedListingsEntry {
        GrailedListingsEntry(
            date: Date(),
            configuration: configuration,
            listings: [GrailedListing(id: "snapshot", imageURL: "", name: "", designers: [], currentPrice: "", originalPrice: "")]
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
                listings: [GrailedListing(id: "error", imageURL: "", name: "Error", designers: [], currentPrice: "", originalPrice: "")]
            )
            return Timeline(entries: [errorEntry], policy: .atEnd)
        }
    }
    
    private func getURLsForWidget(_ context: Context) -> [URL] {
        switch context.family {
        case .systemLarge:
            // Sample URLs for large widget TODO: Get dynamically per-user
            return [
                URL(string: "https://www.grailed.com/listings/68911170-rare-reptilian-wallet")!,
                URL(string: "https://www.grailed.com/listings/68677903-hysteric-glamour-x-japanese-brand-x-vintage")!,
                URL(string: "https://www.grailed.com/listings/another-example-url")!
            ]
        default:
            // Sample URLs for large widget TODO: Get dynamically per-user
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
                .containerBackground(.fill.tertiary, for: .widget)
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
            GrailedListing(id: UUID().uuidString, imageURL: "https://example.com/image1.jpg", name: "Large Widget Item 1", designers: ["Designer", "Designer"], currentPrice: "$100", originalPrice: "$150"),
            GrailedListing(id: UUID().uuidString, imageURL: "https://example.com/image2.jpg", name: "Large Widget Item 2", designers: ["Designer", "Designer"], currentPrice: "$200", originalPrice: "$250"),
            GrailedListing(id: UUID().uuidString, imageURL: "https://example.com/image3.jpg", name: "Large Widget Item 3", designers: ["Designer", "Designer"], currentPrice: "$300", originalPrice: "$350")
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
            GrailedListing(id: UUID().uuidString, imageURL: "https://example.com/image.jpg", name: "Small Widget", designers: ["Designer"], currentPrice: "$100", originalPrice: "$150")
        ]
    )
}
