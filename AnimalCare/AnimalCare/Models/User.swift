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
    // progress
    let progressOfWalking: String?
    let progressOfSitting: String?
    let infoAboutYourself: String?
    //details
    let typeOfService: String?
    let petType: String?
    let petSize: [String]?
    let priceOfWalk: String?
    let priceOfSitting: String?
    
    init(uid: String, email: String, role: String, name: String, surname: String, phoneNumber: String, age: String, city: String, address: String, sex: String, avatar: UIImage?, progressOfWalking: String?, progressOfSitting: String?,  infoAboutYourself: String?, typeOfService: String?, petType: String?, petSize: [String]?, priceOfWalk: String?, priceOfSitting: String?) {
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
        self.progressOfWalking = progressOfWalking
        self.progressOfSitting = progressOfSitting
        self.infoAboutYourself = infoAboutYourself
        self.typeOfService = typeOfService
        self.petType = petType
        self.petSize = petSize
        self.priceOfWalk = priceOfWalk
        self.priceOfSitting = priceOfSitting
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
              let avatar = snapshotValue[Constants.avatarKey] as? UIImage?,
              let progressOfWalking = snapshotValue[Constants.progressOfWalkingKey] as? String?,
              let progressOfSitting = snapshotValue[Constants.progressOfSittingKey] as? String?,
              let infoAboutYourself = snapshotValue[Constants.infoAboutYourselfKey] as? String?,
              let typeOfService = snapshotValue[Constants.typeOfServiceKey] as? String?,
              let petType = snapshotValue[Constants.petTypeKey] as? String?,
              let petSize = snapshotValue[Constants.petSizeKey] as? [String]?,
              let priceOfWalk = snapshotValue[Constants.priceOfWalkKey] as? String?,
              let priceOfSitting = snapshotValue[Constants.priceOfSittingKey] as? String? else {
            print("Can't convert to User")
            return nil }
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
        self.progressOfWalking = progressOfWalking
        self.progressOfSitting = progressOfSitting
        self.infoAboutYourself = infoAboutYourself
        self.typeOfService = typeOfService
        self.petType = petType
        self.petSize = petSize
        self.priceOfWalk = priceOfWalk
        self.priceOfSitting = priceOfSitting
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
         Constants.progressOfWalkingKey: progressOfWalking,
         Constants.progressOfSittingKey: progressOfSitting,
         Constants.infoAboutYourselfKey: infoAboutYourself,
         Constants.typeOfServiceKey: typeOfService,
         Constants.petTypeKey: petType,
         Constants.petSizeKey: petSize,
         Constants.priceOfWalkKey: priceOfWalk,
         Constants.priceOfSittingKey: priceOfSitting]
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
        static let progressOfWalkingKey = "progressOfWalking"
        static let progressOfSittingKey = "progressOfSitting"
        static let infoAboutYourselfKey = "infoAboutYourself"
        static let typeOfServiceKey = "typeOfService"
        static let petTypeKey = "petType"
        static let petSizeKey = "petSize"
        static let priceOfWalkKey = "priceOfWalk"
        static let priceOfSittingKey = "priceOfSitting"
    }
}

enum Role: String {
    case client = "Client"
    case dogwalker = "Dogwalker"
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

