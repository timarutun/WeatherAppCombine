//
//  WeatherViewModel.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var forecast: [ForecastDay] = []
    
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    /// Mock data for fallback in case of no internet or API errors
    private let mockData: [ForecastDay] = [
        ForecastDay(day: "Today", temperature: "25°C", description: "Sunny", icon: "01d"),
        ForecastDay(day: "Mon", temperature: "26°C", description: "Partly Cloudy", icon: "02d"),
        ForecastDay(day: "Tue", temperature: "24°C", description: "Rainy", icon: "09d"),
        ForecastDay(day: "Wed", temperature: "22°C", description: "Stormy", icon: "11d"),
        ForecastDay(day: "Thu", temperature: "23°C", description: "Windy", icon: "50d")
    ]
    
    func fetchForecast(latitude: Double, longitude: Double) {
        weatherService.fetchForecast(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching forecast: \(error)")
                    // Fallback to mock data in case of an error
                    self.forecast = self.mockData
                }
            }, receiveValue: { [weak self] data in
                self?.forecast = data.daily.map { daily in
                    let date = Date(timeIntervalSince1970: TimeInterval(daily.dt))
                    let formatter = DateFormatter()
                    formatter.dateFormat = "EEE, MMM d"
                    let day = formatter.string(from: date)
                    
                    return ForecastDay(
                        day: day,
                        temperature: "\(Int(daily.temp.day))°C",
                        description: daily.weather.first?.description ?? "N/A",
                        icon: daily.weather.first?.icon ?? "01d"
                    )
                }
            })
            .store(in: &cancellables)
    }
    
    init() {
        // Load mock data initially for a fallback display
        self.forecast = mockData
    }
}

struct ForecastDay: Identifiable {
    let id = UUID()
    let day: String
    let temperature: String
    let description: String
    let icon: String
}


