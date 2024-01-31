//
//  ProfileVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class ProfileVC: UIViewController {
    
    var user: User?
    var ref: DatabaseReference!
    var imageRef: StorageReference!
    let dataManager = DataManager()
    var reservations: [Reservation]?
    var reviews: [Review]?
    
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
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var reservationsBtn: UIButton!
    
    @IBOutlet weak var seeFeedBackBtn: UIButton!
    
    //progress
    @IBOutlet weak var countDogwalking: UILabel!
    
    //details
    @IBOutlet weak var priceDogwalkingLbl: UILabel!
    @IBOutlet weak var pricePetsittingLbl: UILabel!
    @IBOutlet weak var petTypeLbl: UILabel!
    @IBOutlet weak var petSizeLbl: UILabel!
    
    // stacks
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    @IBOutlet weak var commonStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = Auth.auth().currentUser else { return }
        ref = Database.database().reference(withPath: "users").child(currentUser.uid)
        
        let storageRef = Storage.storage().reference()
        let imageKey = currentUser.uid
        imageRef = storageRef.child(imageKey)
        firstSetupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // наблюдатель за значениями
        ref.observe(.value) { [weak self] snapshot in
            print(snapshot)
            guard let user = User(snapshot: snapshot) else {
                print("Can't create user")
                return }
            self?.user = user
            self?.setupUI()
        }
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
    
    
    @IBAction func reservationsBtnAction() {
    }
    
    
    @IBAction func deleteUserAction() {
        guard let user = Firebase.Auth.auth().currentUser else { return }
        user.delete { _ in
            do {
                try Auth.auth().signOut()
            } catch {
                print(error)
            }
            let stor = UIStoryboard(name: "Main", bundle: nil)
            guard let mainVC = stor.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
            self.navigationController?.pushViewController(mainVC, animated: true)
//            let stor = UIStoryboard(name: "Main", bundle: nil)
//            guard let mainVC = stor.instantiateViewController(withIdentifier: "MainVC") as? MainVC else { return }
//            self.navigationController?.pushViewController(mainVC, animated: true)
        }
    }
    
    @IBAction func searchSitterAction(_ sender: UIButton) {
        let stor = UIStoryboard(name: "ServiceStoryboard", bundle: nil)
        guard let serviceVC = stor.instantiateViewController(withIdentifier: "ServiceVC") as? ServiceVC else { return }
        serviceVC.clientUser = user
        self.navigationController?.pushViewController(serviceVC, animated: true)
    }
    
    @IBAction func seeFeedback() {
        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        guard let commentsTVC = stor.instantiateViewController(withIdentifier: "CommentsTVC") as? CommentsTVC else { return }
        commentsTVC.reviews = reviews
        self.navigationController?.pushViewController(commentsTVC, animated: true)
    }

    private func setupUI() {
        guard let user = user else { return }
        var petSize: String = ""
        if let userPetSize = user.petSize {
            for size in userPetSize {
                petSize += "\n\(size)"
            }
        }
        dataManager.getReviews(userUid: user.uid) { [weak self] reviews in
            self?.reviews = reviews
            self?.starsLbl.text = Calculating.roundRating(reviews: reviews)
            self?.countReviewsLbl.text = "Средняя оценка на основании \(reviews?.count ?? 0) голосов"
            if reviews != nil {
                self?.seeFeedBackBtn.isEnabled = true
            }
        }
        dataManager.getDataImage(imageRef: imageRef) { [weak self] image in
            self?.avatarImageView.image = image ?? #imageLiteral(resourceName: "default-picture_0_0.png")
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
        }
        progressStackView.isHidden = user.role == Role.client.rawValue
        detailsStackView.isHidden = user.role == Role.client.rawValue
        openCommentsBtn.isHidden = user.role == Role.client.rawValue
        searchSitterBtn.isHidden = user.role == Role.dogwalker.rawValue
        nameSurnameLbl.text = "\(user.name) \(user.surname)"
        ageLbl.text = "\(user.age)"
        cityLbl.text = user.city
        countDogwalking.text = "\(reservations?.count ?? 0) бронирований(-я)"
        aboutYourselfLbl.text = user.infoAboutYourself
        pricePetsittingLbl.text = user.priceOfSitting
        priceDogwalkingLbl.text = user.priceOfWalk
        petTypeLbl.text = user.petType
        petSizeLbl.text = petSize
        seeFeedBackBtn.isEnabled = false
        commonStackView.isHidden = false
    }
    
    private func firstSetupUI() {
        commonStackView.isHidden = true
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
    }
    
}
