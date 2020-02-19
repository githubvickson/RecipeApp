//
//  RecipeViewModel.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class RecipeViewModel: NSObject {
    
    var recipeViewModelItems = [RecipeDetailViewModelItem]()
    var delegate: DetailController?
    
    override init() {
        super.init()
    }
}

extension RecipeViewModel: UITableViewDataSource, UITableViewDelegate {
    func decodeImage64Str(img64Str: String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: img64Str, options: .ignoreUnknownCharacters)!
        guard let decodedimage = UIImage(data: dataDecoded) else { return UIImage(named: "add")! }
        return decodedimage
    }
   func numberOfSections(in tableView: UITableView) -> Int {
      return recipeViewModelItems.count
   }
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return recipeViewModelItems[section].rowCount
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let recipeItem = recipeViewModelItems[indexPath.section]
    switch recipeItem.type {
        case .recipeImgName:
            tableView.register(RecipeDetailImgNameViewCell.self, forCellReuseIdentifier: RecipeDetailImgNameViewCell.cellIdentifier)
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailImgNameViewCell.cellIdentifier, for: indexPath) as? RecipeDetailImgNameViewCell {
                let r = recipeItem as! RecipeImgNameItem
                cell.selectionStyle = .none
                cell.imgView.image = decodeImage64Str(img64Str: r.recipeItem.img64Str)
                cell.label.text = r.recipeItem.recipeName
                return cell
        }
        case .ingredientList:
            tableView.register(RecipeDetailIngredientViewCell.self, forCellReuseIdentifier: RecipeDetailIngredientViewCell.cellIdentifier)
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailIngredientViewCell.cellIdentifier, for: indexPath) as? RecipeDetailIngredientViewCell {
                cell.selectionStyle = .none
                let ri = recipeItem as! RecipeIngredientItem
                cell.label.text = "\(indexPath.row + 1)) \(ri.ingredientItem[indexPath.row].ingredient)"
                return cell
        }
        case .procedureList:
            tableView.register(RecipeDetailProcedureViewCell.self, forCellReuseIdentifier: RecipeDetailProcedureViewCell.cellIdentifier)
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailProcedureViewCell.cellIdentifier, for: indexPath) as? RecipeDetailProcedureViewCell {
                cell.selectionStyle = .none
                let rp = recipeItem as! RecipeProcedureItem
                cell.label.text = "\(indexPath.row + 1)) \(rp.procedureItem[indexPath.row].procedure)"
                return cell
        }
        case .noteList:
            tableView.register(RecipeDetailNoteViewCell.self, forCellReuseIdentifier: RecipeDetailNoteViewCell.cellIdentifier)
            if let cell = tableView.dequeueReusableCell(withIdentifier: RecipeDetailNoteViewCell.cellIdentifier, for: indexPath) as? RecipeDetailNoteViewCell {
                cell.selectionStyle = .none
                let rn = recipeItem as! RecipeNoteItem
                cell.label.text = "\(indexPath.row + 1)) \(rn.noteItem[indexPath.row].note)"
                return cell
        }
    }
      return UITableViewCell()
   }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xFF1744)

        let label = UILabel()
        
        label.text = recipeViewModelItems[section].sectionTitle
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2).isActive = true
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -2).isActive = true
        label.textAlignment = .left
        
        return view

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row \(indexPath)")
        let recipeItem = recipeViewModelItems[indexPath.section]
        switch recipeItem.type {
            case .recipeImgName:
                delegate?.pickImageFromImageGallery()
                break
            case .ingredientList:
                delegate?.onEditIngredient(indexRow: indexPath.row)
                break
            case .procedureList:
                break
            case .noteList:
                break
        }
    }
}
