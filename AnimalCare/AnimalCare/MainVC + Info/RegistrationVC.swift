//
//  RegistrationVC.swift
//  AnimalCare
//
//  Created by Sofa on 30.11.23.
//

import UIKit
import Firebase

class RegistrationVC: UIViewController {
    
    var ref: DatabaseReference!
    
    // MARK: - @IBOutlets
    @IBOutlet weak var categorySC: UISegmentedControl!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ref = Database.database().reference(withPath: "users")
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        emailTF.delegate = self
        passTF.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - @IBAction
    @IBAction func registrationAction(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passTF.text, !password.isEmpty else { return }
        // create new user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let _ = error {
                self?.errorLbl.isHidden = false
            } else if let user = user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
                Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                    if let _ = error {
                        self?.errorLbl.isHidden = false
                    } else if let _ = user {
                        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
                        let editProfileVC = stor.instantiateViewController(withIdentifier: "EditProfileVC")
                        self?.navigationController?.pushViewController(editProfileVC, animated: true)
                    }
                }
            }
        }
    }
    
    // MARK: - Privates
    private func setupUI() {
        errorLbl.isHidden = true
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
