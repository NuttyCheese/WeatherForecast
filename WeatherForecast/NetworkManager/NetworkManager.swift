//
//  NetworkManager.swift
//  WeatherForecast
//
//  Created by Борис Павлов on 09.06.2022.
//

import Foundation
import CoreLocation

enum Key: String {
    case apiKey = "c17f1037d81dac146ef74377d3afe8c7"
}

class NetworkManager {
    enum RequestType {
        case cityType(city: String)
        case coordinate(latitude: CLLocationDegrees, longitude: CLLocationDegrees)
    }
    
    var onCompletion: ((CurrentWeather) -> Void)?
    
    func fetchCurrentWeather(forRequesttype requestType: RequestType) {
        var urlString = ""
        
        switch requestType {
        case .cityType(let city): urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(Key.apiKey.rawValue)&units=metric"
        case .coordinate(let latitude, let longitude): urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(Key.apiKey.rawValue)&units=metric"
        }
        
        performRequest(withURLString: urlString)
    }
    
    private func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let currentWeather = self.parseJSON(withData: data) {
                    self.onCompletion?(currentWeather)
                }
            }
        }.resume()
    }
    
    func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrnetWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(weatherModel: currentWeatherData) else{ return nil }
            return currentWeather
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
