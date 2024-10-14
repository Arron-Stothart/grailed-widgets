//
//  SmallWidgetView.swift
//  widgetsExtension
//
//  Created by Arron Stothart on 14/10/2024.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 8) {
                Text("Price Drop")
                    .font(.system(size: 16, weight: .heavy))
                    .foregroundColor(.black);
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: entry.imageURL)) { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Color.gray
                    }
                    .frame(width: geometry.size.width * 0.5, height: geometry.size.height - 30) // TODO: Improve height handling
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("6hrs ago")
                            .font(.caption2)
                        Text(entry.name)
                            .font(.subheadline.bold())
                            .lineLimit(2)
                        Text(entry.currentPrice)
                            .font(.custom("Video", size: 12))
                            .foregroundColor(Color(red: 0.75, green: 0.16, blue: 0.15))
                        Text(entry.originalPrice)
                            .font(.custom("Video", size: 12))
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .widgetURL(URL(string: "grailedapp://listing/\(entry.id)"))
        .containerBackground(for: .widget) {
            Color(UIColor.systemBackground)
        }
    }
}
