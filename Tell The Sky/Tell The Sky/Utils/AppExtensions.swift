//
//  AppExtensions.swift
//  Tell The Sky
//
//  Created by Arjun Mohan on 26/11/22.
//

import Foundation
import UIKit


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
        
//        // Location access
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.delegate = self
        
        dateLabel.text = AppUtils().getLocalDate()
        
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
