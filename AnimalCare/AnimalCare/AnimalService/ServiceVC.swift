//
//  ServiceVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import UIKit
import FSCalendar
import Firebase

class ServiceVC: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    
    var clientUser: User!
    var calendar: FSCalendar!
    var formatter = DateFormatter()
    var dateSelected: String = ""
    var ref: DatabaseReference!
    var sitters: [User] = []
    
    @IBOutlet weak var petTypeSC: UISegmentedControl!
    @IBOutlet weak var typeOfServiceSC: UISegmentedControl!
    @IBOutlet weak var petSizeSC: UISegmentedControl!
    @IBOutlet weak var viewCalendar: UIView!
    @IBOutlet weak var fromDateBtn: UIButton!
    @IBOutlet weak var toDateBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference(withPath: "users")
        calendarSetUp()
    }

    
    @IBAction func fromDate(_ sender: UIButton) {
        fromDateBtn.setTitle(dateSelected, for: .normal)
    }
    
    @IBAction func toDateAction(_ sender: UIButton) {
        toDateBtn.setTitle(dateSelected, for: .normal)
    }
    
    
    
    @IBAction func searchSitter(_ sender: UIButton) {
      //  getSitters()
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let listOfSittersTVC = segue.destination as? ListOfSittersTVC else { return }
        let petType = petTypeSC.selectedSegmentIndex == 0 ? PetType.dog.rawValue : PetType.cat.rawValue
        let typeOfService = typeOfServiceSC.selectedSegmentIndex == 0 ? TypesOfService.dogsitter.rawValue : TypesOfService.dogwalker.rawValue
        let petSize = choosePetSize()
        var users = [User]()
        ref.observe(.value) { [weak self] snapshot in
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let user = User(snapshot: snapshot)
                else {
                    print("Can't get user")
                    return
                }
                users.append(user)
                print("\(users)")
            }
            for user in users {
                if let userPetSize = user.petSize,
                   let petSize,
                   user.petType == petType || user.petType == PetType.both.rawValue,
                   userPetSize.contains(petSize),
                   user.typeOfService == typeOfService || user.typeOfService == TypesOfService.both.rawValue {
                    self?.sitters.append(user)
                } else {
                    print("There is no such user")}
            }
            listOfSittersTVC.sitters = self?.sitters ?? []
        }
        listOfSittersTVC.sitters = sitters
        listOfSittersTVC.typeOfService = typeOfService
        listOfSittersTVC.petType = petType
        listOfSittersTVC.petSize = petSize
        listOfSittersTVC.toDate = toDateBtn.currentTitle
        listOfSittersTVC.fromDate = fromDateBtn.currentTitle
        listOfSittersTVC.clientUser = clientUser
    }

    
    private func calendarSetUp() {
        calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: Int(viewCalendar.frame.size.width), height: Int(viewCalendar.frame.size.height)))
        calendar.scrollDirection = .horizontal
        calendar.scope = .month
        viewCalendar.addSubview(calendar)
      //  self.view.addSubview(calendar)
        calendar.delegate = self
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        formatter.dateFormat = "dd-MMM-yyyy"
        dateSelected = formatter.string(from: date)
        print(dateSelected)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    private func choosePetSize() -> String? {
        var petSize: String = ""
        if petSizeSC.selectedSegmentIndex == 0 {
            petSize = PetSize.small.rawValue
        } else if petSizeSC.selectedSegmentIndex == 1 {
            petSize = PetSize.medium.rawValue
        } else if petSizeSC.selectedSegmentIndex == 2 {
            petSize = PetSize.big.rawValue
        } else if petSizeSC.selectedSegmentIndex == 3 {
            petSize = PetSize.veryBig.rawValue
        } else {
            return nil
        }
        return petSize
    }

}
