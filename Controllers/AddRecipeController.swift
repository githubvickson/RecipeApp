//
//  AddRecipeController.swift
//  RecipeApp
//
//  Created by Vickson on 18/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class AddRecipeController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var image64Str = String()
    var recipeNameString = String()
    var recipeTypeSelected = String()
    var recipeTypes: [RecipeType] = []
    var recipeNameTextField = UITextField()
    var recipeTypeTextField = UITextField()
    var recipeImageUpload = UIImageView()
    var recipeTypePickerView = PickerView()
    var delegate = MainController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        recipeTypes = delegate.recipeTypes
        recipeNameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        recipeNameTextField.backgroundColor = .white
        recipeNameTextField.placeholder = "Recipe Name"
        recipeNameTextField.textAlignment = .center
        recipeNameTextField.delegate = self
        recipeTypeTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        recipeTypeTextField.backgroundColor = .white
        recipeTypeTextField.placeholder = "Recipe Type"
        recipeTypeTextField.textAlignment = .center
        recipeImageUpload = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        recipeImageUpload.image = UIImage(named: "add")
        recipeImageUpload.contentMode = .scaleAspectFill
        recipeImageUpload.backgroundColor = .blue
        recipeImageUpload.layer.borderWidth = 1
        recipeImageUpload.layer.borderColor = UIColor.white.cgColor
        view.addSubview(recipeNameTextField)
        view.addSubview(recipeTypeTextField)
        view.addSubview(recipeImageUpload)
        
        loadConstraints()
        loadTapGesture()
        loadNavigationItem()
        delegate.recipeFilterPicker.cancelBtn.target = self
        delegate.recipeFilterPicker.cancelBtn.action = #selector(cancelFilterRecipeType)
        delegate.recipeFilterPicker.doneBtn.target = self
        delegate.recipeFilterPicker.doneBtn.action = #selector(confirmFilterRecipeType)
        recipeTypeTextField.inputView = delegate.recipeFilterPicker
    }
    
    func loadTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(pickImageFromImageGallery(sender:)))
        recipeImageUpload.addGestureRecognizer(tapGesture)
        recipeImageUpload.isUserInteractionEnabled = true
    }
    
    func loadNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(confirmAddRecipe))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelAddRecipe))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    //reassign delegate' pickerview toolbar button as it was modified when this viewcontroller is loaded
    func reAssignDelegatePickerToolbar() {
        delegate.recipeFilterPicker.cancelBtn.target = delegate
        delegate.recipeFilterPicker.cancelBtn.action = #selector(delegate.cancelRecipeTypeFilter(sender:))
        delegate.recipeFilterPicker.doneBtn.target = delegate
        delegate.recipeFilterPicker.doneBtn.action = #selector(delegate.confirmRecipeTypeFilter(sender:))
    }
    
    @objc func cancelAddRecipe() {
        reAssignDelegatePickerToolbar()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func confirmAddRecipe() {
        recipeNameTextField.resignFirstResponder()
        recipeTypeTextField.resignFirstResponder()
        if imageNotEmpty() == false {
            showToast(message: "Please Insert Image", font: UIFont.boldSystemFont(ofSize: 16))
            return
        }
        if recipeNameNotEmpty() == false {
            showToast(message: "Please Input Recipe Name", font: UIFont.boldSystemFont(ofSize: 16))
            return
        }
        if recipeTypeNotEmpty() == false {
            showToast(message: "Please Select Recipe Type", font: UIFont.boldSystemFont(ofSize: 16))
            return
        }
        do {
            try delegate.mainControllerDB.insertRecipe(recipe: Recipe(id: 0, recipeName: recipeNameTextField.text!, recipeType: recipeTypeSelected, img64Str: image64Str), sqlInsertQuery: Recipe.self)
        } catch {
            print("error inserting recipe")
        }
        reAssignDelegatePickerToolbar()
        delegate.reloadTableViewData()
        navigationController?.popViewController(animated: true)
    }
    
    func loadConstraints() {
        recipeNameTextField.translatesAutoresizingMaskIntoConstraints = false
        recipeTypeTextField.translatesAutoresizingMaskIntoConstraints = false
        recipeImageUpload.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recipeImageUpload.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            recipeImageUpload.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            recipeNameTextField.topAnchor.constraint(equalTo: recipeImageUpload.bottomAnchor, constant: 20),
            recipeNameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            recipeNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            
            recipeTypeTextField.topAnchor.constraint(equalTo: recipeNameTextField.bottomAnchor, constant: 20),
            recipeTypeTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
    
    func imageNotEmpty() -> Bool {
        if image64Str != "" && !image64Str.isEmpty {
            return true
        }
        return false
    }
    
    func recipeNameNotEmpty() -> Bool {
        if recipeNameTextField.text != "" {
            return true
        }
        return false
    }
    
    func recipeTypeNotEmpty() -> Bool {
        if recipeTypeSelected != "" {
            return true
        }
        return false
    }
    
    @objc func cancelFilterRecipeType() {
        recipeTypeTextField.resignFirstResponder()
    }
    
    @objc func confirmFilterRecipeType() {
        recipeTypeSelected = recipeTypes[delegate.recipeFilterPickerRow].recipeType
        recipeTypeTextField.text = recipeTypeSelected
        recipeTypeTextField.resignFirstResponder()
    }
    
    func loadPickerView() {
        
    }
    
    @objc func pickImageFromImageGallery(sender: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            imagePicker.modalPresentationStyle = .fullScreen
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            recipeImageUpload.image = image.scaleToSize(aSize: CGSize(width: 200, height: 200))
            let imageData = image.jpegData(compressionQuality: 1)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            image64Str = strBase64
            
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            recipeImageUpload.image = image.scaleToSize(aSize: CGSize(width: 200, height: 200))
            let imageData = image.jpegData(compressionQuality: 1)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            image64Str = strBase64
            
        } else {
            print("Something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard range.location == 0 else {
            return true
        }

        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
        return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
    }
}
