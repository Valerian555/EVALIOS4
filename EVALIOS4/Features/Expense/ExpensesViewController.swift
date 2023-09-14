//
//  ViewController.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var expensesTableview: UITableView!
    private var resultsController: NSFetchedResultsController<Expense>!
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Dépenses"
        
        //gestion de la tableview
        expensesTableview.dataSource = self
        expensesTableview.delegate = self
        expensesTableview.register(UINib(nibName: "ExpenseTableViewCell", bundle: nil),
                                   forCellReuseIdentifier: "ExpenseTableViewCell")
        
        let request = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "section.name", ascending: true),
                                   NSSortDescriptor(key: "name", ascending: true)]
        resultsController = NSFetchedResultsController(fetchRequest: request,
                                                       managedObjectContext: DataService.shared.context,
                                                       sectionNameKeyPath: "section.name",
                                                       cacheName: nil)
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Error fetching initial data", error)
        }
    }
    
    @IBAction func addExpenseTap(_ sender: Any) {
        let addRecipeViewController =
        storyboard?.instantiateViewController(identifier:
                                                "AddExpenseNav")
        
        addRecipeViewController?.modalPresentationStyle = .automatic
        
        present(addRecipeViewController!, animated: true, completion:
                    nil)
    }
}

//MARK: - TableView extension
extension ExpensesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        resultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier:
                                                        "ExpenseTableViewCell", for: indexPath) as! ExpenseTableViewCell
        let expense = resultsController.object(at: indexPath)
        
        customCell.setup(expense: expense)
        
        return customCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expense = resultsController.object(at: indexPath)
            DataService.shared.deleteExpense(expense)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        resultsController.sections?[section].name
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //instancier le ViewController de destination
        let expenseDetailsViewController = storyboard?.instantiateViewController(identifier: "ExpenseDetailsViewController") as! ExpenseDetailsViewController
        
        let expense = resultsController.object(at: indexPath)
        
        expenseDetailsViewController.expense = expense
        
        
        //méthode permettant la navigation
        navigationController?.pushViewController(expenseDetailsViewController, animated: true)
    }
}

//MARK: - ResultsController Delegate
extension ExpensesViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        expensesTableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        expensesTableview.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            expensesTableview.insertSections([sectionIndex], with: .automatic)
        case .delete:
            expensesTableview.deleteSections([sectionIndex], with: .automatic)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            expensesTableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            expensesTableview.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            expensesTableview.deleteRows(at: [indexPath!], with: .automatic)
            expensesTableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            expensesTableview.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
}

