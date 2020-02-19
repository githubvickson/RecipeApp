//
//  RecipeDetailProcedureViewCell.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class RecipeDetailProcedureViewCell : UITableViewCell {
    
    static var cellIdentifier = "recipeDetailProcedureViewCell"
    
//    var item : RecipeDetailViewModelItem? {
//        didSet {
//            guard let item = item as? RecipeProcedureItem
//                else {
//                    return
//            }
//            label.text = "item.procedureItem[0].procedure"
//        }
//    }
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.text = "Procedure"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(label)
        setConstraint()
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init Coder has not been initialize")
    }
    
}
