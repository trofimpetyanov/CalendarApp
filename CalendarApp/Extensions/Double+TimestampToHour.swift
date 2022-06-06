//
//  Date+TimestampToHour.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 03.06.2022.
//

import Foundation

extension Double {
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "H:mm"
         return dateFormatter
     }()
    
    func timestampToHour() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        return Double.dateFormatter.string(from: date)
    }
}
