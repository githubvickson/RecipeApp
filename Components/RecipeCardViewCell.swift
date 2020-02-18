//
//  RecipeCardViewCell.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class RecipeCardViewCell: UITableViewCell {
    
//    var recipe: Recipe? {
//        didSet {
//            recipeName.text = recipe?.recipeName
//        }
//    }
    
    let recipeName : UILabel = {
        let lbl = UILabel()
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor(rgb: 0xFFFFFF)
        lbl.textColor = UIColor(rgb: 0x212121)
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .center
        lbl.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            lbl.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        } else {
            // Fallback on earlier versions
        }
        lbl.layer.masksToBounds = true
        
        return lbl
    }()
    
    let recipeImageView : UIImageView = {
        let imgView = UIImageView()
        let img = UIImage()
        
        imgView.backgroundColor = .white
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.image = img
        imgView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        imgView.layer.cornerRadius = 5
        if #available(iOS 11.0, *) {
            imgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            // Fallback on earlier versions
        }
        imgView.layer.masksToBounds = true
        imgView.clipsToBounds = true
        
        return imgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(recipeImageView)
        addSubview(recipeName)
        setConstraint()
    }
    
    func setConstraint() {
        NSLayoutConstraint.activate([
            
            recipeImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            recipeImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recipeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            recipeName.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor),
            recipeName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            recipeName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            recipeName.heightAnchor.constraint(equalToConstant: 50),
            recipeName.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


