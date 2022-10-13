import Foundation
import UIKit

final class Utils {
    
    
    
    // MARK: - Tarih formatını düzenlediğimiz fonksiyon
    static func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
    
    // MARK: - Gelen Double değerlerini 0.0 şeklinde ayarlayan fonksiyon

    static func convertDouble(_ a: Double, maxDecimals max: Int) -> Double {
        let stringArr = String(a).split(separator: ".")
        let decimals = Array(stringArr[1])
        var string = "\(stringArr[0])."

        var count = 0;
        for n in decimals {
            if count == max { break }
            string += "\(n)"
            count += 1
        }

        let double = Double(string)!
        return double
    }
    
}
         
         
    
