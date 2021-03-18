//
//  LocationInfo.swift
//  LocationApp
//
//  Created by Shilpa Hayyal on 18/03/21.
//

import Foundation
import FirebaseFirestore

struct LocationInfo {

    let createdAt:Date
    let location:GeoPoint
    
    var dictionary:[String:Any] {
        return [
            
            "createdAt":createdAt,
            "location":location ]
    }
}
    
    
