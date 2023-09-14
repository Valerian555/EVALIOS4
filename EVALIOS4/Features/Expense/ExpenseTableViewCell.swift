//
//  ExpenseTableViewCell.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import UIKit

class ExpenseTableViewCell: UITableViewCell {

    @IBOutlet weak var expenseName: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setup(expense: Expense) {
        expenseName.text = expense.name
        expenseValue.text = floatToEuroString(expense.value)
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
}
