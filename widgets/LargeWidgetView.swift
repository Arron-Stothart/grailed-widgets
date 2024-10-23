//
//  LargeWidgetView.swift
//  widgetsExtension
//
//  Created by Arron Stothart on 15/10/2024.
//

import Foundation
import SwiftUI

struct LargeWidgetView: View {
    var entry: GrailedListingsEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text("Price Drops")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.black)
                Divider()
                ForEach(Array(entry.listings.prefix(3).enumerated()), id: \.element.id) { index, listing in
                    LargeWidgetItemView(listing: listing, geometry: geometry)
                    if index < 2 {
                        Divider()
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .padding(.vertical, 12)
        .widgetURL(URL(string: "grailedapp://listings"))
        .containerBackground(for: .widget) {
            Color(white: 1.0)
        }
    }
}

struct LargeWidgetItemView: View {
    var listing: GrailedListing
    var geometry: GeometryProxy
    
    var discountPercentage: Int {
        guard let original = Double(listing.originalPrice.dropFirst()),
              let current = Double(listing.currentPrice.dropFirst()),
              original > 0 else {
            return 0
        }
        return Int(round((1 - current / original) * 100))
    }

    var body: some View {
        HStack(alignment: .top ,spacing: 8) {
            VStack(alignment: .leading, spacing: 2) {
                Text(listing.designers.joined(separator: " x "))
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                Text(listing.name)
                    .font(.system(size: 16))
                    .lineLimit(1)
                HStack {
                    Text(listing.currentPrice)
                        .font(.custom("Video", size: 16))
                        .foregroundColor(Color(red: 0.75, green: 0.16, blue: 0.15))
                    Text(listing.originalPrice)
                        .font(.custom("Video", size: 16))
                        .strikethrough()
                        .foregroundColor(.secondary)
                    if discountPercentage > 0 {
                        Text("\(discountPercentage)% off")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                    }
                }
            }
            Spacer()
            if let imageData = listing.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width * 0.25, height: (geometry.size.height - 40) / 3)
                    .clipped()
            } else {
                Color.gray
                    .frame(width: geometry.size.width * 0.25, height: (geometry.size.height - 40) / 3)
            }
        }
    }
}
