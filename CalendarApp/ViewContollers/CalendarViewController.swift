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
    
    //MARK: – Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.select(Date())
        calendar.locale = Locale(identifier: "ru_RU")
    }
    
    //MARK: – Actions
    @IBSegueAction func addEditToDoTableViewContollerSegue(_ coder: NSCoder, sender: Any?) -> AddEditToDoTableViewController? {
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? HourTableViewCell, let selectedDate = calendar.selectedDate {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
            
            if let selectedToDo = selectedCell.toDo {
                return AddEditToDoTableViewController(coder: coder, toDo: selectedToDo, segueType: .toDoCellTapped)
            } else {
                var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: selectedDate)
                
                components.hour = selectedIndexPath.row
                
                return AddEditToDoTableViewController(coder: coder, toDo: nil, segueType: .emptyCellTapped(date: Calendar.current.date(from: components)))
            }
        } else {
            return AddEditToDoTableViewController(coder: coder, toDo: nil, segueType: .newButtonTapped)
        }
        
        
//        guard let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? HourTableViewCell, let selectedDate = calendar.selectedDate else {
//            return AddEditToDoTableViewController(coder: coder, toDo: nil, segueType: .newButtonTapped)
//        }
//        
//        tableView.deselectRow(at: selectedIndexPath, animated: true)
//        
//        if let selectedToDo = selectedCell.toDo {
//            return AddEditToDoTableViewController(coder: coder, toDo: selectedToDo, segueType: .toDoCellTapped)
//        } else {
//            var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: selectedDate)
//            
//            components.hour = selectedIndexPath.row
//            
//            return AddEditToDoTableViewController(coder: coder, toDo: nil, segueType: .emptyCellTapped(date: Calendar.current.date(from: components)))
//        }
    }
    
    @IBAction func unwindToCalendarViewController(segue: UIStoryboardSegue) {
        if let selctedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selctedIndexPath, animated: true)
        }
        
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
        
        // Update row's titleLabel with toDos.
        cell.titleLabel.text = nil
        cell.toDo = nil
        
        for dayToDo in model.toDos {
            
            if let selectedDate = calendar.selectedDate {
                var components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: selectedDate)
                
                components.hour = indexPath.row
                
                if let cellDate = Calendar.current.date(from: components), cellDate.timeIntervalSince1970 >= dayToDo.startDate && cellDate.timeIntervalSince1970 < dayToDo.finishDate {
                    cell.toDo = dayToDo
                    
                    if let title = cell.titleLabel.text {
                        cell.titleLabel.text = "\(title)\n\(dayToDo.name)"
                    } else {
                        cell.titleLabel.text = dayToDo.name
                    }
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
