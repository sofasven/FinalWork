//
//  MainVCExt.swift
//  AnimalCare
//
//  Created by Sofa on 5.12.23.
//

import Foundation
import UIKit

extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
    }
}
