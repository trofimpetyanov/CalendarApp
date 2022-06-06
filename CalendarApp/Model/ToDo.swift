//
//  ToDo.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 03.06.2022.
//

import Foundation

struct ToDo {
    let id: UUID
    
    var startDate: Double
    var finishDate: Double
     
    var name: String
    var description: String
}

extension ToDo: Codable { }
