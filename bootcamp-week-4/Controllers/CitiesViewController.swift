//
//  ViewController.swift
//  bootcamp-week-4
//
//  Created by Sezer Istif on 3.01.2023.
//

import UIKit

class CitiesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cities: Array<CityObject> = []
    var cityManager = CityManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityManager.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        cityManager.fetchCities()
    }
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! CustomTableViewCell
        cell.cellLabel.text = cities[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let showVC = self.storyboard?.instantiateViewController(withIdentifier: "weatherViewController") as! WeatherViewController
        showVC.cityName = cities[indexPath.row].name
        self.present(showVC, animated:true, completion:nil)
    }
}

extension CitiesViewController: CityManagerDelegate {
    func citiesDidUpdate(_ cityManager: CityManager, cities: [CityObject]) {
        DispatchQueue.main.async {
            self.cities = cities
            self.tableView.reloadData()
        }
    }
    
    func fetchCitiesFailed(error: Error) {
        print(error)
    }
}




