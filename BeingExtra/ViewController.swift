//
//  ViewController.swift
//  BeingExtra
//
//  Created by Cynthia Zhou on 2017-08-26.
//  Copyright © 2017 Cynthia Zhou. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    
    let outsideMonthColour = UIColor(colorLiteralRed: 85/255.0, green: 85/255.0, blue: 85/255.0, alpha: 1.0)
    let thisMonthColour = UIColor(colorLiteralRed: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    let selectedDayColour = UIColor(colorLiteralRed: 76/255.0, green: 213/255.0, blue: 1.0, alpha: 1.0)
    let bgColour = UIColor(colorLiteralRed: 65/255.0, green: 65/255.0, blue: 65/255.0, alpha: 1.0)
    let todayColour = UIColor(colorLiteralRed: 14/255.0, green: 183/255.0, blue: 185/255.0, alpha: 1.0)
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy mm dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        
        return dateFormatter
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        
        calendarView.visibleDates { dateSegment in
            self.setUpCalendarViews(dateSegment: dateSegment)
        }
    }
    
    func setUpCalendarView(){
        calendarView.minimumLineSpacing = 2
        calendarView.minimumInteritemSpacing = 2
        
        calendarView.scrollToDate(Date())
        calendarView.selectDates([ Date() ])
        
    }
    
    func setUpCalendarViews(dateSegment: DateSegmentInfo){
        guard let date = dateSegment.monthDates.first?.date else {return}
        
        formatter.dateFormat = "yyyy"
        year.text = formatter.string(from: date)
        
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    
    func handleCellColour(view: JTAppleCell?, cellState: CellState){
        let todayDate = Date()
        formatter.dateFormat = "yyyy mm dd"
        
        let todayDateString = formatter.string(from: todayDate)
        let monthDateString = formatter.string(from: cellState.date)
        
        guard let validCell = view as? CustomCell else { return }
        
        if todayDateString == monthDateString{
            validCell.dateLabel.textColor = todayColour
        } else if cellState.dateBelongsTo == .thisMonth {
            validCell.dateLabel.textColor = thisMonthColour
        } else {
            validCell.dateLabel.textColor = outsideMonthColour
        }
    }
    
    func handleCellSelected(view: JTAppleCell?, cellState: CellState){
        
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.isSelected {
            validCell.selectedView.isHidden = false
        } else {
            validCell.selectedView.isHidden = true
        }
    }
    
    func handleCellVisibility(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        
        if cellState.dateBelongsTo == .thisMonth {
            validCell.isHidden = false
        } else {
            validCell.isHidden = true
        }
        
    }
    
    func handleCellBooked(view: JTAppleCell?, cellState: CellState){
        guard let validCell = view as? CustomCell else { return }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2022 01 01")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        
        handleCellColour(view: cell, cellState: cellState)
        handleCellSelected(view: cell, cellState: cellState)
        handleCellVisibility(view: cell, cellState: cellState)
        
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelected(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendarViews(dateSegment: visibleDates)
        
    }
    
}


extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
