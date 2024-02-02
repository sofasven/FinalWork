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
    
    var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle!
    
    // MARK: - @IBOutlets
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passTF: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener({ [weak self] _, user in
            guard let _ = user else { return }
            self?.goToProfile()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIWindow.keyboardWillHideNotification, object: nil)
        emailTF.delegate = self
        passTF.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        Auth.auth().removeStateDidChangeListener(authStateDidChangeListenerHandle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLbl.isHidden = true
        emailTF.text = nil
        passTF.text = nil
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
                self?.goToProfile()
            }
        }
    }
    
    
    // MARK: - Privates
    
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
    
    private func goToProfile() {
        let stor = UIStoryboard(name: "ProfileStoryboard", bundle: nil)
        let profileVC = stor.instantiateViewController(withIdentifier: "ProfileVC")
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
