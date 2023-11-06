//
//  AddRegistrationTableViewController.swift
//  HotelManzana
//
//  Created by Cheks Nweze on 03/09/2020.
//  Copyright © 2020 Cheks. All rights reserved.
//

import UIKit


class AddRegistrationTableViewController: UITableViewController, SelectRoomTypeTableViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkOutDatePicker.date = midnightToday.addingTimeInterval(86400)
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
        fillFields()
        
        updateDoneButtonState()
        calculatePrice()
    }
        
        func fillFields() {
        
        guard let currentReg = currentReg else {return}
            
        let dateFormatter = DateFormatter()
        
        firstNameTextField.text = currentReg.firstName
        lastNameTextField.text = currentReg.lastName
        emailTextField.text = currentReg.emailAddress
        
        checkInDateLabel.text = dateFormatter.string(from: currentReg.checkInDate)
        checkOutDateLabel.text = dateFormatter.string(from: currentReg.checkOutDate)
        checkInDatePicker.minimumDate = currentReg.checkInDate
        checkOutDatePicker.minimumDate = currentReg.checkOutDate
        
        numberOfAdultsLabel.text = String(currentReg.numberOfAdults)
        numberOfAdultsStepper.value = Double(currentReg.numberOfAdults)
        numberOfChildrenLabel.text = String(currentReg.numberOfChildren)
        numberOfChildrenStepper.value = Double(currentReg.numberOfChildren)
        
        wifiSwitch.isOn = currentReg.wifi
        roomTypeLabel.text = currentReg.roomType.name
        
        }

    
    var currentReg : Registration?
    
    var roomType : RoomType?
    
    var registration : Registration? {
        
        guard let roomType = roomType else {return nil}
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        let roomChoice = roomType
        
        return Registration(firstName: firstName, lastName: lastName, emailAddress: email, checkInDate: checkInDate, checkOutDate: checkOutDate, numberOfAdults: numberOfAdults, numberOfChildren: numberOfChildren, roomType: roomChoice, wifi: hasWifi)
    }
    
    var isCheckInDatePickerShown : Bool = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    
    var isCheckOutDatePickerShown : Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerCellIndexPath.section, checkInDatePickerCellIndexPath.row):
            if isCheckInDatePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row):
            if isCheckOutDatePickerShown {
                return 216.0
            } else {
                return 0.0
            }
        default:
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch (indexPath.section, indexPath.row) {
        case (checkInDatePickerCellIndexPath.section, checkInDatePickerCellIndexPath.row - 1):
            
            if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
            } else if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
                isCheckInDatePickerShown = true
            }else{
                isCheckInDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        case (checkOutDatePickerCellIndexPath.section, checkOutDatePickerCellIndexPath.row - 1):
            if isCheckOutDatePickerShown {
                isCheckOutDatePickerShown = false
            } else if isCheckInDatePickerShown {
                isCheckInDatePickerShown = false
                isCheckOutDatePickerShown = true
            }else{
                isCheckOutDatePickerShown = true
            }
            
            tableView.beginUpdates()
            tableView.endUpdates()
            
        default:
            break
        }
    }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "SelectRoomType" {
                let destinationVC = segue.destination as? SelectRoomTypeTableViewController
                
                destinationVC?.delegate = self
                destinationVC?.roomType = roomType
            }
        }
    
    func updateDateViews() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        checkInDateLabel.text = dateFormatter.string(from: checkInDatePicker.date)
        checkOutDateLabel.text = dateFormatter.string(from: checkOutDatePicker.date)
        
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(86400)
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
            updateDoneButtonState()
        } else {
            roomTypeLabel.text = "Not Set"
        }
        calculatePrice()
    }
    
    func didSelect(roomType: RoomType) {
        self.roomType = roomType
        updateRoomType()
    }
    


    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    
    @IBOutlet weak var nightsLabel: UILabel!
    @IBOutlet weak var shortRoomTypeLabel: UILabel!
    @IBOutlet weak var roomTypeNightsPriceLabel: UILabel!
    @IBOutlet weak var wifiYesNoLabel: UILabel!
    @IBOutlet weak var wifiNightsPriceLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    
    
    
    @IBOutlet weak var wifiSwitch: UISwitch!
    
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    func updateDoneButtonState() {
        
        doneButton.isEnabled = false
        guard let registration = self.registration else {return}
        
        if numberOfAdultsStepper.value < 1 || registration.firstName.isEmpty || registration.lastName.isEmpty || registration.emailAddress.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateDoneButtonState()
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
        calculatePrice()
    }
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        updateNumberOfGuests()
        updateDoneButtonState()
    }
    
    
    func calculatePrice() {
        
        guard let wholeDays = Calendar.current.dateComponents([.day], from: checkInDatePicker.date, to: checkOutDatePicker.date).day else {return}
        
        let numberOfNights = wholeDays + 1
        
        nightsLabel.text = String(numberOfNights)
        shortRoomTypeLabel.text = roomType?.shortName
        roomTypeNightsPriceLabel.text = String(roomType?.price ?? 0 * numberOfNights)
        
        if wifiSwitch.isOn {
            wifiYesNoLabel.text = "Yes"
            wifiNightsPriceLabel.text = "$\(numberOfNights * 10)"
            totalPriceLabel.text = "$\((roomType?.price ?? 0 * numberOfNights) + (numberOfNights * 10))"
            
        } else {
            wifiYesNoLabel.text = "No"
            wifiNightsPriceLabel.text = "$0"
            totalPriceLabel.text = "$\(roomType?.price ?? 0 * numberOfNights)"
        }

    }
    
    
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        calculatePrice()
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
