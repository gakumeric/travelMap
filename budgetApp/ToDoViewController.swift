//
//  ToDoViewController.swift
//  budgetApp
//
//  Created by 木下岳 on 2017/09/29.
//  Copyright © 2017年 gakukinoshita. All rights reserved.
//

import UIKit
import LocalAuthentication
import SwiftReorder

class ToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //ディスプレイサイズ取得
    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    
    var todoList = [MyToDo]()
    
    @IBOutlet weak var myTableview: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticate()
        
        self.myTableview.estimatedRowHeight = 80
        self.myTableview.rowHeight = UITableView.automaticDimension
        self.myTableview.alpha = 0
        self.myTableview.reorder.delegate = self
        
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:self.myTableview.frame.width, height:self.myTableview.frame.height))
        let image = UIImage(named: "pineapple")
        imageView.image = image
        imageView.alpha = 0.5
        self.myTableview.backgroundView = imageView
        
        let userDefaults = UserDefaults.standard
        if let storedToDoList = userDefaults.object(forKey: "todoList") as? Data {
            
            if let unarchiveTodoList = NSKeyedUnarchiver.unarchiveObject(with: storedToDoList) as? [MyToDo] {
                todoList.append(contentsOf: unarchiveTodoList)
            }
        }
        
        let backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.08, width: 200, height: 30))
        backBtn.setTitle("Back", for: UIControl.State())
        backBtn.setTitleColor(.orange, for: UIControl.State())
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 10.0
        backBtn.layer.borderColor = UIColor.orange.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.addTarget(self, action: #selector(onbackClick(_:)), for: .touchUpInside)
        view.addSubview(backBtn)
    }
    
    @objc func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapAdd(_ sender: AnyObject) {
        
        let alertController = UIAlertController(title: "What do you want?", message: "入力してください", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField(configurationHandler: nil)
//        alertController.addTextField(configurationHandler: ({(text:UITextField!) -> Void in
//
//            text.placeholder = "first textField"
//            let label:UILabel = UILabel(frame: CGRect(x:0, y:0, width:30, height:20))
//            label.text = "ID"
//            text.leftView = label
//            text.leftViewMode = UITextFieldViewMode.always
//        }))
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (action:UIAlertAction) in
            
            if let textField = alertController.textFields?.first {
                
                let myTodo = MyToDo()
                myTodo.todoTitle = textField.text!
                self.todoList.insert(myTodo, at: 0)
                
                self.myTableview.insertRows(at: [IndexPath(row: 0, section: 0)], with: UITableView.RowAnimation.right)
                
                let userDefaults = UserDefaults.standard
                let data = NSKeyedArchiver.archivedData(withRootObject: self.todoList)
                userDefaults.set(data, forKey: "todoList")
                userDefaults.synchronize()
            }
        }
        
        alertController.addAction(okAction)
        let cancelBtn = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelBtn)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myTableview.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath)
        cell.textLabel!.font = UIFont.systemFont(ofSize: 30)
        
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        let myTodo = todoList[indexPath.row]
        //let todoTitle = todoList[indexPath.row]
        
        cell.textLabel?.text = myTodo.todoTitle
        if myTodo.todoDone {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            cell.textLabel?.textColor = UIColor.red
            //cell.backgroundColor = UIColor.gray
        }else{
            cell.accessoryType = UITableViewCell.AccessoryType.none
            cell.textLabel?.textColor = UIColor.black
            //cell.backgroundColor = UIColor.clear
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myTodo = todoList[indexPath.row]
        if myTodo.todoDone {
            myTodo.todoDone = false
        } else {
            myTodo.todoDone = true
        }
        
        myTableview.reloadRows(at: [indexPath], with: UITableView.RowAnimation.fade)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
        
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            todoList.remove(at: indexPath.row)
            myTableview.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            
            let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
            let userDefaults = UserDefaults.standard
            userDefaults.set(data, forKey: "todoList")
            userDefaults.synchronize()
        }
    }

    
    func authenticate() {
        let myContext = LAContext()
        self.configure(context: myContext)
        let reason = "Only device owner can use this feature."
        
        var authError: NSError? = nil
        
        // Touch ID が有効または Passcode がセットされている状態であることを確認
        if myContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            // 認証を実行
            myContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluateError) in
                if success {
                    print("Success")
                    
                    DispatchQueue.main.async {
                        //self.authResultLabel.text = "Success"
                        self.myTableview.alpha = 1
                    }
                } else {
                    let error = evaluateError! as NSError
                    let errorMessage = "\(error.code): \(error.localizedDescription)"
                    
                    print(errorMessage)
                    
                    DispatchQueue.main.async {
                        //self.authResultLabel.text = errorMessage
                        self.myTableview.isHidden = true

                        let imageView = UIImageView(frame: CGRect(x:self.d2w / 4, y:self.d2h / 2.5, width:200, height:200))
                        let image = UIImage(named: "LockIcon")
                        imageView.image = image
                        self.view.addSubview(imageView)
                    }
                }
            }
        } else {
            // Touch ID と Passcode のいずれも有効ではない場合
            
            let errorMessage = "\(authError!.code): \(authError!.localizedDescription)"
            print(errorMessage)
            
            DispatchQueue.main.async {
                //self.authResultLabel.text = errorMessage
            }
        }
    }

    /// ボタンの文字列をカスタマイズ
    private func configure(context: LAContext) {
        context.localizedCancelTitle = "キャンセル"
        //context.localizedFallbackTitle = "パスコードを入力"
    }
    
    
}


class MyToDo: NSObject, NSCoding {
    
    var todoTitle: String?
    
    var todoDone: Bool = false
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        todoTitle = aDecoder.decodeObject(forKey: "todoTitle") as? String
        todoDone = aDecoder.decodeBool(forKey: "todoDone")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(todoTitle, forKey: "todoTitle")
        aCoder.encode(todoDone, forKey: "todoDone")
    }
    
}



extension ToDoViewController: TableViewReorderDelegate {
    func tableView(_ tableView: UITableView, reorderRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Update data model
        let item = todoList[sourceIndexPath.row]
        todoList.remove(at: sourceIndexPath.row)
        todoList.insert(item, at: destinationIndexPath.row)
        
        let data: Data = NSKeyedArchiver.archivedData(withRootObject: todoList)
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "todoList")
        userDefaults.synchronize()
    }
}

