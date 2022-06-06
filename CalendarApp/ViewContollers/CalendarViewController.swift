//
//  ViewController.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 03.06.2022.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    //MARK: – Outlets
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    
    //MARK: – View Model
    struct Model {
        var toDos: [ToDo] {
            Settings.shared.toDos
        }
    }
    
    //MARK: – Properties
    var model = Model()
    
    var selectedToDo: ToDo?
    
    //MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.select(Date())
    }
    
    //MARK: – Actions
    @IBSegueAction func addEditToDoTableViewContollerSegue(_ coder: NSCoder, sender: Any?) -> AddEditToDoTableViewController? {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? HourTableViewCell, let selectedToDo = selectedCell.toDo else {
            return AddEditToDoTableViewController(coder: coder, toDo: nil)
        }
        
        return AddEditToDoTableViewController(coder: coder, toDo: selectedToDo)
    }
    
    @IBAction func unwindToCalendarViewController(segue: UIStoryboardSegue) {
        if segue.identifier == "saveUnwind",
           let sourceViewController = segue.source as? AddEditToDoTableViewController,
           let toDo = sourceViewController.toDo {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow,
               let cell = tableView.cellForRow(at: selectedIndexPath) as? HourTableViewCell,
               let selectedToDo = cell.toDo {
                // If toDo already exists, delete it and append an updated one.
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                
                Settings.shared.toDos.removeAll { $0.id == selectedToDo.id }
                Settings.shared.toDos.append(toDo)
            } else {
                // Else append new one.
                Settings.shared.toDos.append(toDo)
            }
        } else if segue.identifier == "deleteUnwind" {
            if let selectedIndexPath = tableView.indexPathForSelectedRow,
               let cell = tableView.cellForRow(at: selectedIndexPath) as? HourTableViewCell,
               let selectedToDo = cell.toDo {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
                
                Settings.shared.toDos.removeAll { $0.id == selectedToDo.id }
            }
        }
        
        tableView.reloadData()
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: – Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath) as! HourTableViewCell
        
        // Filter toDos with selected date.
        let dayToDos = model.toDos.filter { toDo in
            let toDoDate = Date(timeIntervalSince1970: toDo.startDate)
            
            guard let calendarDate = calendar.selectedDate else { return false }
            
            return Calendar.current.isDate(toDoDate, inSameDayAs: calendarDate)
        }
        
        // Update rows' titleLabel with day's toDos.
        cell.titleLabel.text = nil
        
        for dayToDo in dayToDos {
            if "\(indexPath.row):00" == dayToDo.startDate.timestampToHour() {
                cell.toDo = dayToDo
                
                if let title = cell.titleLabel.text {
                    cell.titleLabel.text = "\(title)\n\(dayToDo.name)"
                } else {
                    cell.titleLabel.text = dayToDo.name
                }
            }
        }
        
        cell.timeLabel.text = "\(indexPath.row):00\n\(indexPath.row + 1):00"
        
        return cell
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    //MARK: – Calendar Delegate
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tableView.reloadSections(IndexSet(integer: .zero), with: .automatic)
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
