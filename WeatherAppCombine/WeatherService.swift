//
//  WeatherService.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import Foundation
import Combine

class WeatherService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "fb63a7f74882a3dbb98e2fbd6204763a"
    
    func fetchWeather(for city: String) -> AnyPublisher<WeatherData, Error> {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(apiKey)&units=metric") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

