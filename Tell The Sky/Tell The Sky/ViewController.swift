//
//  ViewController.swift
//  Tell The Sky
//
//  Created by Arjun Mohan on 25/11/22.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    var locationManager = CLLocationManager()
    
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
