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
            // Dynamic gradient background
            dynamicBackground
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Location and update time
                VStack {
                    Text("New York, USA")
                        .font(.title)
                        .bold()
                        .foregroundColor(.white)
                    
                    Text("Updated: \(Date().formatted())")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                // Today's weather forecast
                if let today = viewModel.forecast.first {
                    VStack(spacing: 10) {
                        Text("Today")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
                        // Weather icon for today's forecast
                        if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(today.icon)@2x.png") {
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        
                        // Temperature and weather description
                        Text(today.temperature)
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(today.description.capitalized)
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(20)
                } else {
                    // Loading indicator for forecast data
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                }
                
                // Additional weather details (humidity, wind, pressure)
                HStack(spacing: 30) {
                    WeatherDetailView(icon: "humidity.fill", value: "60%", label: "Humidity")
                    WeatherDetailView(icon: "wind", value: "5 m/s", label: "Wind")
                    WeatherDetailView(icon: "barometer", value: "1013 hPa", label: "Pressure")
                }
                .padding(.horizontal)
                
                // Section divider
                Divider()
                    .background(Color.white.opacity(0.5))
                    .padding(.horizontal)
                
                // 5-day weather forecast
                VStack(alignment: .leading, spacing: 10) {
                    Text("5-Day Forecast")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    // Horizontal scrollable list of 5-day forecast
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.forecast.dropFirst()) { day in
                                VStack(spacing: 10) {
                                    Text(day.day)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .bold()
                                    
                                    // Weather icon for each day
                                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(day.icon)@2x.png") {
                                        AsyncImage(url: iconURL) { image in
                                            image
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 50, height: 50)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                    
                                    // Temperature and description for each day
                                    Text(day.temperature)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    Text(day.description.capitalized)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .background(Color.black.opacity(0.3))
                                .cornerRadius(15)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
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
        let dayGradient = Gradient(colors: [
            Color.blue.opacity(0.7),
            Color.cyan.opacity(0.7)
        ])
        
        // Nighttime gradient: dark blue and black
        let nightGradient = Gradient(colors: [
            Color.black.opacity(0.8),
            Color.blue.opacity(0.7)
        ])
        
        // Use daytime gradient for 6 AM - 6 PM, otherwise use nighttime gradient
        return LinearGradient(
            gradient: hour >= 6 && hour < 18 ? dayGradient : nightGradient,
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

/// A reusable view for displaying weather details such as humidity, wind speed, or pressure.
struct WeatherDetailView: View {
    let icon: String
    let value: String
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            // Icon representing the weather detail
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.white)
            
            // Value of the weather detail (e.g., "60%")
            Text(value)
                .font(.title2)
                .foregroundColor(.white)
                .bold()
            
            // Label for the weather detail (e.g., "Humidity")
            Text(label)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(width: 80)
    }
}

#Preview {
    ContentView()
}
