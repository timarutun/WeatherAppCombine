//
//  WeatherViewModel.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var city: String = "London"
    @Published var weatherDescription: String = ""
    @Published var temperature: String = ""
    @Published var cityName: String = ""
    @Published var icon: String = ""
    @Published var humidity: String = ""
    @Published var windSpeed: String = ""
    @Published var pressure: String = ""
    
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather() {
        weatherService.fetchWeather(for: city)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching weather: \(error)")
                }
            }, receiveValue: { [weak self] (data: WeatherData) in
                self?.cityName = data.name
                self?.weatherDescription = data.weather.first?.description ?? "N/A"
                self?.temperature = "\(Int(data.main.temp))°C"
                self?.icon = data.weather.first?.icon ?? "01d"
                self?.humidity = "\(data.main.humidity)%"
                self?.windSpeed = "\(data.wind.speed) m/s"
                self?.pressure = "\(data.main.pressure) hPa"
            })
            .store(in: &cancellables)
    }
}

