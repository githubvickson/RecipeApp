//
//  RecipeIngredientItem.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct RecipeIngredientItem : RecipeDetailViewModelItem {
    var rowCount: Int 
    
    var type: RecipeDetailViewModelItemType {
        return .ingredientList
    }
    
    var sectionTitle: String {
        return "Ingredient"
    }
    
    var ingredientItem: [Ingredient]
}
