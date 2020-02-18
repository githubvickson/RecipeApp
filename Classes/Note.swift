//
//  Note.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct Note {
    var note : String = ""
}

extension Note: SQLTable, SQLQuery {
    static var createStatement: String {
      return """
          CREATE TABLE IF NOT EXISTS Note (recipeID INTEGER, id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, Note TEXT NOT NULL, Constraint fk_note_recipe FOREIGN KEY (recipeID) REFERENCES Recipe (id))
      """
    }
    
    static var insertStatement: String {
        return "INSERT INTO Note (recipeID, Note) VALUES (?,?)"
    }
    
    static var updateStatement: String {
        return "UPDATE Note SET Note = ? WHERE id = ?"
    }
    
    static var deleteStatement: String {
        return "Delete from Note where id = ?"
    }
    
    static var selectStatement: String {
        return "SELECT * FROM Note WHERE recipeID = ?"
    }
}
