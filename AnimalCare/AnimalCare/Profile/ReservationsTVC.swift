//
//  ReservationsTVC.swift
//  AnimalCare
//
//  Created by Sofa on 28.01.24.
//

import UIKit
import Firebase

class ReservationsTVC: UITableViewController {
    
    var user: User?
    var reservations = [Reservation]()
    private var notCompletedReservations = [Reservation]()
    private var completedReservations = [Reservation]()
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Бронирования"
        ref = Database.database().reference(withPath: "users").child(user?.uid ?? "").child("reservations")
        filteringReservations(reservations: reservations)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int { 2 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? notCompletedReservations.count : completedReservations.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "Не прошедшие бронирования" : "Прошедшие бронирования"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let reservation = indexPath.section == 0 ? notCompletedReservations[indexPath.row] : completedReservations[indexPath.row]
        if user?.role == Role.client.rawValue {
            cell.textLabel?.text = reservation.dogwalkerName
        } else {
            cell.textLabel?.text = reservation.clientName
        }
        cell.detailTextLabel?.text = reservation.data
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
    private func filteringReservations(reservations: [Reservation]) {
        for reservation in reservations {
            if reservation.isCompleted {
                completedReservations.append(reservation)
            } else {
                notCompletedReservations.append(reservation)
            }
            tableView.reloadData()
        }
    }
}
