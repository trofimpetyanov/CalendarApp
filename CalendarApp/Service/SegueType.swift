//
//  SegueType.swift
//  CalendarApp
//
//  Created by Trofim Petyanov on 06.06.2022.
//

import Foundation

enum SegueType {
    case newButtonTapped
    case emptyCellTapped(date: Date?)
    case toDoCellTapped
}
