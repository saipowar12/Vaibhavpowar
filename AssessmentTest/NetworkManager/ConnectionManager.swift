//
//  ConnectionManager.swift
//  AssessmentTest
//
//  Created by Viabhav Powar on 23/05/22.
//

import Foundation
import UIKit
class ConnectionManager {

    static let shared = ConnectionManager()
    private init () {}

    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            }
        }
        catch {
            return false
        }
    }
}

