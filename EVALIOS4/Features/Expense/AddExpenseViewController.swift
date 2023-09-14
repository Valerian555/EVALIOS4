//
//  AddExpenseViewController.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import UIKit

class AddExpenseViewController: UIViewController {

    //MARK: - Properties
    @IBOutlet weak var expenseNameInput: UITextField!
    @IBOutlet weak var expenseValueInput: UITextField!
    @IBOutlet weak var expenseTimePicker: UIDatePicker!
    @IBOutlet weak var expenseSectionPicker: UIPickerView!
    private var section = [ExpenseSection]()
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        //titre de la modal
        self.title = "Ajouter une dépense"
        
        //gestion du section picker
        expenseSectionPicker.delegate = self
        expenseSectionPicker.dataSource = self
        
        //Une requête pour récupérer toutes les catégories de recettes depuis Core Data, triées par ordre alphabétique.
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            section = try DataService.shared.context.fetch(request)
        } catch {
            print("Unable to fetch category", error)
        }
    }
    

    @IBAction func saveExpenseTap(_ sender: Any) {
        guard let name = expenseNameInput.text, let value = expenseValueInput.text else { return }
        
        guard !name.isEmpty else {
            errorAlertMessage(message: "Veuillez saisir un nom.")
            return
        }
        
        let formatter = NumberFormatter()
        guard !value.isEmpty, let _ = formatter.number(from: value) else {
            errorAlertMessage(message: "Veuillez saisir un montant valide.")
            return
        }
        
        
        //insertion de la recette dans la db
        DataService.shared.addExpense(name: name,
                                      value: Float(value) ?? 0,
                                      date: expenseTimePicker.date,
                                      section: section[expenseSectionPicker.selectedRow(inComponent: 0)])
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cancelTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func errorAlertMessage(message: String) {
        let alert = UIAlertController(title: "ERROR", message: message, preferredStyle:
                .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - Picker Extension
extension AddExpenseViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        section.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        section[row].name
    }
}
