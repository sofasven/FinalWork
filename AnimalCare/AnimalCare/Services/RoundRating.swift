//
//  RoundRating.swift
//  AnimalCare
//
//  Created by Sofa on 9.01.24.
//

import UIKit

class Calculating {

   static func roundRating(user: User) -> String {
        var sum = 0.0
        var rating = 0.0
       guard let reviews = user.reviews else { return ""}
        for review in reviews {
            sum += review.mark
        }
        rating = sum / Double(reviews.count)
        switch rating {
        case 1...1.4:
            return "⭐️"
        case 1.5...2.4:
            return "⭐️⭐️"
        case 2.5...3.4:
            return "⭐️⭐️⭐️"
        case 3.5...4.4:
            return "⭐️⭐️⭐️⭐️"
        case 4.5...5.0:
            return "⭐️⭐️⭐️⭐️⭐️"
        default:
            return "Нет отзывов"
        }
    }
}
