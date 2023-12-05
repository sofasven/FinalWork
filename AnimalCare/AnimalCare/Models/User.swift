//
//  User.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import Foundation
import UIKit


enum Role: String {
    case client = "Client"
    case dogwalker = "Dogwalker"
}

struct User {
    let uid: String
    let email: String
    let role: Role
    let name: String
    let surname: String
    let age: Int
    let address: Address
    let photo: UIImage?
    let progress: Progress?
    let infoAboutYourself: String?
    let detailsOfWalking: Details?
    let reviews: [Review]?
}

struct Address {
    let country: String
    let sity: String
    let street: String
    let homeNumber: Int?
    let apartmentNumber: Int?
}
struct Progress {
    let dogwalking: Int
    let sitting: Int
}
struct Details {
    let priceOfWalk: String
    let priceOfSitting: String
    let petType: String
    let typeOfHousing: String
    let dogAge: String
    let catAge: String
    let petSize: String
}
struct Review {
    let comment: String
    let rating: Int
}
