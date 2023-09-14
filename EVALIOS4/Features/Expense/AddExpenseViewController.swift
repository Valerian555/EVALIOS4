//
//  AddExpenseViewController.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var addExpenseButton: UIButton!
    @IBOutlet weak var expenseNameInput: UITextField!
    @IBOutlet weak var expenseValueInput: UITextField!
    @IBOutlet weak var expenseTimePicker: UIDatePicker!
    @IBOutlet weak var expenseSectionPicker: UIPickerView!
    private var section = [ExpenseSection]()
    
    //MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //timePicker UI
        expenseTimePicker.contentHorizontalAlignment = .center
        expenseTimePicker.layer.cornerRadius = 5
        expenseTimePicker.clipsToBounds = true
        expenseTimePicker.backgroundColor = .white
        expenseTimePicker.layer.borderWidth = 0.5
        expenseTimePicker.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        
        //sectionPicker UI
        expenseSectionPicker.layer.cornerRadius = 5
        expenseSectionPicker.clipsToBounds = true
        expenseSectionPicker.backgroundColor = .white
        expenseSectionPicker.layer.borderWidth = 0.5
        expenseSectionPicker.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        
        //add button UI
        addExpenseButton.layer.cornerRadius = 24
        addExpenseButton.clipsToBounds = true
        
        //titre de la modal
        self.title = "Ajouter une dépense"
        
        //gestion du section picker
        expenseSectionPicker.delegate = self
        expenseSectionPicker.dataSource = self
        
        //Une requête pour récupérer toutes les sections
        let request = ExpenseSection.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            section = try DataService.shared.context.fetch(request)
        } catch {
            print("Unable to fetch category", error)
        }
    }
    
    
    //MARK: - Ajout dépense
    @IBAction func saveExpenseTap(_ sender: Any) {
        //vérification des champs
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
        
        //insertion de la dépense dans la db
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
