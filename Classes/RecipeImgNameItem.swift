//
//  RecipeImgNameItem.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct RecipeImgNameItem : RecipeDetailViewModelItem {
    var rowCount: Int
    
    var type: RecipeDetailViewModelItemType {
        return .recipeImgName
    }
    
    var sectionTitle: String {
        return ""
    }
    
    var recipeItem: Recipe
}
