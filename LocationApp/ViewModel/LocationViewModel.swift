//
//  LocationViewModel.swift
//  LocationApp
//
//  Created by Shilpa Hayyal on 18/03/21.
//

import Foundation
import CoreLocation

class LocationViewModel:NSObject, CLLocationManagerDelegate {
    
    var previousLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    var previousTime:Date = Date()
    let firebaseStore = FirebaseDataStore()
    var didChangeData: ((LocationStatus) -> Void)?

    var viewLocationData: LocationStatus = LocationStatus() {
        didSet {
            didChangeData?(viewLocationData)
        }
    }
    
    //delegate methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation:CLLocation = locations.last else { return }
        let inMeters = newLocation.distance(from: previousLocation)
        let timeInterval = abs(newLocation.timestamp.timeIntervalSince(previousTime))
        if (Int(inMeters) >= Constants.distanceInMeter ) {
            print("distance:save location")
        }
        else if(timeInterval > 30) {
            print("time:save location")
        } else {
            print("do not save")
            return
        }
        firebaseStore.addLocationToFirebase(location: newLocation)
        self.previousTime = newLocation.timestamp
        self.previousLocation = newLocation
    }
    
    
    func fetchDataListener() {
        firebaseStore.loadData()
    }
    
    func removeListener() {
        firebaseStore.removeListener()
    }
    
    func start() {
        firebaseStore.delegate = self
        didChangeData?(viewLocationData)
    }
}

extension LocationViewModel:locationStatusDelegate {
    
func updateLocationStatus(locationStatus: LocationStatus) {
    self.viewLocationData = locationStatus
}
}
