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
    
    var user: User?

    //@IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameSurnameLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var starsLbl: UILabel!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var countReviewsLbl: UILabel!
    @IBOutlet weak var aboutYourselfLbl: UILabel!
    
    //progress
    @IBOutlet weak var countPetsitting: UILabel!
    @IBOutlet weak var countDogwalking: UILabel!
    
    //details
    @IBOutlet weak var priceDogwalkingLbl: UILabel!
    @IBOutlet weak var pricePetsittingLbl: UILabel!
    @IBOutlet weak var petTypeLbl: UILabel!
    @IBOutlet weak var petSizeLbl: UILabel!
    
    // stacks
    @IBOutlet weak var stackViewCalendar: UIStackView!
    @IBOutlet weak var progressStackView: UIStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func setupUI() {
        guard let user = user else { return }
        stackViewCalendar.isHidden = user.role == Role.client.rawValue
        progressStackView.isHidden = user.role == Role.client.rawValue
        detailsStackView.isHidden = user.role == Role.client.rawValue
        avatarImageView.image = user.avatar ?? #imageLiteral(resourceName: "default-picture_0_0.png")
        nameSurnameLbl.text = "\(user.name) \(user.surname)"
        ageLbl.text = "\(user.age)"
        cityLbl.text = user.city
        aboutYourselfLbl.text = user.infoAboutYourself
        pricePetsittingLbl.text = user.detailsOfWalking?.priceOfSitting
        priceDogwalkingLbl.text = user.detailsOfWalking?.priceOfWalk
        petTypeLbl.text = "\(user.detailsOfWalking?.petType ?? .cat )"
        petSizeLbl.text = "\(user.detailsOfWalking?.petSize ?? [.small])"
        countReviewsLbl.text = "Средняя оценка на основании \(user.reviews?.count ?? 0) голосов"
    }
    
}
