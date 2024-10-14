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
        do {
            let url = URL(string: "https://www.grailed.com/listings/68911170-rare-reptilian-wallet?g_aidx=Listing_by_heat_production&g_aqid=9299d9cc58c884ff49b2c6cee2445a24")!
            let (imageURL, name, designers, currentPrice, originalPrice) = try await WebScraperService.scrapeProductInfo(from: url)
            
            let entry = GrailedListing(configuration: configuration, 
                                    imageURL: imageURL, 
                                    name: name, 
                                    designers: designers, 
                                    currentPrice: currentPrice, 
                                    originalPrice: originalPrice)
            
            return Timeline(entries: [entry], policy: .atEnd)
        } catch {
            print("Error scraping product info: \(error)")
            return Timeline(entries: [GrailedListing(configuration: configuration, imageURL: "", name: "", designers: [], currentPrice: "", originalPrice: "")], policy: .atEnd)
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

    var body: some View {
        VStack {
            Text(entry.name)
            Text(entry.designers.joined(separator: " × "))
            Text(entry.currentPrice)
            Text(entry.originalPrice)
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
    await scrapedEntry(url: "https://www.grailed.com/listings/68911170-rare-reptilian-wallet?g_aidx=Listing_by_heat_production&g_aqid=9299d9cc58c884ff49b2c6cee2445a24")
    await scrapedEntry(url: "https://www.grailed.com/listings/68677903-hysteric-glamour-x-japanese-brand-x-vintage-vintage-90-s-hysteric-glamour-trash-naked-girl")
}

func scrapedEntry(url: String) async -> GrailedListing {
    do {
        let (imageURL, name, designers, currentPrice, originalPrice) = try await WebScraperService.scrapeProductInfo(from: URL(string: url)!)
        return GrailedListing(configuration: .smiley, imageURL: imageURL, name: name, designers: designers, currentPrice: currentPrice, originalPrice: originalPrice)
    } catch {
        print("Error scraping product info: \(error)")
        return GrailedListing(configuration: .smiley, imageURL: "", name: "Error", designers: [], currentPrice: "", originalPrice: "")
    }
}
