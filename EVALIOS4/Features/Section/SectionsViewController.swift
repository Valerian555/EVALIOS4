//
//  SectionsViewController.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import UIKit
import CoreData

class SectionsViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var sectionsTableview: UITableView!
    private var resultsController: NSFetchedResultsController<ExpenseSection>!
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Sections"
        
        //gestion de la tableView
        sectionsTableview.dataSource = self
        
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        resultsController = NSFetchedResultsController(fetchRequest: request,
                                                       managedObjectContext: DataService.shared.context,
                                                       sectionNameKeyPath: nil,
                                                       cacheName: nil)
        resultsController.delegate = self
        
        do {
            try resultsController.performFetch()
        } catch {
            print("Error fetching initial data", error)
        }
    }
    
    //MARK: - Ajout d'une section
    @IBAction func addSectionTap(_ sender: Any) {
        //affichage de l'alert
        let alertController = UIAlertController(title: "Ajouter un type de dépense", message: nil, preferredStyle: .alert)
        
        //placeholder
        alertController.addTextField { (textField) in
            textField.placeholder = "Loisirs"
        }
        
        let cancelAction = UIAlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        let addAction = UIAlertAction(title: "Ajouter", style: .default) { (_) in
            if let textField = alertController.textFields?.first,
               let sectionName = textField.text {
                
                //insertion de la section
                DataService.shared.addSection(name: sectionName)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

//MARK: - TableView Extension
extension SectionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expenseSection = resultsController.object(at: indexPath)
        
        let cell = UITableViewCell()
        cell.textLabel?.text = expenseSection.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let expenseSection = resultsController.object(at: indexPath)
            DataService.shared.deleteExpenseSection(expenseSection)
        }
    }
}

//MARK: - ResultsController Extension
extension SectionsViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sectionsTableview.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sectionsTableview.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            sectionsTableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            sectionsTableview.deleteRows(at: [indexPath!], with: .automatic)
        case .move:
            sectionsTableview.deleteRows(at: [indexPath!], with: .automatic)
            sectionsTableview.insertRows(at: [newIndexPath!], with: .automatic)
        case .update:
            sectionsTableview.reloadRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
}
