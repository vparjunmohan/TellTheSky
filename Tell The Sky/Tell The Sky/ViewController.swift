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
            
//            let url = " https://api.openweathermap.org/data/3.0/onecall?lat=\(currentLoc.coordinate.latitude)&lon=\(currentLoc.coordinate.longitude)&appid=\(key)"
            
            let url = "https://api.openweathermap.org/data/2.5/weather?lat=13.07&lon=77.59&appid=60054c7b80e9b5dbf30d5b02ec6663e8"
            
            
            AF.request(url).responseJSON(completionHandler: { [self] response in
                switch response.result {
                case .success:
                    print("success")
                    if let responseValue = response.value as? [String: Any]{
                        print(responseValue)
                    }
                    break
                default:
                    break
                }
                
            } )
            

            
//        https://api.openweathermap.org/data/3.0/onecall?lat={lat}&lon={lon}&exclude={part}&appid={API key}
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
