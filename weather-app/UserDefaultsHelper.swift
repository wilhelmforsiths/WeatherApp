//
//  UserDefaultsHelper.swift
//  weather-app
//
//  Created by Wilhelm Fors on 2/19/18.
//  Copyright © 2018 Wilhelm Fors. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    static func getLocations() -> [String] {
        if(UserDefaults.standard.array(forKey: Values.LOCATIONS_KEY) == nil) {
            UserDefaults.standard.set(Values.locations, forKey: Values.LOCATIONS_KEY)
        }
        return UserDefaults.standard.array(forKey: Values.LOCATIONS_KEY) as! [String]
    }
    
    static func updateLocations(locations: [String]) {
        UserDefaults.standard.set(locations, forKey: Values.LOCATIONS_KEY)
    }
}
