//
//  MainController.swift
//  RecipeApp
//
//  Created by Vickson on 16/02/2020.
//  Copyright © 2020 Vickson. All rights reserved.
//

import UIKit

class MainController: UIViewController, XMLParserDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource {
    
    var recipes: [Recipe] = []
    var recipeTypes: [RecipeType] = []
    var recipeType = String()
    var recipeFilterPickerRow = Int()
    var recipeFilterPicker = PickerView()
    var recipeFilterTextField: UITextField = UITextField()
    var recipeTableView: UITableView = UITableView()
    var navBar: UINavigationBar = UINavigationBar()
    let mainControllerDB = SqliteInstance()
    var recipeCardViewCellString = "recipeCardViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        recipeFilterPickerRow = 0
        loadNavigationBar()
        loadRecipeTypeFilter()
        loadParser()
        sqlQueries()
        loadTableView()
        reloadTableViewData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadTableView()
//        recipeTableView.reloadData()
        
        print(recipes.count)
    }
    
    func loadTableView() {
        recipeTableView.backgroundColor = UIColor(rgb: 0xE0E0E0)
        recipeTableView.delegate = self as UITableViewDelegate
        recipeTableView.dataSource = self as UITableViewDataSource
        
        view.addSubview(recipeTableView)
        recipeTableView.translatesAutoresizingMaskIntoConstraints = false
        recipeTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        recipeTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        recipeTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        recipeTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        recipeTableView.separatorStyle = .none
        recipeTableView.register(RecipeCardViewCell.self, forCellReuseIdentifier: recipeCardViewCellString)
    }
    
    func loadNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(rgb: mainColor())
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Recipe"
        let filterRecipeBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterRecipeType))
        filterRecipeBarButtonItem.tintColor = .white
        let addRecipeBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addRecipe))
        addRecipeBarButtonItem.tintColor = .white
        navigationItem.leftBarButtonItem = filterRecipeBarButtonItem
        navigationItem.rightBarButtonItem = addRecipeBarButtonItem
    }
    
    //get recipeTypes from xml
    func loadParser() {
        if let path = Bundle.main.url(forResource: "RecipeType", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    
    //instantiate recipetype Pickerview and Toolbar to hidden Textfield
    func loadRecipeTypeFilter() {
        recipeFilterTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.addSubview(recipeFilterTextField)
        recipeFilterTextField.isHidden = true
        
        recipeFilterPicker = PickerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
        recipeFilterPicker.pickerView.delegate = self as UIPickerViewDelegate
        recipeFilterPicker.pickerView.dataSource = self as UIPickerViewDataSource
    
        recipeFilterPicker.doneBtn.target = self
        recipeFilterPicker.doneBtn.action = #selector(confirmRecipeTypeFilter(sender:))
        recipeFilterPicker.cancelBtn.target = self
        recipeFilterPicker.cancelBtn.action = #selector(cancelRecipeTypeFilter(sender:))

        recipeFilterTextField.inputView = recipeFilterPicker
    }
    
    //a temporarily hack to workaround bug that shows only one result on getAllRecipe upon start up
    func sqlQueries() {
//                do {
                    // the id value is ignored in sql
//                    try mainControllerDB.insertRecipe(recipe: Recipe(id: 0, recipeName: "Test Recipes Test Recipes Test Recipes Test Recipes Test Recipes Test Recipes Test Recipes", recipeType: "Dessert", imgUrl: URL(string: "www.whatever.com") ?? URL(string: "www.wh.com")!))
//                    try mainControllerDB.insertSingleItem(sqlInsertQuery: Ingredient.self, id: 1, value: "tomato sause")
//                    try mainControllerDB.insertSingleItem(sqlInsertQuery: Procedure.self, id: 1, value: "Kill the kint")
//                    try mainControllerDB.insertSingleItem(sqlInsertQuery: Note.self, id: 1, value: "Beware of fire")
//                    let iResults = mainControllerDB.getAllResults(querySql: Ingredient.self, id: 1)
//                    for r in iResults {
//        //                print(r)
//                    }
                    
//                    for r in rResults {
//                        recipes.append(Recipe(id: r.id, recipeName: r.recipeName, recipeType: r.recipeType, img64Str: r.img64Str))
//                    }
        let defaultRType = recipeTypes[0].recipeType
        let rResults = mainControllerDB.getAllRecipe(querySql: Recipe.self, recipeType: defaultRType)
        recipes = rResults
//                } catch {
//                    print("error inserting")
//                }
    }
        
    @objc func addRecipe(sender: UIBarButtonItem) {
        print("addRecipe")
        
        let addReceiptViewController = AddRecipeController()
        addReceiptViewController.delegate = self
//        addReceiptViewController.modalPresentationStyle = .formSheet
//        present(addReceiptViewController, animated: true, completion: nil)
        navigationController?.pushViewController(addReceiptViewController, animated: true)
    }
    
    @objc func filterRecipeType(sender: UIBarButtonItem) {
        print("filterRecipeType")
        print(recipes.count)
        recipeFilterTextField.becomeFirstResponder()
    }
    
    @objc func confirmRecipeTypeFilter(sender: UIBarButtonItem) {
        recipeFilterTextField.resignFirstResponder()
        reloadTableViewData()
    }
    
    @objc func cancelRecipeTypeFilter(sender: UIBarButtonItem) {
        recipeFilterTextField.resignFirstResponder()
    }
    
    func reloadTableViewData() {
        recipes.removeAll()
        let f = recipeTypes[recipeFilterPickerRow].recipeType
        
        let rResults = mainControllerDB.getAllRecipe(querySql: Recipe.self, recipeType: f)
        recipes = rResults
        recipeTableView.reloadData()
    }
    
    func decodeImage64Str(img64Str: String) -> UIImage {
        let dataDecoded : Data = Data(base64Encoded: img64Str, options: .ignoreUnknownCharacters)!
        guard let decodedimage = UIImage(data: dataDecoded) else { return UIImage(named: "add")! }
        return decodedimage
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "type" {
            recipeType = String()
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "type" {
            recipeTypes.append(RecipeType(recipeType: recipeType))
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if !data.isEmpty {
            recipeType += data
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for r in self.recipeTypes {
//            print("\(r.recipeType)\n")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = DetailController()
        detailController.selectedRecipe = recipes[indexPath.row].id
        print(recipes[indexPath.row].id)
        detailController.modalPresentationStyle = .fullScreen
        self.present(detailController, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let recipeCardViewCell = tableView.dequeueReusableCell(withIdentifier: recipeCardViewCellString, for: indexPath) as! RecipeCardViewCell
        let recipe = recipes[indexPath.row]

        recipeCardViewCell.backgroundColor = UIColor(rgb: 0xE0E0E0)
        recipeCardViewCell.selectionStyle = .none
        recipeCardViewCell.recipeName.text = recipe.recipeName
        recipeCardViewCell.recipeImageView.image =  decodeImage64Str(img64Str: recipe.img64Str)
        return recipeCardViewCell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return recipeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let recipeType = recipeTypes[row].recipeType
        return recipeType
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        recipeFilterPickerRow = row
    }
}

