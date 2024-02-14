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
    
    var fromDate: String?
    var toDate: String?
    var petSize: String?
    var petType: String?
    var typeOfService: String?
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
        dataManager.getReviews(userUid: sitter.uid) { reviews in
            cell.ratingLbl.text = Calculating.roundRating(reviews: reviews)
        }
        dataManager.getDataImage(imageRef: imageRef) { image in
            cell.avatarImageView.image = image ?? #imageLiteral(resourceName: "default-picture_0_0.png")
            cell.activityIndicatorView.stopAnimating()
            cell.activityIndicatorView.isHidden = true
        }
        cell.nameLbl.text = sitter.name
        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stor = UIStoryboard(name: "ServiceStoryboard", bundle: nil)
        guard let sitterProfileVC = stor.instantiateViewController(withIdentifier: "SitterProfileVC") as? SitterProfileVC else { return }
            let sitter = sitters[indexPath.row]
        sitterProfileVC.sitter = sitter
        sitterProfileVC.clientUser = clientUser
        sitterProfileVC.fromDate = fromDate
        sitterProfileVC.toDate = toDate
        sitterProfileVC.petSize = petSize
        sitterProfileVC.petType = petType
        sitterProfileVC.typeOfService = typeOfService
        navigationController?.pushViewController(sitterProfileVC, animated: true)
        }

    deinit {
        print("ListOfSittersTVC deinit")
    }
}
