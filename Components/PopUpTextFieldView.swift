//
//  PopUpTextFieldView.swift
//  RecipeApp
//
//  Created by Vickson on 20/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class PopUpTextFieldView: UIView {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Add Ingredient"
        label.textAlignment = .center
        return label
    }()
    
    
    let txtField: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        txtField.textColor = UIColor.gray
        txtField.placeholder = "Edit here"
        txtField.textAlignment = .center
        txtField.becomeFirstResponder()
        return txtField
    }()
    
    let confirmBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Add", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(rgb: 0xFF1744)
        btn.layer.cornerRadius = 10
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return btn
    }()
    
    let container: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    lazy var stack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, txtField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    @objc func animateOut() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: -self.frame.height)
        self.alpha = 1
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animateOut)))
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        self.frame = UIScreen.main.bounds
        self.addSubview(container)
      
        NSLayoutConstraint.activate([
        container.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        container.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        container.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.7),
        container.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.45),
        ])
            
        container.addSubview(stack)
        container.addSubview(confirmBtn)
        NSLayoutConstraint.activate([
        stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
        stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
//        stack.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            stack.topAnchor.constraint(equalTo: container.topAnchor),
        stack.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.5),
        
        confirmBtn.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 30),
        confirmBtn.centerXAnchor.constraint(equalTo: self.centerXAnchor),
        confirmBtn.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: 0.3),
        confirmBtn.heightAnchor.constraint(equalTo: container.heightAnchor, multiplier: 0.1),
        
        ])
        
        animateIn()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
