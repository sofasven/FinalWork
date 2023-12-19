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
    
    var email: String?
    var password: String?
    var role: String?
    
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
        guard let email, !email.isEmpty,
              let password, !password.isEmpty,
              let role, !role.isEmpty,
              let name = nameTF.text,
              let surname = surnameTF.text,
              let phoneNumber = phoneNumberTF.text,
              let phoneNumberInt = Int(phoneNumber),
              let age = ageTF.text,
              let ageInt = Int(age),
              let city = cityTF.text,
              let adress = adressTF.text else { return }
        let sex = sexSegmentedControl.selectedSegmentIndex == 0 ? "Женский" : "Мужской"
        let infoAboutYourself = aboutYourselfTW.text.isEmpty ? "" : aboutYourselfTW.text
        // create new user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let _ = error {
                self?.errorLbl.isHidden = false
            } else if let user = user {
                let user = User(uid: user.user.uid, email: email, role: role, name: name, surname: surname, phoneNumber: phoneNumberInt, age: ageInt, city: city, address: adress, sex: sex, avatar: nil, progress: nil, infoAboutYourself: infoAboutYourself, detailsOfWalking: self?.chooseDetails(), reviews: nil)
                let userRef = self?.ref.child(user.uid)
                userRef?.setValue(user.convertToDictionary())
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    if let _ = error {
                        self?.errorLbl.isHidden = false
                    } else if let _ = user {
                    }
                }
            }
        }
    }
    
    
    
    private func chooseDetails() -> Details? {
        let details: Details?
        let priceOfWalk: String? = dogwalkerSwitch.isOn ? priceOfDogwalkingTF.text : nil
        let priceOfSitting: String? = sitterSwitch.isOn ? priceOfSittingTF.text : nil
        if role == Role.dogwalker.rawValue {
            details = Details(typeOfService: chooseTypeOfService(), petType: choosePetType(), petSize: choosePetSize(), priceOfWalk: priceOfWalk, priceOfSitting: priceOfSitting)
        } else {
            details = nil
        }
        return details
    }
    
    private func choosePetSize() -> [PetSize?] {
        let petSize: [PetSize?]
        let small: PetSize? = smallPetSwitch.isOn ? .small : nil
        let medium: PetSize? = mediumPetSwitch.isOn ? .medium : nil
        let big: PetSize? = bigPetSwitch.isOn ? .big : nil
        let veryBig: PetSize? = veryBigPetSwitch.isOn ? .veryBig : nil
        petSize = [small, medium, big, veryBig]
        return petSize
    }
    
    private func choosePetType() -> PetType? {
        let petType: PetType?
        if dogSwitch.isOn,
           catSwitch.isOn {
            petType = .both
        } else if dogSwitch.isOn {
            petType = .dog
        } else if catSwitch.isOn {
            petType = .cat
        } else {
            errorLbl.isHidden = false
            petType = nil
        }
        return petType
    }
    
    private func chooseTypeOfService() -> TypesOfService? {
        let typeOfService: TypesOfService?
        if sitterSwitch.isOn,
           dogwalkerSwitch.isOn {
            typeOfService = .both
        } else if sitterSwitch.isOn {
            typeOfService = .dogsitter
        } else if dogwalkerSwitch.isOn {
            typeOfService = .dogwalker
        } else {
            errorLbl.isHidden = false
            typeOfService = nil
        }
        return typeOfService
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
