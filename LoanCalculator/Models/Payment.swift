//
//  Payment.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-12.
//

import Foundation
import RealmSwift


class Payment: Object {
    @objc dynamic var loanID = ""
    @objc dynamic var paymentID = ""
    @objc dynamic var amount = 0
    @objc dynamic var dateOfPayment = Date()
    
    func describePayment() {
        print("LoanID: \(loanID) /n  PaymentID: \(paymentID) /n  Amount: \(amount) /n Date: \(dateOfPayment) ")
    }
    
}
