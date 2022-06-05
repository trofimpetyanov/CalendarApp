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
                ToDo(id: UUID(), startDate: 1654268400, finishDate: 1654272000, name: "Вымыть посуду", description: "Надо поскорее, гречка засохнет..."),
                ToDo(id: UUID(), startDate: 1654268400, finishDate: 1654272000, name: "Подмести полы", description: "Елена Летучая будет в шоке"),
                ToDo(id: UUID(), startDate: 1654336800, finishDate: 1654340400, name: "Встреча с SimbirSoft", description: "Надеюсь меня возьмут на практикум :)"),
                ToDo(id: UUID(), startDate: 1654347600, finishDate: 1654351200, name: "Уборка в офисе", description: "Может пора купить еще один фикус?"),
                ToDo(id: UUID(), startDate: 1654437600, finishDate: 1654441200, name: "Перестановка мебели", description: "Хочу чего-то новенького..."),
                ToDo(id: UUID(), startDate: 1654441200, finishDate: 1654444800, name: "Доставка стульев", description: "Наконец-то новые стулья привезут")
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
