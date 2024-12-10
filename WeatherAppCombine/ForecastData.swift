//
//  ForecastData.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/9/24.
//

import Foundation

struct ForecastData: Codable {
    let daily: [Daily]
    
    struct Daily: Codable {
        let dt: Int
        let temp: Temp
        let weather: [Weather]
        
        struct Temp: Codable {
            let day: Double
        }
        
        struct Weather: Codable {
            let description: String
            let icon: String
        }
    }
}
