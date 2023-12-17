//
//  EditProfileVC.swift
//  AnimalCare
//
//  Created by Sofa on 5.12.23.
//

import UIKit
import Firebase
import FirebaseAuth

class EditProfileVC: UIViewController {
    
    var ref: DatabaseReference!
    
    var email: String = ""
    var password: String = ""
    var role: String = ""
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var surnameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var ageTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var adressTF: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var aboutYourselfTW: UITextView!
    
    /// ДЕТАЛИ
    // выбор услуги
    
    @IBOutlet weak var sitterSwitch: UISwitch!
    @IBOutlet weak var dogwalkerSwitch: UISwitch!
    
    // выбор питомца
    
    @IBOutlet weak var dogSwitch: UISwitch!
    @IBOutlet weak var catSwitch: UISwitch!
    
    // выбор размера питомца
    @IBOutlet weak var smallPetSwitch: UISwitch!
    @IBOutlet weak var mediumPetSwitch: UISwitch!
    @IBOutlet weak var bigPetSwitch: UISwitch!
    @IBOutlet weak var veryBigPetSwitch: UISwitch!
    
    // price
    @IBOutlet weak var priceOfDogwalkingTF: UITextField!
    @IBOutlet weak var priceOfSittingTF: UITextField!
    
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ref = Database.database().reference(withPath: "users")
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        // create new user
//        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
//            if let _ = error {
//                self?.errorLbl.isHidden = false
//            } else if let user = user {
//                let userRef = self?.ref.child(user.user.uid)
//                userRef?.setValue(["email": user.user.email])
//                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
//                    if let _ = error {
//                        self?.errorLbl.isHidden = false
//                    } else if let _ = user {
//                    }
//                }
//            }
//        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    private func setupUI() {
        errorLbl.isHidden = true
        detailsStackView.isHidden = role == Role.client.rawValue
    }
    
    
    
        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
}
