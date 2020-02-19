//
//  DetailController.swift
//  RecipeApp
//
//  Created by Vickson on 17/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class DetailController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var selectedRecipe : Recipe?
    var multiTableView = UITableView()
    var recipeViewModel: RecipeViewModel?
    var recipeViewModelCellString = "recipeViewModelCellString"
    var recipeImgNameCellImgView: UIImageView?
    var recipeIngredientData: [Ingredient] = []
    let detailControllerDB = SqliteInstance()
    var delegate = MainController()
    var popUp: PopUpTextFieldView?
    var ingredientText: String?
    var editIngredientIndex: Int?
    var deleteIngredientIndex: Int?
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        
        recipeViewModel = RecipeViewModel()
        loadNavigationItem()
        loadQueries()
        
        multiTableView.dataSource = recipeViewModel
        multiTableView.delegate = recipeViewModel
        recipeViewModel?.delegate = self
        multiTableView.backgroundColor = UIColor(rgb: 0xE0E0E0)
//        multiTableView.separatorStyle = .none
        
        view.addSubview(multiTableView)
        multiTableView.translatesAutoresizingMaskIntoConstraints = false
        multiTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        multiTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        multiTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        multiTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let tapGestureRec = UITapGestureRecognizer(target: self, action: #selector(doubleTapDeleteIngredient))
        tapGestureRec.numberOfTapsRequired = 2
        multiTableView.addGestureRecognizer(tapGestureRec)
    }
    
    //tap twice to delete ingredient
    @objc func doubleTapDeleteIngredient(recognizer: UITapGestureRecognizer)  {
        if recognizer.state == UIGestureRecognizer.State.ended {
            let tapLocation = recognizer.location(in: multiTableView)
            if let tapIndexPath = multiTableView.indexPathForRow(at: tapLocation) {
                if let tappedIngredientCell = multiTableView.cellForRow(at: tapIndexPath) as? RecipeDetailIngredientViewCell {
                    deleteIngredientIndex = tapIndexPath.row
                    //a temporarily shortcut to close pop up on double tap ingredient cell
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                        self.popUp?.animateOut()
                        self.deleteIngredient()
                    }
                }
            }
        }
    }
    
    func deleteIngredient() {
        do {
            try detailControllerDB.deleteSingleItem(sqlDeleteQuery: Ingredient.self, id: recipeIngredientData[deleteIngredientIndex!].id)
            reloadData()
        } catch {
            print("Error deleting ingredient")
        }
    }
    
    func loadNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(onAddIngredient))
        navigationItem.rightBarButtonItem?.tintColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backToPreviousView))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func backToPreviousView() {
        delegate.reloadTableViewData()
        navigationController?.popViewController(animated: true)
    }
    
    @objc func onAddIngredient() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.popUp = PopUpTextFieldView()
            self.popUp?.titleLabel.text = "Add Ingredient"
            self.popUp?.confirmBtn.setTitle("Add", for: .normal)
            self.popUp?.confirmBtn.addTarget(self, action: #selector(self.confirmAddIngredient), for: .touchUpInside)
            self.popUp?.txtField.addTarget(self, action: #selector(self.ingredientTextChanged), for: .editingChanged)
            self.view.addSubview(self.popUp ?? PopUpTextFieldView())
        }
    }
    
    @objc func confirmAddIngredient() {
        self.popUp?.animateOut()
        do {
            try detailControllerDB.insertSingleItem(sqlInsertQuery: Ingredient.self, id: selectedRecipe!.id, value: ingredientText ?? "Empty String")
            reloadData()
        } catch {
            print("error adding ingredient")
        }
    }
    
    @objc func ingredientTextChanged() {
        ingredientText = self.popUp?.txtField.text
    }
    
    func onEditIngredient(indexRow: Int) {
        editIngredientIndex = indexRow
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
            self.popUp = PopUpTextFieldView()
            self.popUp?.titleLabel.text = "Edit Ingredient"
            self.popUp?.confirmBtn.setTitle("Confirm", for: .normal)
            self.popUp?.confirmBtn.addTarget(self, action: #selector(self.confirmEditIngredient), for: .touchUpInside)
            self.popUp?.txtField.addTarget(self, action: #selector(self.ingredientTextChanged), for: .editingChanged)
            self.view.addSubview(self.popUp ?? PopUpTextFieldView())
        }
    }
    
    @objc func confirmEditIngredient() {
        self.popUp?.animateOut()
        do {
            try detailControllerDB.updateSingleItem(sqlUpdateQuery: Ingredient.self, id: recipeIngredientData[editIngredientIndex!].id, value: ingredientText ?? "Empty String")
            reloadData()
        } catch {
            print("error editing ingredient")
        }
    }
    
    func loadQueries() {
        print("selectedRecipe!.id \(selectedRecipe!.id)")
        let iResults = detailControllerDB.getAllResults(sqlSelectQuery: Ingredient.self, id: selectedRecipe!.id)
        for i in iResults {
            recipeIngredientData.append(i)
        }
        let rItem = RecipeImgNameItem.init(rowCount: 1, recipeItem: selectedRecipe ?? Recipe(id: 0, recipeName: "Error", recipeType: "", img64Str: ""))
        recipeViewModel?.recipeViewModelItems.append(rItem)
        
        let iItem = RecipeIngredientItem.init(rowCount: recipeIngredientData.count, ingredientItem: recipeIngredientData)
        recipeViewModel?.recipeViewModelItems.append(iItem)
        
        let pItem = RecipeProcedureItem.init(rowCount: 1, procedureItem: [Procedure(procedure: "Tempo Procedure")])
        recipeViewModel?.recipeViewModelItems.append(pItem)
        
        let nItem = RecipeNoteItem.init(rowCount: 1, noteItem: [Note(note: "Tempo Note")])
        recipeViewModel?.recipeViewModelItems.append(nItem)
    }
    
    func reloadData() {
        recipeViewModel?.recipeViewModelItems.removeAll()
        recipeIngredientData.removeAll()
        loadQueries()
        multiTableView.reloadData()
    }
    
    
    func pickImageFromImageGallery()
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

            let imageData = image.jpegData(compressionQuality: 1)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            updateImage(base64Str: strBase64)
    
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            let imageData = image.jpegData(compressionQuality: 1)!
            let strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
            updateImage(base64Str: strBase64)
            
        } else {
            print("Something went wrong")
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func updateImage(base64Str: String) {
        do {
            try detailControllerDB.updateRecipeImage(sqlUpdateQuery: Recipe.self, id: selectedRecipe!.id, base64Str: base64Str)
            selectedRecipe?.img64Str = base64Str
            reloadData()
        } catch {
            print("update image error")
        }
    }
}
