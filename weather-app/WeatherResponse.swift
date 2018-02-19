//
//  WeatherResponse.swift
//  weather-app
//
//  Created by Wilhelm Fors on 2/16/18.
//  Copyright © 2018 Wilhelm Fors. All rights reserved.
//

import Foundation

struct WeatherResponse : Decodable {
    let coord: [String: Double]?
    let weather: [weatherObject]?
    let base: String?
    let main: [String: Double]?
    let visibility: Int?
    let wind: [String: Double]?
    let clouds : [String: Int]?
    let dt: Int?
    let sys: sys?
    let id: Int?
    let name: String?
    let cod: Int?
    
    init(name: String) {
        self.name = name
        coord = nil
        weather = nil
        base = nil
        main = nil
        visibility = nil
        wind = nil
        clouds = nil
        dt = nil
        sys = nil
        id = nil
        cod = nil
    }
}

struct weatherObject: Decodable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

struct sys : Decodable {
    let type: Int?
    let id: Int?
    let message: Double?
    let country: String?
    let sunrise: Int?
    let sunset: Int?
}
