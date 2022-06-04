//
//  AddEditToDoViewController.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 04.06.2022.
//

import UIKit

class AddEditToDoTableViewController: UITableViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    private let placeholders = [
        "Оплатить аренду" : "Перевести 40,000₽ В.А.Комаровой",
        "Сходить в ветклинику" : "У Барсика болит лапа",
        "Записаться к стоматологу" : "Надо поменять пломбу",
        "Полить цветы" : "Кажется давно пора...",
        "Сходить в парикмахерскую" : "Может попробовать новую стрижку?",
        "Выбрать хостинг для сайта" : "Sprinthost.ru или Beget.ru?"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        if let randomPlaceholder = placeholders.randomElement() {
            nameTextField.placeholder = randomPlaceholder.key
            descriptionTextField.placeholder = randomPlaceholder.value
        }
    }
}
