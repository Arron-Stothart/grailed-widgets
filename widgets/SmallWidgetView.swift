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
                VStack(alignment: .leading, spacing: 4) {
                    Text("Price Drop")
                        .font(.system(size: 16, weight: .heavy))
                        .foregroundColor(.black)
                    HStack(alignment: .top, spacing: 8) {
                        if let imageData = listing.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width * 0.51, height: geometry.size.height - 25)
                                .clipped()
                        } else {
                            Color.gray
                                .frame(width: geometry.size.width * 0.51, height: geometry.size.height - 25)
                        }
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("6hrs ago")
                                .font(.caption2)
                            Text(listing.name)
                                .font(.system(size: 12, weight: .bold))
                                .lineLimit(3)
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
                .padding(.top, -2) 
            }
            .widgetURL(URL(string: "grailedapp://listing/\(listing.id)"))
            .containerBackground(for: .widget) {
                Color(white: 1.0)
            }
        } else {
            Text("No data available")
        }
    }
}
