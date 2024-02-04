//
//  ReservationsTVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.01.24.
//

import UIKit
import Firebase

class ReservationsTVC: UITableViewController {
    
    var user: User!
    var reservations = [Reservation]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Бронирования"
        ref = Database.database().reference(withPath: "users").child(user?.uid ?? "").child("reservations")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ref.observe(.value) { [weak self] snapshot in
            var reservations = [Reservation]()
            for item in snapshot.children {
                guard let snapshot = item as? DataSnapshot,
                      let reservation = Reservation(snapshot: snapshot) else { return }
                reservations.append(reservation)
            }
            print("\(reservations)")
            self?.reservations = reservations
            self?.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reservations.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let reservation = reservations[indexPath.row]
        if user?.role == Role.client.rawValue {
            cell.textLabel?.text = reservation.dogwalkerName
        } else {
            cell.textLabel?.text = reservation.clientName
        }
        cell.detailTextLabel?.text = reservation.data
        toggleComplition(cell: cell, isCompleted: reservation.isCompleted)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let _ = tableView.cellForRow(at: indexPath) else { return }
        let reservation = reservations[indexPath.row]
        let isCompleted = !reservation.isCompleted
        reservation.ref.updateChildValues(["isCompleted" : isCompleted])
    }
    
    private func toggleComplition(cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
}
