//
//  ContentView.swift
//  WeatherAppCombine
//
//  Created by Timur on 12/4/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        VStack {
            TextField("Enter city", text: $viewModel.city, onCommit: {
                viewModel.fetchWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Spacer()
            
            if !viewModel.cityName.isEmpty {
                VStack(spacing: 16) {
                    Text(viewModel.cityName)
                        .font(.largeTitle)
                        .bold()
                    
                    Text(viewModel.temperature)
                        .font(.system(size: 64))
                        .bold()
                    
                    Text(viewModel.weatherDescription.capitalized)
                        .font(.title)
                    
                    if let iconURL = URL(string: "https://openweathermap.org/img/wn/\(viewModel.icon)@2x.png") {
                        AsyncImage(url: iconURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Humidity:")
                                .bold()
                            Text(viewModel.humidity)
                        }
                        HStack {
                            Text("Wind Speed:")
                                .bold()
                            Text(viewModel.windSpeed)
                        }
                        HStack {
                            Text("Pressure:")
                                .bold()
                            Text(viewModel.pressure)
                        }
                    }
                    .font(.body)
                }
                .padding()
            } else {
                Text("Enter a city to get the weather.")
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.fetchWeather()
        }
    }
}


#Preview {
    ContentView()
}
