//
//  AddPaymentViewController.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-12.
//

import UIKit
import RealmSwift

class AddPaymentViewController: UIViewController, UITextFieldDelegate {

    
    //MARK: IBOutlets
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    //MARK: Vars
    
    let datePicker = UIDatePicker()
    var loan: Loan!
    var payment: Payment?
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("....Payment: \(payment?.amount)")
        configDatePicker()
        
        if payment != nil {
            updateUI()
        }
        
    }
    
    //MARK: Saving
    func saveNew() {
        let payment = Payment()
        payment.amount = Int(amountTextField.text!)!
        payment.loanID = loan.loanID
        payment.paymentID = UUID().uuidString
        payment.dateOfPayment = datePicker.date
        
        do {
            try realm.write {
                realm.add(payment)
            }
        } catch  {
            print("Error saving real object", error.localizedDescription)
        }
    }

    func updatePayment() {
        do {
            try realm.write {
                payment!.amount = Int(amountTextField.text!)!
                payment!.dateOfPayment = datePicker.date
            }
        } catch  {
            print("Error updating!", error.localizedDescription)
        }
    }
    
    
    //MARK: UpdateUI
    func updateUI() {
        amountTextField.text = "\(payment!.amount)"
        datePicker.setDate(payment!.dateOfPayment, animated: true)
        dateTextField.text = dateFormatter().string(from: payment!.dateOfPayment)
    }
    
    //MARK: DatePicker helpers
    func configDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        dateTextField.inputView = datePicker
        dateTextField.delegate = self
    }
    
    @objc func handleDatePicker() {
        dateTextField.text = dateFormatter().string(from: datePicker.date)
    }
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Started editing")
        if textField == dateTextField {
            dateTextField.text = dateFormatter().string(from: datePicker.date)
        }
        
    }

    
    //MARK: IBActions
    @IBAction func savePaymentBauttonPressed(_ sender: UIBarButtonItem) {
        if amountTextField.text != "" && dateTextField.text != "" {
            if payment == nil {
                //Save new
                saveNew()
            } else {
                //Update
                updatePayment()
            }
            
        } else {
            print("All fields are required")
        }
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
