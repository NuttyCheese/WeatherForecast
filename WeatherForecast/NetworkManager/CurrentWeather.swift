//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Борис Павлов on 09.06.2022.
//

import Foundation

struct CurrentWeather {
    let cityName: String
    
    private let temperature: Double
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    private let feelsLikeTemperature: Double
    var feelsLikeTemperatureString: String {
        return String(format: "%.0f", feelsLikeTemperature)
    }
    
    private let conditionCode: Int
    var systemIconNameString: String {
        switch conditionCode {
        case 200...232: return "cloud.bolt.rain.fill"
        case 300...321: return "cloud.drizzle.fill"
        case 500...531: return "cloud.rain.fill"
        case 600...622: return "cloud.snow.fill"
        case 701...781: return "smoke.fill"
        case 800: return "sun.min.fill"
        case 801...804: return "cloud.fill"
        default: return "nosign"
        }
    }
    
    init?(weatherModel: CurrnetWeatherData) {
        cityName = weatherModel.name
        temperature = weatherModel.main.temp
        feelsLikeTemperature = weatherModel.main.feelsLike
        conditionCode = weatherModel.weather.first!.id
    }
}
