//
//  ProfileVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import UIKit
import Firebase
import FirebaseAuth

class ProfileVC: UIViewController {
    
    var user: User!
    
    //@IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameSurnameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var countReviewsLbl: UILabel!
    @IBOutlet weak var aboutYourselfLbl: UILabel!
    @IBOutlet weak var openCommentsBtn: UIButton!
    @IBOutlet weak var searchSitterBtn: UIButton!
    
    //progress
    @IBOutlet weak var countPetsitting: UILabel!
    @IBOutlet weak var countDogwalking: UILabel!
    
    //details
    @IBOutlet weak var priceDogwalkingLbl: UILabel!
    @IBOutlet weak var pricePetsittingLbl: UILabel!
    @IBOutlet weak var petTypeLbl: UILabel!
    @IBOutlet weak var petSizeLbl: UILabel!
    
    // stacks
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func changePhoto(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    @IBAction func signOutAction() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
        let stor = UIStoryboard(name: "Main", bundle: nil)
        guard let mainVC = stor.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
        self.navigationController?.pushViewController(mainVC, animated: true)
    }
    
    
    @IBAction func deleteUserAction() {
        guard let user = Firebase.Auth.auth().currentUser else { return }
        user.delete { _ in 
            let stor = UIStoryboard(name: "Main", bundle: nil)
            guard let mainVC = stor.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
            self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    @IBAction func searchSitterAction(_ sender: UIButton) {
        let stor = UIStoryboard(name: "ServiceStoryboard", bundle: nil)
        guard let serviceVC = stor.instantiateViewController(withIdentifier: "ServiceVC") as? ServiceVC else { return }
        serviceVC.user = user
        self.navigationController?.pushViewController(serviceVC, animated: true)
    }
    
    @IBAction func seeFeedback() {
        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        guard let commentsTVC = stor.instantiateViewController(withIdentifier: "CommentsTVC") as? CommentsTVC else { return }
        commentsTVC.user = user
        self.navigationController?.pushViewController(commentsTVC, animated: true)
    }

    private func setupUI() {
        guard let user = user else { return }
        progressStackView.isHidden = user.role == Role.client.rawValue
        detailsStackView.isHidden = user.role == Role.client.rawValue
        openCommentsBtn.isHidden = user.role == Role.client.rawValue
        searchSitterBtn.isHidden = user.role == Role.dogwalker.rawValue
        avatarImageView.image = user.avatar ?? #imageLiteral(resourceName: "default-picture_0_0.png")
        nameSurnameLbl.text = "\(user.name) \(user.surname)"
        ageLbl.text = "\(user.age)"
        cityLbl.text = user.city
        starsLbl.text = Calculating.roundRating(user: user)
        aboutYourselfLbl.text = user.infoAboutYourself
        pricePetsittingLbl.text = user.detailsOfWalking?.priceOfSitting
        priceDogwalkingLbl.text = user.detailsOfWalking?.priceOfWalk
        petTypeLbl.text = "\(user.detailsOfWalking?.petType ?? .cat )"
        petSizeLbl.text = "\(user.detailsOfWalking?.petSize ?? [.small])"
        countReviewsLbl.text = "Средняя оценка на основании \(user.reviews?.count ?? 0) голосов"
    }
    
}
