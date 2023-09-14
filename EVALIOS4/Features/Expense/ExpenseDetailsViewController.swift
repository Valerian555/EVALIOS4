//
//  ExpenseDetailsViewController.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import UIKit

class ExpenseDetailsViewController: UIViewController {
    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    @IBOutlet weak var expenseDate: UILabel!
    var expense: Expense?

    override func viewDidLoad() {
        super.viewDidLoad()

        expenseName.text = expense?.name
        expenseValue.text = floatToEuroString(expense!.value)
        expenseDate.text = DateToString(date: (expense?.date)!)
    }

    func floatToEuroString(_ value: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        
        if let euroString = formatter.string(from: NSNumber(value: value)) {
            return euroString
        } else {
            return "\(value) €"
        }
    }
    
    func DateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
    }
}
