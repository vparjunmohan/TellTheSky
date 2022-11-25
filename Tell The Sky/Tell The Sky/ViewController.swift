//
//  ViewController.swift
//  Tell The Sky
//
//  Created by Arjun Mohan on 25/11/22.
//

import UIKit
import CoreLocation
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var locationManager = CLLocationManager()
    let key = "d4d20ef76e6d8db277d54c5a66a4db38"
    
    var currentCity: String = ""
    var hourlyWeather: [[String:Any]] = []
    var dailyWeather: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        
        
       
        

    }
    
    func getLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: Date().localDate())
    }
    
    
}

extension ViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var currentLoc: CLLocation!
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLoc = locationManager.location
            print(currentLoc.coordinate.latitude)
            print(currentLoc.coordinate.longitude)
            CLGeocoder().reverseGeocodeLocation(currentLoc) { [self] (placemarks, error) -> Void in
                if error != nil {
                    return
                }else if let country = placemarks?.first?.country,
                         let city = placemarks?.first?.locality {
                    currentCity = "\(city), \(country)"
                }
                else {
                }
            }
//            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLoc.coordinate.latitude)&lon=\(currentLoc.coordinate.longitude)&appid=\(key)"
//
            let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(currentLoc.coordinate.latitude)&lon=\(currentLoc.coordinate.longitude)&appid=d4d20ef76e6d8db277d54c5a66a4db38"
            
            
//            AF.request(url).responseJSON(completionHandler: { [self] response in
//                switch response.result {
//                case .success:
//                    if let responseValue = response.value as? [String: Any], let currentConditions = responseValue["current"] as? [String:Any], let weather = currentConditions["weather"] as? [[String:Any]], let hourly = responseValue["hourly"] as? [[String:Any]], let daily = responseValue["daily"] as? [[String:Any]] {
//                        hourlyWeather = hourly
//                        dailyWeather = daily
//
//                    }
//                    break
//                default:
//                    break
//                }
//            } )
        case .notDetermined:
            print("not determined")
        case .restricted:
            print("restricted")
        case .denied:
            // handle location access if it is denied
            print("denied")
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
}


extension Date {
    func localDate() -> Date {
        let nowUTC = Date()
        let timeZoneOffset = Double(TimeZone.current.secondsFromGMT(for: nowUTC))
        guard let localDate = Calendar.current.date(byAdding: .second, value: Int(timeZoneOffset), to: nowUTC) else {return Date()}

        return localDate
    }
}


extension ViewController {
    func setupUI() {
        dateLabel.text = getLocalDate()
    }
}
