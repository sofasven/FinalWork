//
//  MainVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import UIKit
import Firebase
import FirebaseAuth

class MainVC: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - @IBAction
    
    @IBAction func signInAction(_ sender: UIButton) {
        guard let email = emailTF.text, !email.isEmpty,
              let pass = passTF.text, !pass.isEmpty
        else {
            errorLbl.isHidden = false
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: pass) { [weak self] user, error in
            if let _ = error {
                self?.errorLbl.isHidden = false
            } else if let _ = user {
                // переход на другой экран
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    // MARK: - Privates
    private func setupUI() {
        errorLbl.isHidden = true
    }
}
