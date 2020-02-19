//
//  Protocol.swift
//  RecipeApp
//
//  Created by Vickson on 17/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import Foundation

protocol SQLTable {
  static var createStatement: String { get }
}

protocol SQLQuery {
    static var selectStatement: String { get }
    static var insertStatement: String { get }
    static var updateStatement: String { get }
    static var deleteStatement: String { get }
}

protocol RecipeSqlQuery {
    static var updateRecipeImgStatement: String {get}
}

protocol RecipeDetailViewModelItem {
    var type: RecipeDetailViewModelItemType { get }
    var rowCount: Int { get }
    var sectionTitle: String { get }
}
