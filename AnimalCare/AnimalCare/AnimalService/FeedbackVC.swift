//
//  FeedbackVC.swift
//  AnimalCare
//
//  Created by Sofa on 13.01.24.
//

import UIKit
import Firebase

class FeedbackVC: UIViewController {
    
    var userUid: String?
    var clientName: String?
    var ref: DatabaseReference!
    
    @IBOutlet weak var textReview: UITextView!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var mark: UISegmentedControl!
    @IBOutlet weak var saveBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        guard let userUid else { return }
        ref = Database.database().reference(withPath: "users").child(userUid).child("reviews")
    }
    
    @IBAction func segmentedControlAction(_ sender: UISegmentedControl) {
        updateSaveBtn()
    }
    
    @IBAction func saveAction(_ sender: UIButton) {
        guard let userUid,
              let clientName else { return }
        let reviewsMark = Double(mark.selectedSegmentIndex + 1)
        let reviewsComment = textReview.text
        let review = Review(userUid: userUid, comment: reviewsComment, mark: reviewsMark, clientName: clientName)
        let reviewRef = self.ref.child(review.clientName)
        reviewRef.setValue(review.convertToDictionary())
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
