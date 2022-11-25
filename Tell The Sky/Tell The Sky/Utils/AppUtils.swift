//
//  AppUtils.swift
//  Tell The Sky
//
//  Created by Arjun Mohan on 26/11/22.
//

import UIKit

class AppUtils: NSObject {
    
    // API key
    public static let key: String = "d4d20ef76e6d8db277d54c5a66a4db38"
    
    // Get local Date string
    func getLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: Date().localDate())
    }
    
    // Retrieve Local time from UNIX time
    func epochToLocalTime(epochTime: Int, dateRequired: Bool) -> String {
        let currentTime = Double(epochTime)
        let date = Date(timeIntervalSince1970: currentTime)
        let dateFormatter = DateFormatter()
        if dateRequired {
            dateFormatter.dateFormat = "EEEE"
        } else {
            dateFormatter.timeStyle = DateFormatter.Style.short
        }
        return dateFormatter.string(from: date)
    }
    
    // Images for current weather condition
    func imageForCurrentWeather(weather: String) -> UIImage {
        switch weather {
        case "Thunderstorm":
            return UIImage(named: "thunderstorm")!
        case "Drizzle":
            return UIImage(named: "drizzle")!
        case "Rain":
            return UIImage(named: "rain")!
        case "Snow":
            return UIImage(named: "snow")!
        case "Atmosphere":
            return UIImage(named: "fog")!
        case "Mist":
            return UIImage(named: "fog")!
        case "Haze":
            return UIImage(named: "fog")!
        case "Smoke":
            return UIImage(named: "fog")!
        case "Dust":
            return UIImage(named: "fog")!
        case "Fog":
            return UIImage(named: "fog")!
        case "Sand":
            return UIImage(named: "fog")!
        case "Ash":
            return UIImage(named: "fog")!
        case "Squall":
            return UIImage(named: "fog")!
        case "Tornado":
            return UIImage(named: "fog")!
        case "Clear":
            return UIImage(named: "clear")!
        case "Clouds":
            return UIImage(named: "clouds")!
        default:
            return UIImage()
        }
    }

}
