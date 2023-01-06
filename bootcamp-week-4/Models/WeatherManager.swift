//
//  WeatherManager.swift
//  bootcamp-week-4
//
//  Created by Sezer Istif on 3.01.2023.
//

import Foundation

struct WeatherModel {
    let cityName: String
    let temperature: Double
    let latitude: Float
    let longitude: Float
    
    
    var temperatureString: String {
        return String(format: "%0.1f", temperature)
    }
}

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: Array<Weather>
    let coord: Coord
}

struct Coord: Decodable {
    let lon: Float
    let lat: Float
}


struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=8c635604c18ac05b296235d9d4cfb92b"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        performRequest(with: urlString!)
    }
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.weatherDidUpdate(self, weather: weather)
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let temp = decodedData.main.temp
            let name = decodedData.name
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            
            let weather = WeatherModel(cityName: name, temperature: temp, latitude: lat, longitude: lon)
            return weather
        } catch {
            self.delegate?.didFailedWithError(error: error)
            return nil
        }
    }
}

protocol WeatherManagerDelegate {
    func weatherDidUpdate(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailedWithError(error: Error)
}

