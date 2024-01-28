//
//  ListOfSittersTVC.swift
//  AnimalCare
//
//  Created by Sofa on 13.01.24.
//

import UIKit
import Firebase
import FirebaseStorage

class ListOfSittersTVC: UITableViewController {
    
    var clientAdress: String?
    var fromDate: String?
    var toDate: String?
    var clientUser: User!
    var imageRef: StorageReference!
    var sitters: [User] = [] { didSet { tableView.reloadData() }}
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "ListOfSittersTVCell", bundle: nil), forCellReuseIdentifier: "CellForListOfSitters")
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sitters.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForListOfSitters", for: indexPath) as! ListOfSittersTVCell
        let sitter = sitters[indexPath.row]
        imageRef = Storage.storage().reference().child(sitter.uid)
        let dataManager = DataManager()
        cell.activityIndicatorView.startAnimating()
        cell.activityIndicatorView.isHidden = false
        let reviews = dataManager.getReviews(userUid: sitter.uid)
        cell.avatarImageView.image = dataManager.getDataImage(imageRef: imageRef, avatar: cell.avatarImageView, activityIV: cell.activityIndicatorView)
        cell.nameLbl.text = sitter.name
        cell.ratingLbl.text = Calculating.roundRating(reviews: reviews)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sitter = sitters[indexPath.row]
        performSegue(withIdentifier: "goToSitterProfile", sender: nil)
    }

    
    deinit {
        print("ListOfSittersTVC deinit")
    }
}
