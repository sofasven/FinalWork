//
//  SitterProfileVC.swift
//  AnimalCare
//
//  Created by Sofa on 13.01.24.
//

import UIKit
import Firebase
import FirebaseStorage

class SitterProfileVC: UIViewController {
    
    var sitter: User!
    var clientUser: User!
    var fromDate: String?
    var toDate: String?
    var petSize: String?
    var petType: String?
    var typeOfService: String?
    var reviews: [Review]?
    var ref: DatabaseReference!
    var imageRef: StorageReference!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var ratingCountLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    @IBOutlet weak var aboutYourselfLbl: UILabel!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var seeFeedBackBtn: UIButton!
    
    /// details
    @IBOutlet weak var priceOfDogwalking: UILabel!
    @IBOutlet weak var priceOfSittingLbl: UILabel!
    @IBOutlet weak var petTypeLbl: UILabel!
    @IBOutlet weak var petSizeLbl: UILabel!
    
    // stacks
    @IBOutlet weak var walkingStackView: UIStackView!
    @IBOutlet weak var sittingStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        imageRef = Storage.storage().reference().child(sitter.uid)
        activityIndicatorView.startAnimating()
        activityIndicatorView.isHidden = false
        setUpUI()
    }
    
    @IBAction func openReviewsBtn(_ sender: UIButton) {
        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        guard let commentsTVC = stor.instantiateViewController(withIdentifier: "CommentsTVC") as? CommentsTVC else { return }
        commentsTVC.reviews = reviews
        navigationController?.pushViewController(commentsTVC, animated: true)
    }
    
    
    @IBAction func reservationBtn(_ sender: UIButton) {
        //create reservation
        guard let fromDate,
              let toDate,
              let petSize,
              let petType,
              let typeOfService else {
            let alert = UIAlertController(title: "Ошибка", message: "Недостаточно данных", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Назад", style: .cancel)
            alert.addAction(cancel)
            present(alert, animated: true)
            return
        }
        let clientName = clientUser.name
        let clientUid = clientUser.uid
        let dogwalkerName = sitter.name
        let dogwalkerUid = sitter.uid
        let phoneNumberSitter = sitter.phoneNumber
        let price = typeOfService == TypesOfService.dogsitter.rawValue ? sitter.priceOfSitting : sitter.priceOfWalk
        let phoneNumberClient = clientUser.phoneNumber
        let data = "\(typeOfService)\n c \(fromDate) по \(toDate)\n \(petSize)\n \(petType)\n Ситтер: \(phoneNumberSitter)\n Клиент: \(phoneNumberClient)\n \(price ?? "Уточните стоимость услуги")"
        let reservation = Reservation(clientName: clientName, clientUid: clientUid, dogwalkerName: dogwalkerName, dogwalkerUid: dogwalkerUid, phoneNumberSitter: phoneNumberSitter, phoneNumberClient: phoneNumberClient, isCompleted: false, data: data)
        let reservationRef = ref.child(reservation.dogwalkerUid).child("reservations").child(reservation.clientName)
        reservationRef.setValue(reservation.convertToDictionary())
        let reservationClientRef = ref.child(reservation.clientUid).child("reservations").child(reservation.dogwalkerName)
        reservationClientRef.setValue(reservation.convertToDictionary())
        let alert = UIAlertController(title: "Успешно забронировано!", message: data, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Назад", style: .cancel)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    private func setUpUI() {
        let dataManager = DataManager()
        var petSize: String = ""
        if let sitterPetSize = sitter.petSize {
            for size in sitterPetSize {
                petSize += "\n\(size)"
            }
        }
        dataManager.getReviews(userUid: sitter.uid) { [weak self] reviews in
            self?.reviews = reviews
            self?.ratingLbl.text = Calculating.roundRating(reviews: reviews)
            self?.ratingCountLbl.text = "Средняя оценка на основании \(reviews?.count ?? 0) голосов"
            if reviews != nil {
                self?.seeFeedBackBtn.isEnabled = true
            }
        }
        dataManager.getDataImage(imageRef: imageRef) { [weak self] image in
            self?.avatarImageView.image = image ?? #imageLiteral(resourceName: "default-picture_0_0.png")
            self?.activityIndicatorView.stopAnimating()
            self?.activityIndicatorView.isHidden = true
        }
        dataManager.getReservations(userUid: sitter.uid) { [weak self] reservations in
            self?.progressLbl.text = "\(reservations?.count ?? 0) бронирований(-я)"
        }
        nameLbl.text = "\(sitter.name) \(sitter.surname)"
        ageLbl.text = sitter.age
        cityLbl.text = sitter.city
        ratingCountLbl.text = "Средняя оценка на основании \(reviews?.count ?? 0) голосов"
        aboutYourselfLbl.text = sitter.infoAboutYourself
        if sitter.typeOfService == TypesOfService.dogwalker.rawValue {
            priceOfDogwalking.text = sitter.priceOfWalk
        } else {
            walkingStackView.isHidden = true
        }
        if sitter.typeOfService == TypesOfService.dogsitter.rawValue {
            priceOfSittingLbl.text = sitter.priceOfSitting
        } else {
            sittingStackView.isHidden = true
        }
        petTypeLbl.text = sitter.petType
        petSizeLbl.text = petSize
        seeFeedBackBtn.isEnabled = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let feedbackVC = segue.destination as? FeedbackVC else { return }
        feedbackVC.userUid = sitter.uid
        feedbackVC.clientName = clientUser.name
    }
}
