//
//  Review.swift
//  AnimalCare
//
//  Created by Sofa on 24.01.24.
//

import Foundation
import Firebase

struct Review {
    let userUid: String
    let clientName: String
    let comment: String?
    let mark: Double
    let ref: DatabaseReference!
    
    
    init(userUid: String, comment: String?, mark: Double, clientName: String) {
        self.userUid = userUid
        self.comment = comment
        self.mark = mark
        self.clientName = clientName
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let snapshotValue = snapshot.value as? [String: Any],
              let comment = snapshotValue[Constants.commentKey] as? String?,
              let userUid = snapshotValue[Constants.userUidKey] as? String,
              let clientName = snapshotValue[Constants.clientName] as? String,
              let mark = snapshotValue[Constants.markKey] as? Double else { return nil }
        self.comment = comment
        self.userUid = userUid
        self.mark = mark
        self.clientName = clientName
        self.ref = snapshot.ref
    }
    
    func convertToDictionary() -> [String: Any] {
        [Constants.userUidKey: userUid,
         Constants.commentKey: comment,
         Constants.clientName: clientName,
         Constants.markKey: mark]
    }
    
    private enum Constants {
        static let userUidKey = "userId"
        static let commentKey = "comment"
        static let markKey = "mark"
        static let clientName = "clientName"
        
    }
}
