//
//  AllLoansViewController.swift
//  LoanCalculator
//
//  Created by Seiken Dojo on 2023-03-11.
//

import UIKit
import RealmSwift

class AllLoansViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Vars
    let realm = try! Realm()
    var allLoans: Results<Loan>!
    //var allLoans: [Loan] = []
    
    var notificationToken: NotificationToken?
    
    override func viewWillAppear(_ animated: Bool) {
        //we call this function here cause viewdidLoad will run once but we want to listen to changes everytime view will appear
        loadAllLoans()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //every time view will disappear we stop listening to notification token
        notificationToken?.invalidate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLoans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let loan = allLoans[indexPath.row]
        cell.textLabel?.text = loan.name
        cell.detailTextLabel?.text = "\(loan.totalAmount)"
        return cell
    }
    
    //MARK: TableView delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let objectTodelete = allLoans[indexPath.row]
                //Delete from data base
            do {
                try realm.write {
                    realm.delete(objectTodelete)
                }
            } catch  {
                print("Error deleting from DB", error.localizedDescription)
            }
            //Delete from table view
        tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "allLoansToDetailSeg", sender: indexPath)
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allLoansToDetailSeg" {
            let indexPath = sender as! IndexPath
            let loanDetailVC = segue.destination as! LoanDetailViewController
            loanDetailVC.loan = allLoans[indexPath.row]
            
        }
    }

    
    //MARK: Fetch loans from DB
    func loadAllLoans() {
        allLoans = realm.objects(Loan.self)
        notificationToken = allLoans.observe ({ (changes: RealmCollectionChange) in
            guard let tableView = self.tableView else { return }
            tableView.reloadData()
        })
    }


}

