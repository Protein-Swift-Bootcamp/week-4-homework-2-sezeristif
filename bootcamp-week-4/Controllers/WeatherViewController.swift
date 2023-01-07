//
//  ShowViewController.swift
//  bootcamp-week-4
//
//  Created by Sezer Istif on 3.01.2023.
//

import UIKit
import MapKit

class WeatherViewController: UIViewController {
    
    var weatherManager = WeatherManager()
    var cityName = ""
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var loaderAnimation: UIActivityIndicatorView!
    @IBOutlet weak var mapKitView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weatherManager.delegate = self
        weatherManager.fetchWeather(cityName: cityName)
    }
    
}

extension WeatherViewController: WeatherManagerDelegate {
    func weatherDidUpdate(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.updateLabels(weather: weather)
            self.annotateMap(weather: weather)
            self.showElements(weather: weather)
        }
    }
    
    private func updateLabels(weather: WeatherModel) {
        self.cityNameLabel.text = "City: \(weather.cityName)"
        self.temperatureLabel.text = "Temperature: \(weather.temperatureString)"
    }
    
    private func annotateMap(weather: WeatherModel) {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(weather.latitude), longitude: CLLocationDegrees(weather.longitude))
        annotation.coordinate = centerCoordinate
        annotation.title = weather.cityName
        self.mapKitView.addAnnotation(annotation)
        
    }
    
    private func showElements(weather: WeatherModel) {
        self.cityNameLabel.isHidden = false
        self.temperatureLabel.isHidden = false
        self.mapKitView.isHidden = false
        self.loaderAnimation.isHidden = true
    }
    
    func didFailedWithError(error: Error) {
        print(error)
    }
}
