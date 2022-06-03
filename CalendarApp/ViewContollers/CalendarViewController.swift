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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar.select(Date())
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
        
        for dayToDo in dayToDos {
            if let hour = Int(dayToDo.dateStart.timestampToHour().components(separatedBy: ":")[0]), hour == indexPath.row {
                cell.titleLabel.text = dayToDo.name
                print("я поставил для \(dayToDo.dateStart.timestampToHour()) -- \(indexPath.row)")
            } else {
                
            }
        }
        
        cell.timeLabel.text = "\(indexPath.row):00\n\(indexPath.row + 1):00"
        
        return cell
    }
}

extension CalendarViewController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tableView.reloadData()
    }
}
