//
//  Ingredient.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct Ingredient {
    var ingredient : String = ""
}

extension Ingredient: SQLTable, SQLQuery {
  static var createStatement: String {
    return """
        CREATE TABLE IF NOT EXISTS Ingredient (recipeID INTEGER, id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, Ingredient TEXT NOT NULL, Constraint fk_ingredient_recipe FOREIGN KEY (recipeID) REFERENCES Recipe (id))
    """
  }
    
    static var insertStatement: String {
        return "INSERT INTO Ingredient (recipeID, Ingredient) VALUES (?,?)"
    }
    
    static var updateStatement: String {
        return "UPDATE Ingredient SET Ingredient = ? WHERE id = ?"
    }
    
    static var deleteStatement: String {
        return "Delete from Ingredient where id = ?"
    }
    
    static var selectStatement: String {
        return "SELECT * FROM Ingredient WHERE recipeID = ?"
    }
}


