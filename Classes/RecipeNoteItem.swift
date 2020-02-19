//
//  RecipeNoteItem.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

struct RecipeNoteItem : RecipeDetailViewModelItem {
    var rowCount: Int
    
    var type: RecipeDetailViewModelItemType {
        return .noteList
    }
    
    var sectionTitle: String {
        return "Note"
    }
    
    var noteItem: [Note]
}
