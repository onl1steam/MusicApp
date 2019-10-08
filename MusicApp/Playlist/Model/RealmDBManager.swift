//
//  RealmDBService.swift
//  MusicApp
//
//  Created by Рыжков Артем on 08.10.2019.
//  Copyright © 2019 Рыжков Артем. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDBManager {
    private var database: Realm
    static let shared = RealmDBManager()
    private init() {
       database = try! Realm()
    }
    
    func getDataFromDB() -> Results<TrackObject> {
      let results: Results<TrackObject> = database.objects(TrackObject.self)
      return results
     }
    
     func addData(object: TrackObject)   {
          try! database.write {
             database.add(object, update: true)
             print("Added new object")
          }
     }
    
      func deleteAllFromDatabase()  {
           try! database.write {
               database.deleteAll()
           }
      }
    
      func deleteFromDb(object: TrackObject)   {
          try! database.write {
             database.delete(object)
          }
      }
}
