//
//  SittersData.swift
//  AnimalCare
//
//  Created by Sofa on 13.01.24.
//

import UIKit

class SittersData {
    
    static let shared = SittersData(sitters: [])
    
    var sitters: [User]
    
    private init(sitters: [User]) {
        self.sitters = sitters
    }
    
}
