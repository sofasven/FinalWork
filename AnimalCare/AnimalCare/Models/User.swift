//
//  User.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import Foundation
import UIKit
import Firebase

struct User {
    let uid: String
    let email: String
    let role: String
    let name: String
    let surname: String
    let phoneNumber: String
    let age: String
    let city: String
    let address: String
    let sex: String
    var avatar: UIImage?
    let progress: Progress?
    let infoAboutYourself: String?
    let detailsOfWalking: Details?
    var reviews: [Review]?
    
    func convertToDictionary() -> [String: Any] {
        [Constants.uidKey: uid,
         Constants.emailKey: email,
         Constants.roleKey: role,
         Constants.nameKey: name,
         Constants.surnameKey: surname,
         Constants.phoneNumberKey: phoneNumber,
         Constants.ageKey: age,
         Constants.cityKey: city,
         Constants.addressKey: address,
         Constants.sexKey: sex,
         Constants.avatarKey: avatar,
         Constants.progressKey: progress,
         Constants.infoAboutYourselfKey: infoAboutYourself,
         Constants.detailsOfWalkingKey: detailsOfWalking,
         Constants.reviewsKey: reviews]
    }

    private enum Constants {
        static let uidKey = "uid"
        static let emailKey = "email"
        static let roleKey = "role"
        static let nameKey = "name"
        static let surnameKey = "surname"
        static let phoneNumberKey = "phoneNumber"
        static let ageKey = "age"
        static let cityKey = "city"
        static let addressKey = "address"
        static let sexKey = "sex"
        static let avatarKey = "avatar"
        static let progressKey = "progress"
        static let infoAboutYourselfKey = "infoAboutYourself"
        static let detailsOfWalkingKey = "detailsOfWalking"
        static let reviewsKey = "reviews"
    }
}

enum Role: String {
    case client = "Client"
    case dogwalker = "Dogwalker"
}

struct Progress {
    let dogwalking: Int
    let sitting: Int
}

struct Details {
    let typeOfService: TypesOfService?
    let petType: PetType?
    let petSize: [PetSize?]
    let priceOfWalk: String?
    let priceOfSitting: String?
}

enum TypesOfService: String {
    case dogsitter = "Ситтер"
    case dogwalker = "Выгульщик/дневнаяя няня"
    case both = "Ситтер и Выгульщик/дневнаяя няня"
}

enum PetSize: String {
    case small = "маленький (до 5 кг)"
    case medium = "средний (до 20 кг)"
    case big = "большой (до 40 кг)"
    case veryBig = "очень большой (40+ кг)"
}

enum PetType: String {
    case dog = "Собака"
    case cat = "Кот"
    case both = "Собака и кот"
}

struct Review {
    let comment: String
    let mark: Double
}
