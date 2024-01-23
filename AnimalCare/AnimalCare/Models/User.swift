//
//  User.swift
//  AnimalCare
//
//  Created by Sofa on 28.11.23.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage

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
    let ref: DatabaseReference!
    
    init(uid: String, email: String, role: String, name: String, surname: String, phoneNumber: String, age: String, city: String, address: String, sex: String, avatar: UIImage?, progress: Progress?, infoAboutYourself: String?, detailsOfWalking: Details?, reviews: [Review]?) {
        self.uid = uid
        self.email = email
        self.role = role
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.age = age
        self.city = city
        self.address = address
        self.sex = sex
        self.avatar = avatar
        self.progress = progress
        self.infoAboutYourself = infoAboutYourself
        self.detailsOfWalking = detailsOfWalking
        self.reviews = reviews
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) { // DataSnapshot - снимок иерархии DB
        guard let snapshotValue = snapshot.value as? [String: Any],
              let uid = snapshotValue[Constants.uidKey] as? String,
              let email = snapshotValue[Constants.emailKey] as? String,
              let role = snapshotValue[Constants.roleKey] as? String,
              let name = snapshotValue[Constants.nameKey] as? String,
              let surname = snapshotValue[Constants.surnameKey] as? String,
              let phoneNumber = snapshotValue[Constants.phoneNumberKey] as? String,
              let age = snapshotValue[Constants.ageKey] as? String,
              let city = snapshotValue[Constants.cityKey] as? String,
              let address = snapshotValue[Constants.addressKey] as? String,
              let sex = snapshotValue[Constants.sexKey] as? String,
              let avatar = snapshotValue[Constants.avatarKey] as? UIImage,
              let progress = snapshotValue[Constants.progressKey] as? Progress,
              let infoAboutYourself = snapshotValue[Constants.infoAboutYourselfKey] as? String,
              let detailsOfWalking = snapshotValue[Constants.detailsOfWalkingKey] as? Details,
              let reviews = snapshotValue[Constants.reviewsKey] as? [Review] else { return nil }
        self.uid = uid
        self.email = email
        self.role = role
        self.name = name
        self.surname = surname
        self.phoneNumber = phoneNumber
        self.age = age
        self.city = city
        self.address = address
        self.sex = sex
        self.avatar = avatar
        self.progress = progress
        self.infoAboutYourself = infoAboutYourself
        self.detailsOfWalking = detailsOfWalking
        self.reviews = reviews
        self.ref = snapshot.ref
    }
    
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
    let typeOfService: String?
    let petType: String?
    let petSize: [String]?
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
