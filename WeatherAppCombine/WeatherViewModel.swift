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
    
    func fetchForecast(latitude: Double, longitude: Double) {
        weatherService.fetchForecast(latitude: latitude, longitude: longitude)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error fetching forecast: \(error)")
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
}

struct ForecastDay: Identifiable {
    let id = UUID()
    let day: String
    let temperature: String
    let description: String
    let icon: String
}


