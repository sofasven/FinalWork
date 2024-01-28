//
//  Reservation.swift
//  AnimalCare
//
//  Created by Sofa on 27.01.24.
//

import UIKit
import Firebase

struct Reservation {
    
    let clientName: String
    let clientUid: String
    let dogwalkerName: String
    let dogwalkerUid: String
    let data: String
    let ref: DatabaseReference!
    
    init(clientName: String, clientUid: String, dogwalkerName: String, dogwalkerUid: String, data: String) {
        self.clientName = clientName
        self.clientUid = clientUid
        self.dogwalkerName = dogwalkerName
        self.dogwalkerUid = dogwalkerUid
        self.data = data
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any],
              let clientName = snapshotValue[Constants.clientName] as? String,
              let clientUid = snapshotValue[Constants.clientUid] as? String,
              let dogwalkerName = snapshotValue[Constants.dogwalkerName] as? String,
              let dogwalkerUid = snapshotValue[Constants.dogwalkerUid] as? String,
              let data = snapshotValue[Constants.data] as? String else { return nil }
        self.clientName = clientName
        self.clientUid = clientUid
        self.dogwalkerName = dogwalkerName
        self.dogwalkerUid = dogwalkerUid
        self.data = data
        self.ref = snapshot.ref
    }
    
    func convertToDictionary() -> [String: Any] {
        [Constants.clientName: clientName,
         Constants.clientUid: clientUid,
         Constants.dogwalkerName: dogwalkerName,
         Constants.dogwalkerUid: dogwalkerUid,
         Constants.data: data]
    }
    
    private enum Constants {
        static let clientName = "clientName"
        static let clientUid = "clientUid"
        static let dogwalkerName = "dogwalkerName"
        static let dogwalkerUid = "dogwalkerUid"
        static let data = "data"
        
    }
    
    
}
