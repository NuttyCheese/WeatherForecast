//
//  WeatherViewController.swift
//  WeatherForecast
//
//  Created by Борис Павлов on 09.06.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    //MARK: - Outlets
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //MARK: - Properties
    private let networkManager = NetworkManager()
    private lazy var locationManager: CLLocationManager = {
        let lm = CLLocationManager()
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        lm.delegate = self
        return lm
    }()
    
    //MARK: - override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView()
        
        networkManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateInterface(weather: currentWeather)
        }
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }
    
    //MARK: - Actions
    @IBAction func searchPressed(_ sender: UIButton) {
        searchAlertController(title: "Enter city name", meassage: nil, alertOk: "Search", alertCancel: "Cancel") { [unowned self] city in
            self.networkManager.fetchCurrentWeather(forRequesttype: .cityType(city: city))
        }
    }
    
    //MARK: - funcions
    private func settingsView() {
        cityNameLabel.text = ""
        temperatureLabel.text = ""
        feelsLikeTemperatureLabel.text = ""
        weatherIconImageView.image = UIImage(named: "")
    }
   
    private func updateInterface(weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityNameLabel.text = weather.cityName
            self.temperatureLabel.text = "t \(weather.temperatureString)°C"
            self.feelsLikeTemperatureLabel.text = "Feels like \(weather.feelsLikeTemperatureString)°C"
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.latitude
    
        networkManager.fetchCurrentWeather(forRequesttype: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

//MARK: - AlertController
extension WeatherViewController {
    private func searchAlertController(title: String, meassage: String?, alertOk: String, alertCancel: String, completionHendler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: meassage, preferredStyle: .alert)
        alertController.addTextField { tf in
            let cities = ["London","Tokio","Moscow","Paris","New York",]
            tf.placeholder = cities.randomElement()
        }
        
        let alertAction = UIAlertAction(title: alertOk, style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let city = cityName.split(separator: " ").joined(separator: "%20")
                completionHendler(city)
                
            }
        }
        let alertCancel = UIAlertAction(title: alertCancel, style: .cancel)
        
        alertController.addAction(alertAction)
        alertController.addAction(alertCancel)
            
        present(alertController, animated: true)
    }
}
