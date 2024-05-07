//
//  Locator.swift
//  AccessEMR
//
//  Created by Vasundhara Mehta on 06/08/20.
//  Copyright © 2020 smartData Enterprises (I) Ltd. All rights reserved.
//

import UIKit
enum ResultLocator <T> {
    case Success(T)
    case Failure(Error)
}

class Locator: NSObject, CLLocationManagerDelegate {
    
    static let shared: Locator = Locator()
    
    /*
    typealias Callback = (ResultLocator <Locator>) -> Void
    
    var requests: Array <Callback> = Array <Callback>()
    
    var location: CLLocation? { return sharedLocationManager.location  }
    
    lazy var sharedLocationManager: CLLocationManager = {
        let newLocationmanager = CLLocationManager()
        newLocationmanager.delegate = self
        // ...
        return newLocationmanager
    }()
    
    // MARK: - Authorization
    
    class func authorize() { shared.authorize() }
    func authorize() { sharedLocationManager.requestWhenInUseAuthorization() }
    
    // MARK: - Helpers
    
    func locate( callback: Callback) {
        self.requests.append(callback)
        sharedLocationManager.startUpdatingLocation()
    }
    
    func reset() {
        self.requests = Array <Callback>()
        sharedLocationManager.stopUpdatingLocation()
    }
    // MARK: - Delegate
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        for request in self.requests { request(.Failure(error)) }
        self.reset()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: Array <CLLocation>) {
        for request in self.requests { request(.Success(self)) }
        self.reset()
    }
    */
}

//HOW TO USE
/*
 
 Locator.shared.locate { result in
   switch result {
   case .Success(locator):
     if let location = locator.location { /* ... */ }
   case .Failure(error):
     /* ... */
   }
 }

 */
