//
//  DataManager.swift
//  AnimalCare
//
//  Created by Sofa on 27.01.24.
//

import UIKit
import Firebase
import FirebaseStorage

class DataManager {
    
    func getReviews(userUid: String, completion: @escaping (([Review]?) -> Void)) {
        let ref = Database.database().reference(withPath: "users").child(userUid).child("reviews")
        var reviews = [Review]()
        ref.observe(.value) { snapshot in
            completion(reviews)
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let review = Review(snapshot: snapshot) else { return }
                reviews.append(review)
                print("\(reviews)")
            }
            completion(reviews)
        }
    }
    
    func putDataImage(imageRef: StorageReference, image: UIImage) {
        guard let imageData = image.pngData() else { return }
        let _ = imageRef.putData(imageData) { _, error in
            print("Error: \(String(describing: error))")
        }
    }
    
    func getDataImage(imageRef: StorageReference, completion: @escaping ((UIImage?) -> Void)) {
        var image: UIImage?
        let _ = imageRef.getData(maxSize: 999999999999999) { data, error in
            if let data = data {
                print("\n data: \n\(data)\n")
                image = UIImage(data: data) ?? nil
            } else {
                print("\n error:\n\(String(describing: error))\n")
            }
            completion(image)
        }
    }
    
    
}


