//
//  ContentView.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import SwiftUI

/// The main view displaying the current weather, additional details, and a 5-day forecast.
struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        ZStack {
            dynamicBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Top section: Location and update time
                LocationView()
                
                // Today's weather
                if let today = viewModel.forecast.first {
                    TodayWeatherView(forecast: today)
                } else {
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                }
                
                // Additional weather details
                WeatherDetailsView()
                
                // Divider
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                
                // 5-Day Forecast
                ForecastListView(forecast: viewModel.forecast)
            }
            .padding(.top)
        }
        .onAppear {
            // Fetch the weather forecast for New York City (example location)
            viewModel.fetchForecast(latitude: 40.7128, longitude: -74.0060)
        }
    }
    
    /// Determines the background gradient based on time and weather conditions
    private var dynamicBackground: LinearGradient {
        let hour = Calendar.current.component(.hour, from: Date())
        
        // Daytime gradient: blue and light blue
        let dayGradient = Gradient(colors: [Color.blue.opacity(0.7), Color.cyan.opacity(0.7)])
        
        // Nighttime gradient: dark blue and black
        let nightGradient = Gradient(colors: [Color.black.opacity(0.8), Color.blue.opacity(0.7)])
        
        return LinearGradient(
            gradient: hour >= 6 && hour < 18 ? dayGradient : nightGradient,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

/// Displays the location and update time.
struct LocationView: View {
    var body: some View {
        VStack {
            Text("New York, USA")
                .font(.title)
                .bold()
                .foregroundColor(.white)
            
            Text("Updated: \(Date().formatted())")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

/// Displays today's weather forecast.
struct TodayWeatherView: View {
    let forecast: ForecastDay
    
    var body: some View {
        VStack(spacing: 10) {
            Text("Today")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.white)
            
            if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(forecast.icon)@2x.png") {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(forecast.temperature)
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.white)
            
            Text(forecast.description.capitalized)
                .font(.title2)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(20)
    }
}

/// Displays weather details such as humidity, wind, and pressure.
struct WeatherDetailsView: View {
    var body: some View {
        HStack(spacing: 30) {
            WeatherDetailView(icon: "humidity.fill", value: "60%", label: "Humidity")
            WeatherDetailView(icon: "wind", value: "5 m/s", label: "Wind")
            WeatherDetailView(icon: "barometer", value: "1013 hPa", label: "Pressure")
        }
        .padding(.horizontal)
    }
}

/// A reusable view for displaying weather details such as humidity, wind speed, or pressure.
struct WeatherDetailView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon) // Weather detail icon
                .font(.largeTitle)
                .foregroundColor(.white)
            
            Text(value) // Value of the weather detail (e.g., "60%")
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            Text(label) // Label of the weather detail (e.g., "Humidity")
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 80)
    }
}

/// Displays the 5-day forecast in a horizontal scrollable view.
struct ForecastListView: View {
    let forecast: [ForecastDay]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("5-Day Forecast")
                .font(.headline)
                .foregroundColor(.white)
                .padding(.leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(forecast.dropFirst()) { day in
                        ForecastCardView(forecast: day)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Displays an individual day in the 5-day forecast.
struct ForecastCardView: View {
    let forecast: ForecastDay
    
    var body: some View {
        VStack(spacing: 10) {
            Text(forecast.day)
                .font(.subheadline)
                .foregroundColor(.white)
                .bold()
            
            if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(forecast.icon)@2x.png") {
                AsyncImage(url: iconURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(forecast.temperature)
                .font(.title2)
                .bold()
                .foregroundColor(.white)
            
            Text(forecast.description.capitalized)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    ContentView()
}
