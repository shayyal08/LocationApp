//
//  Storyboarded.swift
//  Staytion
//
//  Created by Shilpa Hayyal on 17/03/20.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullname = NSStringFromClass(self)
        let className = fullname.components(separatedBy: ".")[1]
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        return storyboard.instantiateViewController(identifier: className) as! Self
    }
    
}

