//
//  LocationViewController.swift
//  LocationApp
//
//  Created by Shilpa Hayyal on 17/03/21.
//

import UIKit
import MapKit
import CoreLocation


class LocationViewController: UIViewController {
   
    var viewModel = LocationViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Location App"
        }
    
    override func viewDidAppear(_ animated: Bool) {
        self.determineCurrentLocation()
    }
    
   @IBOutlet private weak var mapView:MKMapView!
    
    @IBAction func showUploadStatus(sender:Any) {
        let viewController = ShowLocationUpdateViewController.instantiate()
        viewController.viewModel = viewModel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    
    fileprivate var locationManager:CLLocationManager!

    func determineCurrentLocation() {

        locationManager = CLLocationManager()
        locationManager.delegate = viewModel
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()

        mapView.showsUserLocation = true
        locationManager!.allowsBackgroundLocationUpdates = false
        locationManager!.pausesLocationUpdatesAutomatically = false
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        
    }
    

}

