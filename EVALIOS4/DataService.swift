//
//  DataService.swift
//  EVALIOS4
//
//  Created by Student08 on 14/09/2023.
//

import Foundation
import CoreData

class DataService {
    //Créer une instance partagée qui pourra être appelée dans toute mon app (Singleton)
    static let shared = DataService()
    
    //permet d'accéder à ma db et de faire des opérations de lecture et d'écriture.
    let context: NSManagedObjectContext
    
    init() {
        //contient les modèles de ma db.
        let container = NSPersistentContainer(name: "Accounting")
        
        //définis l'emplacement où la base de données SQLite sera stockée.
        let dbFileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathExtension("db.sqlite")
        
        let storeDescription = NSPersistentStoreDescription(url: dbFileURL)
        container.persistentStoreDescriptions = [storeDescription]
        
        //Chargement de la base de données
        container.loadPersistentStores {description, error in
            if let error = error {
                print("Error loading persistent store:", error)
            }
        }
        context = container.viewContext
        
        initializeDb()
    }
    
    //utiliser pour enregistrer les modifications apportées à la base de données
    private func saveContext() {
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Error saving context", error)
        }
    }
    
    
    //MARK: - Sections
    
    //ajout d'une section
    func addSection(name: String) {
        let section = ExpenseSection(context: context)
        
        section.name = name
        
        saveContext()
    }
    
    //suppression d'une catégorie
    func deleteExpenseSection(_ expenseSection: ExpenseSection) {
        context.delete(expenseSection)

        saveContext()
    }
    
    //MARK: - Expense
    
    //ajout d'une dépense
    func addExpense(name: String, value: Float, date: Date, section: ExpenseSection) {
        let expense = Expense(context: context)
        
        expense.name = name
        expense.value = value
        expense.date = date
        expense.section = section
        
        saveContext()
    }
    
    //suppression d'une dépense
    func deleteExpense(_ expense: Expense) {
        context.delete(expense)
        
        saveContext()
    }
    
    //initaliser la db avec des sections par défaut
    private func initializeDb() {
        let fetchRequest: NSFetchRequest<ExpenseSection> = ExpenseSection.fetchRequest()
           
           do {
               let sectionCount = try context.count(for: fetchRequest)
               
               //Si aucune section n'existe, j'ajoute
               if sectionCount == 0 {
                   addSection(name: "Loisirs")
                   addSection(name: "Loyer")
                   addSection(name: "Voiture")
                   addSection(name: "Alimentaire")
                   addSection(name: "Animaux")
               }
           } catch {
               print("Error initializing database:", error)
           }
       }
    }
