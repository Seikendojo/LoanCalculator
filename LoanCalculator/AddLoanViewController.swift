//
//  AddLoanViewController.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-11.
//

import UIKit
import RealmSwift


class AddLoanViewController: UIViewController {

    //MARK: IBOutlets
    @IBOutlet weak var loanNameTxtField: UITextField!
    @IBOutlet weak var loanAmountTxtField: UITextField!
    @IBOutlet weak var interestRateTxtField: UITextField!
    @IBOutlet weak var durationTxtField: UITextField!
    @IBOutlet weak var totalDueTxtField: UITextField!
    
    var realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: IBActions
    @IBAction func saveBarButtonPressed(_ sender: UIBarButtonItem) {
        if loanNameTxtField.text != "" && loanAmountTxtField.text != "" && interestRateTxtField.text != "" && durationTxtField.text != "" {
           totalDueTxtField.text =  calculateTotal()
           saveLoan()
        } else {
            print("All fields are required!")
        }
    }
    
    
    @IBAction func backGroundTap(_ sender: UITapGestureRecognizer) {
        //Hide keyboard
        view.endEditing(false)
    }
    
    //MARK: Helpers
    
    func saveLoan() {
        let loan = Loan()
        loan.name = loanNameTxtField.text!
        loan.totalAmount = Int(totalDueTxtField.text!)!
        loan.loanID = UUID().uuidString
        
            //Generate date
        var dateComponent = DateComponents()
        dateComponent.year = Int(durationTxtField.text!)!
        
        //we can add more date componets like so
//        dateComponent.month = 1
//        dateComponent.day = 7
        loan.dueDate = Calendar.current.date(byAdding: dateComponent, to: Date())!
        loan.describeLoan()
        
        do {
            try realm.write {
                realm.add(loan)
            }
        } catch  {
            print("Error saving real object", error.localizedDescription)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    func calculateTotal() -> String {
        guard let years = Int(durationTxtField.text!),
              let amount = Int(loanAmountTxtField.text!),
              let intersetRate = Int(interestRateTxtField.text!) else { return "" }
      
        let interestPerYear = (amount/100) * intersetRate
        return "\(interestPerYear * years + amount)"
    }

   
}
