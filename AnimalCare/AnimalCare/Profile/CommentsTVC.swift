//
//  CommentsTVC.swift
//  AnimalCare
//
//  Created by Sofa on 8.01.24.
//

import UIKit

class CommentsTVC: UITableViewController {
    
    var reviews: [Review]!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        reviews.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let review = reviews[indexPath.row]
        cell.textLabel?.text = review.clientName
        cell.detailTextLabel?.text = "\(Calculating.getMark(mark: review.mark) ?? "")\n \(review.comment ?? "")"
        return cell
    }

}
