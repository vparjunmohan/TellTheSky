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
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherTypeLabel: UILabel!
    @IBOutlet weak var weatherDetailView: UIView!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyCollectionView: UITableView!
    @IBOutlet weak var currentImageView: UIImageView!
    
    
    var locationManager = CLLocationManager()
    let key = "d4d20ef76e6d8db277d54c5a66a4db38"
    
    var hourlyWeather: [[String:Any]] = []
    var dailyWeather: [[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
        weatherDetailView.layer.cornerRadius = 15
        
        
        
        
        // kelvin to cel
        let temperature = 296.03
        let x = String(format: "%.0f", temperature - 273.15)
//        print("\(x)°")
        
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        

    }
    
    func getLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: Date().localDate())
    }
    
    func epochToLocalTime(epochTime: Int) -> String{
        let currentTime = Double(epochTime)
        let date = Date(timeIntervalSince1970: currentTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.short
        return dateFormatter.string(from: date)
        
    }
    
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
        case "Clear":
            return UIImage(named: "clear")!
        case "Clouds":
            return UIImage(named: "clouds")!
        default:
            return UIImage()
        }
    }
    
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentData = hourlyWeather[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HourlyCollectionViewCell", for: indexPath) as! HourlyCollectionViewCell
        cell.timeLabel.text = epochToLocalTime(epochTime: currentData["dt"] as! Int)
        cell.temperatureLabel.text = "\(String(format: "%.0f", ((currentData["temp"] as! Double) - 273.15)))°"
        return cell
        
    }
    
    
}




extension ViewController: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        var currentLocation: CLLocation!
        let authorizationStatus: CLAuthorizationStatus
        if #available(iOS 14, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            currentLocation = locationManager.location
            CLGeocoder().reverseGeocodeLocation(currentLocation) { [self] (placemarks, error) -> Void in
                if error != nil {
                    return
                }else if let country = placemarks?.first?.country,
                         let city = placemarks?.first?.locality {
                    cityLabel.text = "\(city), \(country)"
                }
                else {
                }
            }
//            let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(currentLoc.coordinate.latitude)&lon=\(currentLoc.coordinate.longitude)&appid=\(key)"
//
            let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&appid=d4d20ef76e6d8db277d54c5a66a4db38"
            
            
            AF.request(url).responseJSON(completionHandler: { [self] response in
                switch response.result {
                case .success:
                    if let responseValue = response.value as? [String: Any], let currentConditions = responseValue["current"] as? [String:Any], let weather = currentConditions["weather"] as? [[String:Any]], let hourly = responseValue["hourly"] as? [[String:Any]], let daily = responseValue["daily"] as? [[String:Any]] {
                        temperatureLabel.text = "\(String(format: "%.0f", ((currentConditions["temp"] as! Double) - 273.15)))°"
                        let weatherCondition = currentConditions["weather"] as! [[String:Any]]
                        weatherTypeLabel.text = weatherCondition[0]["description"] as? String
                        currentImageView.image = imageForCurrentWeather(weather: weather[0]["main"] as! String)
                        windLabel.text = "\(String(describing: currentConditions["wind_speed"] as! Double)) m/s"
                        humidityLabel.text = "\(String(describing: currentConditions["humidity"] as! Double)) %"
                        pressureLabel.text = "\(String(describing: currentConditions["pressure"] as! Double)) hPa"
                        hourlyWeather = hourly
                        dailyWeather = daily
                        hourlyCollectionView.reloadData()
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
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        hourlyCollectionView.collectionViewLayout = layout
    }
}
