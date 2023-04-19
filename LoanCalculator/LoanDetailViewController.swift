//
//  LoanDetailViewController.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-12.
//

import UIKit
import RealmSwift

class LoanDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var paidLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    
    
    //MARK: Vars
    var allPayments: Results<Payment>!
    var loan: Loan!
    let realm = try! Realm()
    var paid = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchPayments()
        calculatePayments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if loan != nil {
            self.title = loan.name
        }
        totalAmountLabel.text = "Total amount: \(loan.totalAmount)"
    }
 
   
    //MARK: TableView Data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allPayments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let payment = allPayments[indexPath.row]
        cell.textLabel?.text = "\(payment.amount)"
        cell.detailTextLabel?.text = dateFormatter().string(from: payment.dateOfPayment)
        
        return cell
    }
    
    //MARK: TableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "loanDetailToAddPaymentSeg", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm.write {
                    realm.delete(allPayments[indexPath.row])
                }
            } catch  {
                print("Error deleting payment!", error.localizedDescription)
            }
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
        calculatePayments()
    }
    
    //MARK: Load Payments from DB
    func fetchPayments() {
        guard loan != nil else { return }
        let predicate = NSPredicate(format: "loanID = %@", argumentArray: [loan.loanID])
        //get all the payments and assign it to allPayments array
        allPayments = realm.objects(Payment.self).filter(predicate).sorted(byKeyPath: "dateOfPayment", ascending: false)
        tableView.reloadData()
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loanDetailToAddPaymentSeg" {
            let addPaymentVC = segue.destination as! AddPaymentViewController
            addPaymentVC.loan = loan
            if let indexPath = sender as? IndexPath {
                addPaymentVC.payment = allPayments[indexPath.row]
            }
        }
    }
    
    //MARK: UpdateUI
    func updateUI() {
        totalAmountLabel.text = "Total: \(loan.totalAmount)"
        paidLabel.text = "Paid: \(paid)"
        leftLabel.text = "Left: \(loan.totalAmount - paid)"
    }
    
    func calculatePayments() {
        paid = 0
        for payment in allPayments {
            paid += payment.amount
        }
        updateUI()
    }


    
    
}
