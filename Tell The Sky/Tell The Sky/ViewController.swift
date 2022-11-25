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
    
    var locationManager = CLLocationManager()
    let key = "60054c7b80e9b5dbf30d5b02ec6663e8"
    
    var currentCity: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self

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
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLoc.coordinate.latitude)&lon=\(currentLoc.coordinate.longitude)&appid=\(key)"
            AF.request(url).responseJSON(completionHandler: { [self] response in
                switch response.result {
                case .success:
                    if let responseValue = response.value as? [String: Any]{
                        print(responseValue)
                    }
                    break
                default:
                    break
                }
            } )
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
