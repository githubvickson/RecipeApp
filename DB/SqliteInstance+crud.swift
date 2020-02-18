//
//  SqliteInstance+crud.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import SQLite3
import Foundation

enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}

extension SqliteInstance {
    fileprivate var errorMessage: String {
      if let errorPointer = sqlite3_errmsg(db) {
        let errorMessage = String(cString: errorPointer)
        return errorMessage
      } else {
        return "No error message provided from sqlite."
      }
    }
    
    func prepareStatement(sql: String) throws -> OpaquePointer? {
     var statement: OpaquePointer?
     guard sqlite3_prepare_v2(db, sql, -1, &statement, nil)
         == SQLITE_OK else {
       throw SQLiteError.Prepare(message: errorMessage)
     }
     return statement
    }
    
    func createTable(table: SQLTable.Type) throws {
      // 1
      let createTableStatement = try prepareStatement(sql: table.createStatement)
      // 2
      defer {
        sqlite3_finalize(createTableStatement)
      }
      // 3
      guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
        throw SQLiteError.Step(message: errorMessage)
      }
      print("\(table) table created.")
    }
    
    func insertRecipe(recipe: Recipe, sqlInsertQuery: SQLQuery.Type) throws {
        let insertStatement = try prepareStatement(sql: sqlInsertQuery.insertStatement)
      defer {
        sqlite3_finalize(insertStatement)
      }
    //  At some places (esp sqlite3_bind_xxx functions), typecast String to NSString and then convert to char*,
    // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
        let recipeName: NSString = recipe.recipeName as NSString
        let recipeType: NSString = recipe.recipeType as NSString
        let imgURL: NSString = recipe.img64Str as NSString
      guard
//        sqlite3_bind_int(insertStatement, 1, contact.id) == SQLITE_OK  &&
        sqlite3_bind_text(insertStatement, 1, recipeName.utf8String, -1, nil) == SQLITE_OK &&
        sqlite3_bind_text(insertStatement, 2, recipeType.utf8String, -1, nil) == SQLITE_OK &&
        sqlite3_bind_text(insertStatement, 3, imgURL.utf8String, -1, nil) == SQLITE_OK
        else {
          throw SQLiteError.Bind(message: errorMessage)
      }
      guard sqlite3_step(insertStatement) == SQLITE_DONE else {
        throw SQLiteError.Step(message: errorMessage)
      }
      print("Successfully inserted row.")
    }
    
    //For inserting Ingredient, Procesure and Note Items
    func insertSingleItem(sqlInsertQuery: SQLQuery.Type, id: Int32, value: String) throws {
        let insertStatement = try prepareStatement(sql: sqlInsertQuery.insertStatement)
          defer {
            sqlite3_finalize(insertStatement)
          }
        //  At some places (esp sqlite3_bind_xxx functions), typecast String to NSString and then convert to char*,
        // ex: (eventLog as NSString).utf8String. This is a weird bug in swift's sqlite3 bridging. this conversion resolves it.
            let v: NSString = value as NSString
          guard
            sqlite3_bind_int(insertStatement, 1, id) == SQLITE_OK  &&
            sqlite3_bind_text(insertStatement, 2, v.utf8String, -1, nil) == SQLITE_OK
            else {
              throw SQLiteError.Bind(message: errorMessage)
          }
          guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
          }
          print("Successfully inserted row.")
    }
    
    func getAllRecipe(querySql: SQLQuery.Type, recipeType: String) -> [Recipe] {
            var results: [Recipe] = []
            guard let queryStatement = try? prepareStatement(sql: querySql.selectStatement) else {
            return results
          }
          defer {
            sqlite3_finalize(queryStatement)
          }
          guard sqlite3_bind_text(queryStatement, 1, recipeType, -1, nil) == SQLITE_OK else {
            return results
          }
          
          while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            let id = sqlite3_column_int(queryStatement, 0)
            guard let queryResultRecipeName = sqlite3_column_text(queryStatement, 1) else {
              print("Query result is nil.")
              return results
            }
            guard let queryResultImg64Str = sqlite3_column_text(queryStatement, 3) else {
              print("Query result is nil.")
              return results
            }
            let r1 = String(cString: queryResultRecipeName)
            let r2 = String(cString: queryResultImg64Str)
            results.append(Recipe(id: id, recipeName: r1, recipeType: recipeType, img64Str: r2))
          }
          print("getallrecipe get called")
          return results
    }
    
    //get sql results from Ingredient, Note or Procedure
    func getAllResults(querySql: SQLQuery.Type, id: Int32) -> [String] {
        var results: [String] = []
        guard let queryStatement = try? prepareStatement(sql: querySql.selectStatement) else {
        return results
      }
      defer {
        sqlite3_finalize(queryStatement)
      }
      guard sqlite3_bind_int(queryStatement, 1, id) == SQLITE_OK else {
        return results
      }
      
      while (sqlite3_step(queryStatement) == SQLITE_ROW) {
//        let id = sqlite3_column_int(queryStatement, 0)
        guard let queryResultID = sqlite3_column_text(queryStatement, 1) else {
          print("Query result is nil.")
          return results
        }
        guard let queryResultString = sqlite3_column_text(queryStatement, 2) else {
          print("Query result is nil.")
          return results
        }
        let r = String(cString: queryResultString)
        results.append(r)
      }
        
      return results
    }
}


