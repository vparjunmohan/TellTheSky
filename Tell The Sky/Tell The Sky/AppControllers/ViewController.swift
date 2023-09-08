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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Location access
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
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
        cell.dayLabel.text = AppUtils().epochToLocalTime(epochTime: currentData["dt"] as! Int, dateRequired: true)
        let temperatureData = currentData["temp"] as? [String:Any]
        
        let lowTemp = String(format: "%.0f", ((temperatureData!["min"] as! Double) - 273.15))
        let highTemp = String(format: "%.0f", ((temperatureData!["max"] as! Double) - 273.15))
        cell.temperatureLabel.text = "Low \(lowTemp)°     High \(highTemp)°"
        let weather = currentData["weather"] as? [[String:Any]]
        cell.weatherImageView.image = AppUtils().imageForCurrentWeather(weather: weather![0]["main"] as! String)
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
        cell.timeLabel.text = AppUtils().epochToLocalTime(epochTime: currentData["dt"] as! Int, dateRequired: false)
        cell.temperatureLabel.text = "\(String(format: "%.0f", ((currentData["temp"] as! Double) - 273.15)))°"
        let weather = currentData["weather"] as? [[String:Any]]
        cell.weatherImageView.image = AppUtils().imageForCurrentWeather(weather: weather![0]["main"] as! String)
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
            guard let currentLocation else { return }
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
            
            let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(currentLocation.coordinate.latitude)&lon=\(currentLocation.coordinate.longitude)&appid=\(AppUtils.key)"
            fetchWeatherInfo(url: url)
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("restricted")
        case .denied:
            // handle location access if it is denied
            view.addSubview(tempView)
            tempView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
            view.bringSubviewToFront(tempView)
            
            let alertController = UIAlertController (title: "Alert", message: "Allow access to Location Services to continue.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(settingsURL) {
                        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                    }
                }
            }
            alertController.addAction(settingsAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { [weak self] _ in
                guard let self else { return }
                alertController.dismiss(animated: true)
                if let tempView = self.view.viewWithTag(100) {
                    UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseInOut, animations: { () -> Void in
                        tempView.alpha = 0
                    }) { completed in
                        tempView.removeFromSuperview()
                    }
                }
                self.cityLabel.text = "New Delhi, India"
                let url = "https://api.openweathermap.org/data/3.0/onecall?lat=\(28.61)&lon=\(77.20)&appid=\(AppUtils.key)"
                fetchWeatherInfo(url: url)
            }
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension ViewController {
    func fetchWeatherInfo(url: String) {
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
                    currentImageView.image = AppUtils().imageForCurrentWeather(weather: weather[0]["main"] as! String)
                    feelsLikeLabel.text = "Feels like \(String(format: "%.1f", ((currentConditions["feels_like"] as! Double) - 273.15)))°"
                    sunRiseLabel.text = "Sunrise \(AppUtils().epochToLocalTime(epochTime: currentConditions["sunrise"] as! Int, dateRequired: false))"
                    sunSetLabel.text = "Sunset \(AppUtils().epochToLocalTime(epochTime: currentConditions["sunset"] as! Int, dateRequired: false))"
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
    }
}
