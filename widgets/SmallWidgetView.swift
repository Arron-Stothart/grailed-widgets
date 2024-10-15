//
//  SmallWidgetView.swift
//  widgetsExtension
//
//  Created by Arron Stothart on 14/10/2024.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    var entry: GrailedListingsEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        if let listing = entry.listings.first {
            GeometryReader { geometry in
                VStack(alignment: .leading, spacing: 8) {
                    Text("Price Drop")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.black)
                    HStack(spacing: 8) {
                        AsyncImage(url: URL(string: listing.imageURL)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: geometry.size.width * 0.5, height: geometry.size.height - 30)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("6hrs ago")
                                .font(.caption2)
                            Text(listing.name)
                                .font(.subheadline.bold())
                                .lineLimit(2)
                            Text(listing.currentPrice)
                                .font(.custom("Video", size: 12))
                                .foregroundColor(Color(red: 0.75, green: 0.16, blue: 0.15))
                            Text(listing.originalPrice)
                                .font(.custom("Video", size: 12))
                                .strikethrough()
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
            .widgetURL(URL(string: "grailedapp://listing/\(listing.id)"))
            .containerBackground(for: .widget) {
                Color(UIColor.systemBackground)
            }
        } else {
            Text("No data available")
        }
    }
}
