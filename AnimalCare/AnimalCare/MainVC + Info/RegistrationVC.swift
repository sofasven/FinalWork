//
//  RegistrationVC.swift
//  AnimalCare
//
//  Created by Sofa on 30.11.23.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    var role: String = ""
    
    // MARK: - @IBOutlets
    @IBOutlet weak var categorySC: UISegmentedControl!
    // email
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var errorEmailLbl: UILabel!
    // password
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var errorPassLbl: UILabel!
    //strongPassIndicatorsViews
    @IBOutlet var strongPassIndicatorsViews: [UIView]!
    //confPass
    @IBOutlet weak var confPassTF: UITextField!
    @IBOutlet weak var errorConfPassLbl: UILabel!
    //Btn
    @IBOutlet weak var registrationBtn: UIButton!
    
    private var isValidEmail = false { didSet { updateRegistrationBtnState() } }
    private var isConfPass = false { didSet { updateRegistrationBtnState() } }
    private var passwordStrength: PasswordStrength = .veryWeak { didSet { updateRegistrationBtnState() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        emailTF.delegate = self
        passTF.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @IBActions
    @IBAction func emailTFAction(_ sender: UITextField) {
        if let email = sender.text,
           !email.isEmpty,
           VerificationService.isValidEmail(email: email) {
            isValidEmail = true
        } else {
            isValidEmail = false
        }
        errorEmailLbl.isHidden = isValidEmail
    }
    
    @IBAction func passTFAction(_ sender: UITextField) {
        if let passText = sender.text,
           !passText.isEmpty {
            passwordStrength = VerificationService.isValidPassword(pass: passText)
            print(passwordStrength)
        } else {
            passwordStrength = .veryWeak
        }
        errorPassLbl.isHidden = passwordStrength != .veryWeak
    
        setupStrongIndicatorsViews()
    }
    
    @IBAction func confPassTFAction(_ sender: UITextField) {
        if let confPassText = sender.text,
           !confPassText.isEmpty,
           let passText = passTF.text,
           !passText.isEmpty {
            isConfPass = VerificationService.isPassConfirm(pass1: passText, pass2: confPassText)
        } else {
            isConfPass = false
        }
        errorConfPassLbl.isHidden = isConfPass
    }
    
    @IBAction func registrationAction(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passTF.text, !password.isEmpty else { return }
        role = categorySC.selectedSegmentIndex == 0 ? Role.client.rawValue : Role.dogwalker.rawValue
        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        guard let editProfileVC = stor.instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC else { return }
        editProfileVC.email = email
        editProfileVC.password = password
        editProfileVC.role = role
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
    
    private func setupStrongIndicatorsViews() {
        strongPassIndicatorsViews.enumerated().forEach { index, view in
            if index <= (passwordStrength.rawValue - 1) {
                view.alpha = 1
            } else {
                view.alpha = 0.2
            }
        }
    }
    
    private func updateRegistrationBtnState() {
        registrationBtn.isEnabled = isValidEmail && isConfPass && passwordStrength != .veryWeak
    }
    
    // MARK: - Privates
    private func setupUI() {
        errorEmailLbl.isHidden = true
        errorPassLbl.isHidden = true
        errorConfPassLbl.isHidden = true
        registrationBtn.isEnabled = false
        strongPassIndicatorsViews.forEach { view in view.alpha = 0.2 }
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
