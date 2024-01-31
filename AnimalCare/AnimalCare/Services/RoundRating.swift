//
//  RoundRating.swift
//  AnimalCare
//
//  Created by Sofa on 9.01.24.
//

import UIKit

class Calculating {

   static func roundRating(reviews: [Review]?) -> String? {
        var sum = 0.0
        var rating = 0.0
       var marks: [Double] = []
       guard let reviews else { return nil }
       for review in reviews {
           let reviewsMark = review.mark
           marks.append(reviewsMark)
       }
       for mark in marks {
            sum += mark
        }
        rating = sum / Double(marks.count)
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
    
    static func getMark(mark: Double) -> String? {
        switch mark {
        case 1.0:
            return "⭐️"
        case 2.0:
            return "⭐️⭐️"
        case 3.0:
            return "⭐️⭐️⭐️"
        case 4.0:
            return "⭐️⭐️⭐️⭐️"
        case 5.0:
            return "⭐️⭐️⭐️⭐️⭐️"
        default:
            return "Нет отзывов"
        }
    }
    
}
