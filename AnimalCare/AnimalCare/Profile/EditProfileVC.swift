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
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        nameTF.delegate = self
        surnameTF.delegate = self
        phoneNumberTF.delegate = self
        ageTF.delegate = self
        cityTF.delegate = self
        adressTF.delegate = self
        priceOfDogwalkingTF.delegate = self
        priceOfSittingTF.delegate = self
        aboutYourselfTW.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let email, !email.isEmpty,
              let password, !password.isEmpty,
              let role, !role.isEmpty,
              let name = nameTF.text,
              let surname = surnameTF.text,
              let phoneNumber = phoneNumberTF.text,
              let age = ageTF.text,
              let city = cityTF.text,
              let adress = adressTF.text else {
            errorLbl.isHidden = false
            return
        }
        let sex = sexSegmentedControl.selectedSegmentIndex == 0 ? "Женский" : "Мужской"
        let infoAboutYourself = aboutYourselfTW.text
        // create new user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let _ = error {
                self?.errorLbl.isHidden = false
            } else if let user = user {
                let someUser = User(uid: user.user.uid, email: email, role: role, name: name, surname: surname, phoneNumber: phoneNumber, age: age, city: city, address: adress, sex: sex, avatar: nil, progressOfWalking: nil, progressOfSitting: nil, infoAboutYourself: infoAboutYourself, typeOfService: self?.chooseTypeOfService(), petType: self?.choosePetType(), petSize: self?.choosePetSize(), priceOfWalk: self?.choosePriceOfWalk(), priceOfSitting: self?.choosePriceOfSitting())
                let userRef = self?.ref.child(someUser.uid)
                userRef?.setValue(someUser.convertToDictionary())
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    if let _ = error {
                        self?.errorLbl.isHidden = false
                    } else if let user = user {
                        print(user.user)
                        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
                        guard let profileVC = stor.instantiateViewController(withIdentifier: "ProfileVC") as? ProfileVC
                        else {
                            print("Failed to create ProfileVC")
                            return
                        }
                        self?.navigationController?.pushViewController(profileVC, animated: true)
                    }
                }
            }
        }
    }
    
    
    
    private func choosePriceOfSitting() -> String? {
        let priceOfSitting: String? = sitterSwitch.isOn ? priceOfSittingTF.text : nil
        return priceOfSitting
    }
    private func choosePriceOfWalk() -> String? {
            let priceOfWalk: String? = dogwalkerSwitch.isOn ? priceOfDogwalkingTF.text : nil
        return priceOfWalk
    }
    
    private func choosePetSize() -> [String]? {
        var petSize: [String] = []
        if smallPetSwitch.isOn {
            petSize.append(PetSize.small.rawValue)
        }
        if mediumPetSwitch.isOn {
            petSize.append(PetSize.medium.rawValue)
        }
        if bigPetSwitch.isOn {
            petSize.append(PetSize.big.rawValue)
        }
        if veryBigPetSwitch.isOn {
            petSize.append(PetSize.veryBig.rawValue)
        }
        guard !petSize.isEmpty else { return nil }
        return petSize
    }
    
    private func choosePetType() -> String? {
        let petType: String?
        if dogSwitch.isOn,
           catSwitch.isOn {
            petType = PetType.both.rawValue
        } else if dogSwitch.isOn {
            petType = PetType.dog.rawValue
        } else if catSwitch.isOn {
            petType = PetType.cat.rawValue
        } else {
            errorLbl.isHidden = false
            petType = nil
        }
        return petType
    }
    
    private func chooseTypeOfService() -> String? {
        let typeOfService: String?
        if sitterSwitch.isOn,
           dogwalkerSwitch.isOn {
            typeOfService = TypesOfService.both.rawValue
        } else if sitterSwitch.isOn {
            typeOfService = TypesOfService.dogsitter.rawValue
        } else if dogwalkerSwitch.isOn {
            typeOfService = TypesOfService.dogwalker.rawValue
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
    
    
    @objc
    private func kbWillShow(notification: Notification){
        view.frame.origin.y = 0
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            view.frame.origin.y -= keyboardSize.height / 2
        }
    }
    
    @objc
    private func kbWillHide(){
        view.frame.origin.y = 0
   }
}
