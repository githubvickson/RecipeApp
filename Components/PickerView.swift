//
//  PickerView.swift
//  RecipeApp
//
//  Created by Vickson on 18/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class PickerView : UIView {
    
    let pickerView: UIPickerView = {
        let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.backgroundColor = .white
        pv.showsSelectionIndicator = true
        
        return pv
    }()
    
    let doneBtn: UIBarButtonItem = {
        let db = UIBarButtonItem()
        db.title = "Done"
        db.style = UIBarButtonItem.Style.plain
        
        return db
    }()
    
    let spaceBtn: UIBarButtonItem = {
        let db = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        return db
    }()
    
    let cancelBtn: UIBarButtonItem = {
        let db = UIBarButtonItem()
        db.title = "Cancel"
        db.style = UIBarButtonItem.Style.plain
        
        return db
    }()
    
    let toolBar: UIToolbar = {
        let tb = UIToolbar()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.isUserInteractionEnabled = true
        tb.barStyle = UIBarStyle.default
        tb.isTranslucent = true
        tb.tintColor = UIColor(rgb: 0xFF1744)
        tb.sizeToFit()
    
        return tb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pickerView)
        addSubview(toolBar)
        toolBar.setItems([cancelBtn, spaceBtn, doneBtn], animated: false)
        NSLayoutConstraint.activate([
            toolBar.topAnchor.constraint(equalTo: topAnchor),
            toolBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 40),
            
            pickerView.topAnchor.constraint(equalTo: toolBar.bottomAnchor),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
