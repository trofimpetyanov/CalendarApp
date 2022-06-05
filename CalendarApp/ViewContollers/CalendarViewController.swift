//
//  ViewController.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 03.06.2022.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    @IBOutlet var calendar: FSCalendar!
    @IBOutlet var tableView: UITableView!
    
    struct Model {
        var toDos: [ToDo] {
            Settings.shared.toDos
        }
    }
    
    var model = Model()
    
    var selectedToDo: ToDo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.select(Date())
    }
    @IBSegueAction func addEditToDoTableViewContollerSegue(_ coder: NSCoder, sender: Any?) -> AddEditToDoTableViewController? {
        guard let selectedIndexPath = tableView.indexPathForSelectedRow, let selectedCell = tableView.cellForRow(at: selectedIndexPath) as? HourTableViewCell, let selectedToDo = selectedCell.toDo else {
            return AddEditToDoTableViewController(coder: coder, toDo: nil)
        }
        
        return AddEditToDoTableViewController(coder: coder, toDo: selectedToDo)
    }
    
    @IBAction func unwindToCalendarViewController(unwindSegue: UIStoryboardSegue) {
        
    }
}

extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "hourCell", for: indexPath) as! HourTableViewCell
        
        let dayToDos = model.toDos.filter { toDo in
            let toDoDate = Date(timeIntervalSince1970: toDo.dateStart)

            guard let calendarDate = calendar.selectedDate else { return false }
        
            return Calendar.current.isDate(toDoDate, inSameDayAs: calendarDate)
        }
        
        cell.titleLabel.text = nil
        
        for dayToDo in dayToDos {
            if "\(indexPath.row):00" == dayToDo.dateStart.timestampToHour() {
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
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tableView.reloadSections(IndexSet(integer: .zero), with: .automatic)
        
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
