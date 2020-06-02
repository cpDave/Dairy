//
//  CoreData_BussinessLogic.swift
//  MY DAIRY
//
//  Created by Cp on 29/05/20.
//  Copyright © 2020 Cp. All rights reserved.
//

import Foundation
import CoreData
import CoreServices
class CoreData_BussinessLogic:NSObject {
    
    //Variables

    let context = AppDelegate.init().persistentContainer.viewContext

    //Check value is availale or not
     func isNotesAvailable(ids: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DairyList")
        let predicate = NSPredicate(format: "id == %@", ids)
        request.predicate = predicate
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            if (count == 0) {
                return false
            } else {
                return true
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return false
    }
    
    // sabe and edit notes
     func saveOrUpdateNotesList(notes: notesModel) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        if self.isNotesAvailable(ids: notes.id)  {
            //update
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DairyList")
            fetchRequest.predicate = NSPredicate(format: "id = %@", notes.id)
            do {
                let results = try context.fetch(fetchRequest) as? [NSManagedObject]

                if let first = results?.first {
                    first.setValue(notes.id, forKey: "id")
                    first.setValue(notes.title, forKey: "title")
                    first.setValue(notes.content, forKey: "content")
                    first.setValue(notes.date, forKey: "date")
                    try context.save()
                }
            } catch {
                print("Fetch Failed: \(error)")
            }

        } else {
            //save
            let Notes = DairyList(context: context)
            Notes.id = notes.id
            Notes.title = notes.title
            Notes.content = notes.content
            Notes.date = notes.date
            
            do {
                try context.save()
            } catch {
                print("Error = ", error.localizedDescription)
            }
        }
    }
    
    //delete notes
    func deleteNotes(Id: String){
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DairyList")
        fetchRequest.predicate = NSPredicate(format: "id = %@", Id)
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results!.count > 0{
                for object in results! {
                    context.delete(object)
                    try context.save()
                }
            }
        }
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    //get notes
    func getNotesFromLocal() -> [notesModel]{
        var notes:[notesModel] = []
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "DairyList")
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                
                let ids = data.value(forKey: "id") as AnyObject
                let title = data.value(forKey: "title") as AnyObject
                let content = data.value(forKey: "content") as AnyObject
                let date = data.value(forKey: "date") as AnyObject
                
                let note = notesModel(id: ids as! String, title: title as! String, content: content as! String, date: date as! String)
                notes.append(note)
            }
        } catch {
            print("Fetching Failed")
        }
        return notes
    }
}
