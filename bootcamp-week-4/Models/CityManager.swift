//
//  City.swift
//  bootcamp-week-4
//
//  Created by Sezer Istif on 4.01.2023.
//

import Foundation


struct CityObject: Decodable {
    let name: String
    let id: Int
}

struct CityData: Decodable {
    let cities: Array<CityObject>
}

struct CityManager {
    let citiesURL = "https://63b5575d58084a7af391143a.mockapi.io/cities"
    
    var delegate: CityManagerDelegate?
    
    func fetchCities() {
        performRequest(with: citiesURL)
    }
    
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.fetchCitiesFailed(error: error!)
                    return
                }
                
                
                if let safeData = data {
                    if let cities = self.parseJSON(safeData) {
                        
                        self.delegate?.citiesDidUpdate(self, cities: cities)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ cityData: Data) -> [CityObject]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([CityObject].self, from: cityData)
            return decodedData
        } catch {
            self.delegate?.fetchCitiesFailed(error: error)
            return nil
        }
    }
}

protocol CityManagerDelegate {
    func citiesDidUpdate(_ cityManager: CityManager, cities: [CityObject])
    func fetchCitiesFailed(error: Error)
}

