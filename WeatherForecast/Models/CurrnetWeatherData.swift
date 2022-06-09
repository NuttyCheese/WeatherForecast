//
//  CurrnetWeatherData.swift
//  WeatherForecast
//
//  Created by Борис Павлов on 09.06.2022.
//

import Foundation

struct CurrnetWeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
    }
}

struct Weather: Codable {
    let id: Int
}
