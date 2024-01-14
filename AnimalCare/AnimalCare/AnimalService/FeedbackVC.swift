//
//  FeedbackVC.swift
//  AnimalCare
//
//  Created by Sofa on 13.01.24.
//

import UIKit

class FeedbackVC: UIViewController {
    
    var index: Int?
    
    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var mark: UISegmentedControl!
    @IBOutlet weak var saveBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        updateSaveBtn()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let indexPath = index else { return }
        let review = Review(comment: textReview.text, mark: Double(mark.selectedSegmentIndex + 1))
        SittersData.shared.sitters[indexPath].reviews?.append(review)
        navigationController?.popViewController(animated: true)
    }
    
    private func setupUI() {
        saveBtn.isEnabled = false
        errorLbl.isHidden = true
        mark.selectedSegmentIndex = .max
        textReview.backgroundColor = .lightGray
        textReview.textColor = .black
    }
    private func updateSaveBtn() {
        let numberOfCharacters = textReview.text.description.count
        saveBtn.isEnabled = numberOfCharacters > 20
        errorLbl.isHidden = numberOfCharacters > 20
    }
}
