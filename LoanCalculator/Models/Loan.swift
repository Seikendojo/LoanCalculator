//
//  Loan.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-12.
//

import Foundation
import RealmSwift

class Loan: Object {
  @Persisted var name = ""
  @Persisted var loanID = ""
  @Persisted var totalAmount = 0
  @Persisted var dueDate = Date()
    
    func describeLoan() {
        print("Name: \(name) \n total amount: \(totalAmount) \n dueDate: \(dueDate)")
    }
    
    
    
}


