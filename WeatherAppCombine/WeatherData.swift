//
//  WeatherData.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import Foundation

struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let wind: Wind
    
    struct Main: Codable {
        let temp: Double
        let humidity: Int
        let pressure: Int
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
    
    struct Wind: Codable {
        let speed: Double
    }
}

