//
//  RecipeProcedureItem.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct RecipeProcedureItem : RecipeDetailViewModelItem {
    var rowCount: Int
    
    var type: RecipeDetailViewModelItemType {
        return .procedureList
    }
    
    var sectionTitle: String {
        return "Procedure"
    }
    
    var procedureItem: [Procedure]
}
