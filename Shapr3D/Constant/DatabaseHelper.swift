//
//  DatabaseHelper.swift
//  Shapr3D
//
//  Created by Muhammad Imran on 27/07/2021.
//

import Foundation
import UIKit
import CoreData


class CoreDataHelper {
    public static let shared = CoreDataHelper()
    
    func createData(fileData : Model , completionalHandler : @escaping (Bool)->()){
          
          guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
          let managedContext = appDelegate.persistentContainer.viewContext
          let userEntity = NSEntityDescription.entity(forEntityName: "Shapr3D", in: managedContext)!
         
        let data = NSManagedObject(entity: userEntity, insertInto: managedContext)
        data.setValue(fileData.fileName, forKey: "fileName")
        data.setValue(fileData.isSelected, forKey: "isSelected")
        data.setValue(fileData.size, forKey: "size")
        data.setValue(fileData.filePath, forKey: "filePath")
        data.setValue(fileData.progressObj, forKey: "progressObj")
        data.setValue(fileData.progressStep, forKey: "progressStep")
        data.setValue(fileData.progressStl, forKey: "progressStl")
        data.setValue(fileData.iSConvertedObj, forKey: "iSConvertedObj")
        data.setValue(fileData.isConvertedStl, forKey: "isConvertedStl")
        data.setValue(fileData.isConvertedStep, forKey: "isConvertedStep")
        data.setValue(fileData.uuid, forKey: "id")
        
          do {
              try managedContext.save()
             completionalHandler(true)
          } catch let error as NSError {
              print("Could not save. \(error), \(error.userInfo)")
            completionalHandler(false)
          }
      }
    
    
    func retrieveData(completionalHandler : @escaping ([Model])->(Void)){
        var arrayOfModel = [Model]()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shapr3D")
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    
                    let fileName = data.value(forKey: "fileName") as! String
                    let isSelected = data.value(forKey: "isSelected") as! Bool
                    let size = data.value(forKey: "size") as! String
                    let filePath = data.value(forKey: "filePath") as! String
                    let progressObj = data.value(forKey: "progressObj") as! Int
                    let progressStep = data.value(forKey: "progressStep") as! Int
                    let progressStl = data.value(forKey: "progressStl") as! Int
                    let iSConvertedObj = data.value(forKey: "iSConvertedObj") as! Bool
                    let isConvertedStep = data.value(forKey: "isConvertedStep") as! Bool
                    let isConvertedStl = data.value(forKey: "isConvertedStl") as! Bool
                    let uuid = data.value(forKey: "id") as! String
                    
                    
                    arrayOfModel.append(Model(isSelected: isSelected, fileName: fileName, size: size, filePath: filePath, progressObj: progressObj, progressStep: progressStep, progressStl: progressStl, iSConvertedObj: iSConvertedObj, isConvertedStep: isConvertedStep, isConvertedStl: isConvertedStl, uuid: uuid))
                   
                }
                
                completionalHandler(arrayOfModel)
                
                
            } catch {
                print("Failed")
            }
            
        }
    }
    
    
    func resultCount(itemName : String) -> Int{
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Shapr3D")
        fetchRequest.predicate = NSPredicate(format: "fileName = %@", itemName)
        do{
            let result = try managedContext.fetch(fetchRequest)
            if result.count == 1 {
                fetchRequest.predicate = NSPredicate(format: "fileName Like %@", "\(itemName) (")
                return result.count
            }
            
            return result.count

        }
        catch{
            return 0
        }
    }
    
    
    func updateData(fileData : Model){
    
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Shapr3D")
        fetchRequest.predicate = NSPredicate(format: "id = %@", fileData.uuid)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
   
                let objectUpdate = test[0] as! NSManagedObject
                objectUpdate.setValue("newName", forKey: "username")
                objectUpdate.setValue("newmail", forKey: "email")
                objectUpdate.setValue("newpassword", forKey: "password")
                do{
                    try managedContext.save()
                }
                catch
                {
                    print(error)
                }
            }
        catch
        {
            print(error)
        }
   
    }
    
    func deleteData(model : Model , completionalHandler : @escaping (Bool)->()){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Shapr3D")
        fetchRequest.predicate = NSPredicate(format: "id = %@", model.uuid)
       
        do
        {
            let data = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = data[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            
            do{
                try managedContext.save()
                completionalHandler(true)
                
            }
            catch
            {
                print(error)
                completionalHandler(false)
            }
            
        }
        catch
        {
            print(error)
            completionalHandler(false)
        }
    }
}
