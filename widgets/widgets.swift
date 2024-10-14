//
//  widgets.swift
//  widgets
//
//  Created by Arron Stothart on 14/10/2024.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> GrailedListing {
        GrailedListing(configuration: ConfigurationAppIntent(), imageURL: "", name: "", designers: [], currentPrice: "", originalPrice: "")
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> GrailedListing {
        GrailedListing(configuration: configuration, imageURL: "", name: "", designers: [], currentPrice: "", originalPrice: "")
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<GrailedListing> {
        let urls = getURLsForWidget(context)
        
        do {
            var entries: [GrailedListing] = []
            for url in urls {
                let (imageURL, name, designers, currentPrice, originalPrice) = try await WebScraperService.scrapeProductInfo(from: url)
                let entry = GrailedListing(configuration: configuration, 
                                           imageURL: imageURL, 
                                           name: name, 
                                           designers: designers, 
                                           currentPrice: currentPrice, 
                                           originalPrice: originalPrice)
                entries.append(entry)
            }
            
            return Timeline(entries: entries, policy: .atEnd)
        } catch {
            print("Error scraping product info: \(error)")
            return Timeline(entries: [GrailedListing(configuration: configuration, imageURL: "", name: "Error", designers: [], currentPrice: "", originalPrice: "")], policy: .atEnd)
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

struct GrailedListing: TimelineEntry {
    let date: Date = Date()
    let configuration: ConfigurationAppIntent
    let imageURL: String
    let name: String
    let designers: [String]
    let currentPrice: String
    let originalPrice: String
}

struct widgetsEntryView : View {
    var entry: Provider.Entry
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

struct SmallWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text(entry.name)
            Text(entry.designers.joined(separator: " × "))
            Text(entry.currentPrice)
            Text(entry.originalPrice)
        }
    }
}

struct LargeWidgetView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            // TODO: Implement
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

#Preview(as: .systemSmall) {
    widgets()
} timeline: {
    GrailedListing(configuration: .smiley, imageURL: "", name: "Small Widget", designers: ["Designer"], currentPrice: "$100", originalPrice: "$150")
}
