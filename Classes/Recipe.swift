//
//  Recipe.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct Recipe {
    var id: Int32
    var recipeName: String
    var recipeType: String
    var img64Str : String
}

extension Recipe: SQLTable, SQLQuery {
    static var createStatement: String {
        return """
        CREATE TABLE IF NOT EXISTS Recipe (id INTEGER UNIQUE PRIMARY KEY AUTOINCREMENT, RecipeName TEXT NOT NULL, RecipeType TEXT NOT NULL, Image64Str TEXT NOT NULL)
        """
    }

    //TODO add order by latest
    static var selectStatement: String {
        return "SELECT * from Recipe where RecipeType = ?"
    }

    static var insertStatement: String {
        return "INSERT INTO Recipe (RecipeName, RecipeType, Image64Str) VALUES (?,?,?)"
    }

    static var updateStatement: String {
        return "UPDATE Recipe set RecipeName = ? where id = ?"
    }

    static var deleteStatement: String {
        return "Delete from Recipe where id = ?"
    }
}

//class Recipe {
    
//    init(recipeName : String, type : String, imgUrl : URL) {
//        recipeName
//    }
//}
