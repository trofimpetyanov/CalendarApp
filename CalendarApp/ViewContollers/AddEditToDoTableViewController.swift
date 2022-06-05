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
    
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var finishDatePicker: UIDatePicker!
    
    private let placeholders = [
        "Оплатить аренду" : "Перевести 40,000₽ В.А.Комаровой",
        "Сходить в ветклинику" : "У Барсика болит лапа",
        "Записаться к стоматологу" : "Надо поменять пломбу",
        "Полить цветы" : "Кажется давно пора...",
        "Сходить в парикмахерскую" : "Может попробовать новую стрижку?",
        "Выбрать хостинг для сайта" : "Sprinthost.ru или Beget.ru?"
    ]
    
    var toDo: ToDo?
    
    init?(coder: NSCoder, toDo: ToDo?) {
        self.toDo = toDo
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let toDo = toDo {
            nameTextField.text = toDo.name
            descriptionTextField.text = toDo.description
            
            startDatePicker.date = Date(timeIntervalSince1970: toDo.dateStart)
            finishDatePicker.date = Date(timeIntervalSince1970: toDo.dateFinish)
        } else if let randomPlaceholder = placeholders.randomElement() {
            nameTextField.placeholder = randomPlaceholder.key
            descriptionTextField.placeholder = randomPlaceholder.value
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        
    }
}
