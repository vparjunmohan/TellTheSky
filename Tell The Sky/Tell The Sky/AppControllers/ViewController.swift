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
    @IBOutlet weak var dailyTableView: UITableView!
    @IBOutlet weak var currentImageView: UIImageView!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var sunRiseLabel: UILabel!
    @IBOutlet weak var sunSetLabel: UILabel!
    
    var locationManager = CLLocationManager()
    let key = "d4d20ef76e6d8db277d54c5a66a4db38"
    
    var hourlyWeather: [[String:Any]] = []
    var dailyWeather: [[String:Any]] = []
    
    var tempView: UIView = {
        let view = UIView()
        view.tag = 100
        view.backgroundColor = #colorLiteral(red: 0.1058823529, green: 0.1137254902, blue: 0.1215686275, alpha: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        
    }
    
    func getLocalDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM"
        return dateFormatter.string(from: Date().localDate())
    }
    
    func epochToLocalTime(epochTime: Int, dateRequired: Bool) -> String{
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentData = dailyWeather[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailyTableViewCell", for: indexPath) as! DailyTableViewCell
        cell.separatorInset = .zero
        cell.selectionStyle = .none
        cell.dayLabel.text = epochToLocalTime(epochTime: currentData["dt"] as! Int, dateRequired: true)
        let temperatureData = currentData["temp"] as? [String:Any]
        
        let lowTemp = String(format: "%.0f", ((temperatureData!["min"] as! Double) - 273.15))
        let highTemp = String(format: "%.0f", ((temperatureData!["max"] as! Double) - 273.15))
        cell.temperatureLabel.text = "Low \(lowTemp)°     High \(highTemp)°"
        let weather = currentData["weather"] as? [[String:Any]]
        cell.weatherImageView.image = imageForCurrentWeather(weather: weather![0]["main"] as! String)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70
        } else {
            return 60
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
        cell.timeLabel.text = epochToLocalTime(epochTime: currentData["dt"] as! Int, dateRequired: false)
        cell.temperatureLabel.text = "\(String(format: "%.0f", ((currentData["temp"] as! Double) - 273.15)))°"
        let weather = currentData["weather"] as? [[String:Any]]
        cell.weatherImageView.image = imageForCurrentWeather(weather: weather![0]["main"] as! String)
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
            
            let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&appid=d4d20ef76e6d8db277d54c5a66a4db38"
            
            
            AF.request(url).responseJSON(completionHandler: { [self] response in
                switch response.result {
                case .success:
                    if let tempView = view.viewWithTag(100) {
                        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                            tempView.alpha = 0
                        }) { completed in
                            tempView.removeFromSuperview()
                        }
                    }
                    if let responseValue = response.value as? [String: Any], let currentConditions = responseValue["current"] as? [String:Any], let weather = currentConditions["weather"] as? [[String:Any]], let hourly = responseValue["hourly"] as? [[String:Any]], let daily = responseValue["daily"] as? [[String:Any]] {
                        temperatureLabel.text = "\(String(format: "%.0f", ((currentConditions["temp"] as! Double) - 273.15)))°"
                        let weatherCondition = currentConditions["weather"] as! [[String:Any]]
                        weatherTypeLabel.text = (weatherCondition[0]["description"] as? String)?.capitalized
                        currentImageView.image = imageForCurrentWeather(weather: weather[0]["main"] as! String)
                        feelsLikeLabel.text = "Feels like \(String(format: "%.1f", ((currentConditions["feels_like"] as! Double) - 273.15)))°"
                        sunRiseLabel.text = "Sunrise \(epochToLocalTime(epochTime: currentConditions["sunrise"] as! Int, dateRequired: false))"
                        sunSetLabel.text = "Sunset \(epochToLocalTime(epochTime: currentConditions["sunset"] as! Int, dateRequired: false))"
                        windLabel.text = "\(String(describing: currentConditions["wind_speed"] as! Double)) m/s"
                        humidityLabel.text = "\(String(describing: currentConditions["humidity"] as! Double)) %"
                        pressureLabel.text = "\(String(describing: currentConditions["pressure"] as! Double)) hPa"
                        hourlyWeather = hourly
                        hourlyWeather = Array(hourlyWeather[0..<25])
                        dailyWeather = daily
                        print(dailyWeather)
                        hourlyCollectionView.reloadData()
                        dailyTableView.reloadData()
                    }
                    break
                default:
                    break
                }
            } )
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            // handle location access if it is denied
            view.addSubview(tempView)
            tempView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            view.bringSubviewToFront(tempView)
            
            let alertController = UIAlertController (title: "Alert", message: "Allow access to Location services to continue", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { (_) -> Void in
                exit(0)
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        default:
            break
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
        view.addSubview(tempView)
        tempView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.bringSubviewToFront(tempView)
        weatherDetailView.layer.cornerRadius = 15
        
        // Location access
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        dateLabel.text = getLocalDate()
        
        // Register collection view and table view cells
        hourlyCollectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HourlyCollectionViewCell")
        dailyTableView.register(UINib(nibName: "DailyTableViewCell", bundle: nil), forCellReuseIdentifier: "DailyTableViewCell")
        
        // configure layout for collection view cells
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: 120, height: 120)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        hourlyCollectionView.collectionViewLayout = layout
    }
}
