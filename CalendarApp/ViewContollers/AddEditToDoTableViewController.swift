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
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
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
    
    func setupDatePickers() {
        let calendar = Calendar.current
        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        components.minute = 0
        components.second = 0
        
        if let currentDate = calendar.date(from: components) {
            startDatePicker.date = currentDate
        }
        
        updateDatePickers()
    }
    
    func updateDatePickers() {
        finishDatePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 30, to: startDatePicker.date)
    }
    
    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        
        saveButton.isEnabled = !name.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePickers()
        
        if let toDo = toDo {
            title = "Изменить задачу"
            
            nameTextField.text = toDo.name
            descriptionTextField.text = toDo.description
            
            startDatePicker.date = Date(timeIntervalSince1970: toDo.startDate)
            finishDatePicker.date = Date(timeIntervalSince1970: toDo.finishDate)
        } else if let randomPlaceholder = placeholders.randomElement() {
            title = "Новая задача"
            
            nameTextField.placeholder = randomPlaceholder.key
            descriptionTextField.placeholder = randomPlaceholder.value
        }
        
        updateSaveButtonState()
    }
    
    @IBAction func textfieldsEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickersValueChanged(_ sender: UIDatePicker) {
        updateDatePickers()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        var id: UUID
        
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""
        let startDate = Double(startDatePicker.date.timeIntervalSince1970)
        let finishDate = Double(finishDatePicker.date.timeIntervalSince1970)
        
        if let toDo = toDo {
            id = toDo.id
        } else {
            id = UUID()
        }
        
        toDo = ToDo(id: id, startDate: startDate, finishDate: finishDate, name: name, description: description)
    }
}
