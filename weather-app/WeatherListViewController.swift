//
//  WeatherListViewController.swift
//  Weather App
//
//  Created by Wilhelm Fors on 2/16/18.
//  Copyright © 2018 Wilhelm Fors. All rights reserved.
//

import UIKit

class WeatherListViewController: UITableViewController {
    
    
    var weatherResponses: [WeatherResponse] = []
    var refresher: UIRefreshControl!
    var locationsList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationsList = UserDefaultsHelper.getLocations()
        
        createRefresher()
        loadAll()
        
        navigationItem.rightBarButtonItem = editButtonItem
        navigationItem.title = "Väder"
        
        setBackgroundColor()
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    @objc func loadAll() {
        weatherResponses = []
        for location in locationsList {
            getWeather(city: location)
        }
    }
    
    func getWeather(city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=e418c3bfd49c33eccee5e7c7bbd5b4e2"
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) {(data, response, error) in
            
            guard let data = data else {return}
            do {
                let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
                self.weatherResponses.append(weatherResponse)
            } catch let jsonError {
                self.weatherResponses.append(WeatherResponse(name: city))
                print(jsonError)
            }
            if(self.weatherResponses.count == self.locationsList.count) {
                DispatchQueue.main.async {
                    print(self.locationsList)
                    print(self.weatherResponses)
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
            }
            
            
        }.resume()
    }
    
    func createRefresher() {
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Uppdaterar väder...")
        refresher.addTarget(self, action: #selector(WeatherListViewController.loadAll), for: UIControlEvents.valueChanged)
        tableView.addSubview(refresher)
    }
    
    
    func setBackgroundColor() {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        backgroundView.backgroundColor = UIColor(red:0.26, green:0.50, blue:0.67, alpha:1.0)
        self.tableView.backgroundView = backgroundView
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherResponses.count
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("WeatherListCell", owner: self, options: nil)?.first as! WeatherListCell
        
        let name = locationsList[indexPath.row]
        let weatherResponse: WeatherResponse = weatherResponses.filter({$0.name! == name})[0]
        
        if let response = weatherResponse.main {
            cell.tempValue.text = String((response["temp_min"]! - 273.15)) + " C"
            cell.pressureValue.text = String(response["pressure"]!) + " kP"
        } else {
            cell.tempValue.text = "Hittades inte"
            cell.pressureValue.text = "Hittades inte"
        }
        
        cell.cityName.text = weatherResponse.name!
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete) {
            weatherResponses = weatherResponses.filter({$0.name! != locationsList[indexPath.row]})
            locationsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            UserDefaultsHelper.updateLocations(locations: locationsList)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let movedLocation = locationsList[sourceIndexPath.row]
        locationsList.remove(at: sourceIndexPath.row)
        locationsList.insert(movedLocation, at: destinationIndexPath.row)
        UserDefaultsHelper.updateLocations(locations: locationsList)
    }
    
}

