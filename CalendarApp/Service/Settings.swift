//
//  Settings.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 03.06.2022.
//

import Foundation

struct Settings {
    private let defaults = UserDefaults.standard
    static var shared = Settings()
    
    //MARK: – Keys
    enum Setting {
        static let toDos = "toDos"
    }
    
    //MARK: – Data
    var toDos: [ToDo] {
        get {
            return unarchiveJSON(key: Setting.toDos) ?? [
                ToDo(id: 1, dateStart: 1654268400, dateFinish: 1654272000, name: "ToDo1", description: "Description"),
                ToDo(id: 2, dateStart: 1654336800, dateFinish: 1654340400, name: "ToDo1", description: "Description"),
                ToDo(id: 3, dateStart: 1654347600, dateFinish: 1654351200, name: "ToDo1", description: "Description"),
                ToDo(id: 4, dateStart: 1654437600, dateFinish: 1654441200, name: "ToDo1", description: "Description"),
                ToDo(id: 5, dateStart: 1654441200, dateFinish: 1654444800, name: "ToDo1", description: "Description")
            ]
        } set {
            archiveJSON(value: newValue, key: Setting.toDos)
        }
    }
}

extension Settings {
    //MARK: – Encoding & Decoding
    func archiveJSON<T: Encodable>(value: T, key: String) {
        do {
            let data = try JSONEncoder().encode(value)
            let string = String(data: data, encoding: .utf8)
            defaults.set(string, forKey: key)
        } catch {
            debugPrint("Error occured when encoding data")
        }
    }
    
    func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key), let data = string.data(using: .utf8) else { return nil }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            debugPrint("Error occured when decoding data")
            return nil
        }
    }
}
