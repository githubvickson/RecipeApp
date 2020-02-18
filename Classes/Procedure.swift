//
//  Procedure.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct Procedure {
    var procedure : String = ""
}

extension Procedure: SQLTable, SQLQuery {
  static var createStatement: String {
    return """
        CREATE TABLE IF NOT EXISTS Procedure (recipeID INTEGER, id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT ,Procedure TEXT NOT NULL, Constraint fk_procedure_recipe FOREIGN KEY (recipeID) REFERENCES Recipe (id))
    """
  }
    
    static var insertStatement: String {
        return "INSERT INTO Procedure (recipeID, Procedure) VALUES (?,?)"
    }
    
    static var updateStatement: String {
        return "UPDATE Procedure SET Procedure = ? WHERE id = ?"
    }
    
    static var deleteStatement: String {
        return "Delete from Procedure where id = ?"
    }
    
    static var selectStatement: String {
        return "SELECT * FROM Procedure WHERE recipeID = ?"
    }
}
