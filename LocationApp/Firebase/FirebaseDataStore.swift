//
//  FirebaseDataStore.swift
//  LocationApp
//
//  Created by Shilpa Hayyal on 18/03/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import CoreLocation

protocol locationStatusDelegate {
    func updateLocationStatus(locationStatus:LocationStatus)
}
class FirebaseDataStore: NSObject {

    var firestore: Firestore!
    var listener:ListenerRegistration!
    var delegate: locationStatusDelegate!
    
    override init() {
        super.init()
        firestore = Firestore.firestore()
    }
    
    fileprivate func baseLocationCollection() -> CollectionReference? {
        
        let collection = Firestore.firestore().collection("MyLocations")
        return collection
    }
    
    fileprivate func baseStatusCollection() -> CollectionReference? {
        let collection = Firestore.firestore().collection("Today")
        return collection
    }
    
    func addLocationToFirebase(location:CLLocation) {
        var ref: DocumentReference?
        let collection = self.baseLocationCollection()
        
        let coordinates:CLLocationCoordinate2D = location.coordinate
        
        let locationGeoPoint = GeoPoint(latitude:coordinates.latitude,longitude:coordinates.longitude)
        let newLocation = LocationInfo(createdAt: location.timestamp, location: locationGeoPoint)

        ref = collection?.addDocument(data: newLocation.dictionary) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                self.updateCount(location.timestamp)
            }
        }
                
    }
    
    func updateCount(_ time:Date) {
        let collection = self.baseStatusCollection()
        let sfRef = collection?.document("status")
        //test if day is modified
        //let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!

        if(Date.compareDate(date1: time, date2: Date())) {
            sfRef?.updateData([
                "count": FieldValue.increment(Int64(1)),
                "lastUpdated": time
            ])
        } else {
            sfRef?.setData([
                "count": 1,
                "lastUpdated": time
            ])
        }
    }
    
    
   
     func loadData() {
        let collection = self.baseStatusCollection()
        var newLocationStatus:LocationStatus = LocationStatus()
        
        self.listener = collection?.document("status")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                print("Current data: \(data)")
                if let date = data["lastUpdated"] {
                    newLocationStatus.lastUpdated = (date as AnyObject).dateValue()
                }
                if let total = data["count"] {
                    newLocationStatus.count = total as? Int ?? 0
                }
                if let statusDelegate = self.delegate {
                    statusDelegate.updateLocationStatus(locationStatus:newLocationStatus)
                }
                print("last updated \(String(describing: newLocationStatus.lastUpdated)), \(String(describing: newLocationStatus.count))")
            }

    }
    
    func removeListener() {
        self.listener.remove()
        self.listener = nil
    }
    
}
