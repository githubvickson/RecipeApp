//
//  RecipeDetailImgNameViewCell.swift
//  RecipeApp
//
//  Created by Vickson on 19/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class RecipeDetailImgNameViewCell : UITableViewCell {
  
    static var cellIdentifier = "recipeDetailImgNameViewCell"
//    var item : RecipeDetailViewModelItem? {
//        didSet {
//            guard let item = item as? RecipeImgNameItem
//                else {
//                    return
//            }
//            imgView.image = UIImage(named: "add")
//            label.text = item.recipeItem.recipeName
//        }
//    }
    
    func updateImage(img : UIImage) {
        imgView.image = img
    }
    
    let imgView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "add")
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.text = "Recipe Name"
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(imgView)
        addSubview(label)
        setConstraint()
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: topAnchor),
            imgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imgView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            imageView?.widthAnchor.constraint(equalToConstant: frame.width),
            imgView.heightAnchor.constraint(equalToConstant: 250),
            
            label.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 5),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("Init Coder has not been implemented")
    }
}

