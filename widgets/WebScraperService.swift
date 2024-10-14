//
//  WebScraperService.swift
//  widgets
//
//  Created by Arron Stothart on 14/10/2024.
//


import Foundation
import SwiftSoup

struct WebScraperService {
    // Service to scrape product information from the specified URL. (Demo-only)
    static func scrapeProductInfo(from url: URL) async throws -> (imageURL: String, name: String, designers: [String], currentPrice: String, originalPrice: String) {
        let config: URLSessionConfiguration = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.0 Safari/605.1.15",
            "Accept-Language": "en-US,en;q=0.9",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Connection": "keep-alive"
        ]
        
        let session = URLSession(configuration: config)
        
        let (data, _) = try await session.data(from: url)
        let htmlString = String(data: data, encoding: .utf8) ?? ""
        
        let doc = try SwiftSoup.parse(htmlString)
        
        // Extract listing attibutes based on class names
        let imageURL = try doc.select("img.Photo_picture__g7Lsj").first()?.attr("src") ?? ""
        let name = try doc.select("h1").first()?.text() ?? ""
        
        // Update designers scraping logic
        let designersElements = try doc.select("p.Headline_headline___qUL5.Text.Details_designers__NnQ20 a.Designers_designer__quaYl")
        let designers = try designersElements.map { try $0.text() }
        
        let currentPrice = try doc.select("span.Money_root__8lDCT.Price_onSale__qffVR").first()?.text() ?? ""
        let originalPrice = try doc.select("span.Money_root__8lDCT.Price_original__WxZuZ").first()?.text() ?? ""
        
        return (imageURL, name, designers, currentPrice, originalPrice)
    }
}
