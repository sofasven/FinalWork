//
//  EditProfileVCExt.swift
//  AnimalCare
//
//  Created by Sofa on 21.01.24.
//

import UIKit

extension EditProfileVC: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
    }
}
