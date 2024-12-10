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
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                if let today = viewModel.forecast.first {
                    VStack(spacing: 10) {
                        Text("Today")
                            .font(.largeTitle)
                            .bold()
                            .foregroundColor(.white)
                        
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
                        
                        Text(today.temperature)
                            .font(.system(size: 60, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(today.description.capitalized)
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(20)
                } else {
                    ProgressView("Loading...")
                        .foregroundColor(.white)
                }
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("5-Day Forecast")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(viewModel.forecast.dropFirst()) { day in
                                VStack(spacing: 10) {
                                    Text(day.day)
                                        .font(.subheadline)
                                        .foregroundColor(.white)
                                        .bold()
                                    
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
                                    
                                    Text(day.temperature)
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.white)
                                    
                                    Text(day.description.capitalized)
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                                .padding()
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(15)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .onAppear {
            
            viewModel.fetchForecast(latitude: 51.5074, longitude: -0.1278)
        }
    }
}


#Preview {
    ContentView()
}
