//
//  AddEditToDoViewController.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 04.06.2022.
//

import UIKit

class AddEditToDoTableViewController: UITableViewController {
    //MARK: – Outlets
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var finishDatePicker: UIDatePicker!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    //MARK: – Properties
    private let placeholders = [
        "Оплатить аренду" : "Перевести 40,000₽ В.А.Комаровой",
        "Сходить в ветклинику" : "У Барсика болит лапа",
        "Записаться к стоматологу" : "Надо поменять пломбу",
        "Полить цветы" : "Кажется давно пора...",
        "Сходить в парикмахерскую" : "Может попробовать новую стрижку?",
        "Выбрать хостинг для сайта" : "Sprinthost.ru или Beget.ru?"
    ]
    
    var toDo: ToDo?
    var segueType: SegueType?
    
    init?(coder: NSCoder, toDo: ToDo?, segueType: SegueType) {
        self.toDo = toDo
        self.segueType = segueType
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        toDo = nil
    }
    
    //MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePickers()
        
        if let randomPlaceholder = placeholders.randomElement() {
            title = "Новая задача"
            
            nameTextField.placeholder = randomPlaceholder.key
            descriptionTextField.placeholder = randomPlaceholder.value
        }
        
        switch segueType {
        case .toDoCellTapped:
            if let toDo = toDo {
                title = "Изменить задачу"
                
                nameTextField.text = toDo.name
                descriptionTextField.text = toDo.description
                
                startDatePicker.date = Date(timeIntervalSince1970: toDo.startDate)
                finishDatePicker.date = Date(timeIntervalSince1970: toDo.finishDate)
            }
        case .emptyCellTapped(date: let date):
            if let date = date {
                finishDatePicker.date = Calendar.current.date(byAdding: .hour, value: 1, to: date) ?? Date()
                startDatePicker.date = date
                updateDatePickers()
            }
        default:
            return
        }
        
        updateSaveButtonState()
    }
    
    //MARK: – Helpers
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
        finishDatePicker.minimumDate = Calendar.current.date(byAdding: .minute, value: 5, to: startDatePicker.date)
    }
    
    func updateSaveButtonState() {
        let name = nameTextField.text ?? ""
        
        saveButton.isEnabled = !name.isEmpty
    }
    
    //MARK: – Actions
    @IBAction func textfieldsEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    @IBAction func datePickersValueChanged(_ sender: UIDatePicker) {
        updateDatePickers()
    }
    
    //MARK: – Prepare
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
