//
//  WeatherService.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import Foundation
import Combine

class WeatherService {
    private let baseURL = "https://api.openweathermap.org/data/2.5/onecall"
    private let apiKey = "fb63a7f74882a3dbb98e2fbd6204763a"
    
    func fetchForecast(latitude: Double, longitude: Double) -> AnyPublisher<ForecastData, Error> {
        guard let url = URL(string: "\(baseURL)?lat=\(latitude)&lon=\(longitude)&exclude=current,minutely,hourly,alerts&units=metric&appid=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ForecastData.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

