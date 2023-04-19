//
//  Helpers.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-13.
//

import Foundation

func dateFormatter() -> DateFormatter {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMM d, yyyy"
    return dateFormatter
}
