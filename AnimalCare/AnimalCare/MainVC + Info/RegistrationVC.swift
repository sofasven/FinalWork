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
    var category: String {
        categorySC.selectedSegmentIndex == 0 ? "users" : "dogwalkers"
    }
    
    // MARK: - @IBOutlets
    @IBOutlet weak var categorySC: UISegmentedControl!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        ref = Database.database().reference(withPath: category)
    }
    
    // MARK: - @IBAction
    @IBAction func registrationAction(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let password = passTF.text, !password.isEmpty else { return }
        // create new user
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
            if let user = user {
                let userRef = self?.ref.child(user.user.uid)
                userRef?.setValue(["email": user.user.email])
                self?.navigationController?.popToRootViewController(animated: true)
            } else if let _ = error {
                self?.errorLbl.isHidden = false
            }
        }
    }
    
    // MARK: - Privates
    private func setupUI() {
        errorLbl.isHidden = true
    }

}
