//
//  MainVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import UIKit

class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - @IBActions
    @IBAction func registrationAction(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func signInAction(_ sender: UIButton) {
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    private func alertForRegistrationAndSignIn(title: String) {
        
        let alert = UIAlertController(title: title, message: "Введите данные", preferredStyle: .alert)
        var phoneTF: UITextField!
        var passTF: UITextField!
        
        alert.addTextField { textField in
            phoneTF = textField
            phoneTF.placeholder = "Введите ваш номер телефона"
        }
        alert.addTextField { textField in
            passTF = textField
            passTF.placeholder = "Введите пароль"
        }
    }
}
