//
//  showViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/13.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import RealmSwift
import DZNEmptyDataSet
import GoogleMobileAds

class showViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADInterstitialDelegate {

    //ディスプレイサイズ取得
    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var mytable: UITableView!
    
    var allItems: [Mapdata] = []
    var countryData:[String] = []
    var daysData:[Int] = []
    var selectedIndex: String!
    
    // Interstitial AdMob ID を入れてください
    //TestID
    //let AdMobID = "ca-app-pub-3940256099942544/4411468910"
    let AdMobID = "ca-app-pub-2229988624895690/5005569819"
    
    // delay sec
    let delayTime = 3.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let interstitial = GADInterstitial(adUnitID: AdMobID)
        let request = GADRequest()
        
        interstitial.load(request)
        // 3秒間待たせる
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            self.showAdMob(interstitial: interstitial)
        }
        
        self.mytable.delegate = self
        self.mytable.dataSource = self
        
        self.mytable.estimatedRowHeight = 80
        self.mytable.rowHeight = UITableView.automaticDimension
        self.mytable.layer.cornerRadius = 10.0
        
        // make UIImageView instance
        let imageView = UIImageView(frame: CGRect(x:0, y:0, width:self.mytable.frame.width, height:self.mytable.frame.height))
        // read image
        let image = UIImage(named: "pineapple")
        // set image to ImageView
        imageView.image = image
        // set alpha value of imageView
        imageView.alpha = 0.5
        // set imageView to backgroundView of TableView
        self.mytable.backgroundView = imageView
        
        //「戻る!」ボタン
        let backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.06, width: 200, height: 30))
        backBtn.setTitle("Back", for: UIControl.State())
        backBtn.setTitleColor(.orange, for: UIControl.State())
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 10.0
        backBtn.layer.borderColor = UIColor.orange.cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.addTarget(self, action: #selector(onbackClick(_:)), for: .touchUpInside)
        view.addSubview(backBtn)
        
        //「全削除」ボタン
        let allDeleteBtn = UIButton(frame: CGRect(x: 10, y: d2h / 1.06, width: 70, height: 30))
        allDeleteBtn.setTitle("Delete", for: UIControl.State())
        allDeleteBtn.setTitleColor(.white, for: UIControl.State())
        allDeleteBtn.backgroundColor = .red
        allDeleteBtn.layer.cornerRadius = 10.0
        allDeleteBtn.layer.borderColor = UIColor.white.cgColor
        allDeleteBtn.layer.borderWidth = 1.0
        allDeleteBtn.addTarget(self, action: #selector(onAllDelete(_:)), for: .touchUpInside)
        view.addSubview(allDeleteBtn)
        
        getMap()
    }

    func showAdMob(interstitial: GADInterstitial){
        if (interstitial.isReady)
        {
            interstitial.present(fromRootViewController: self)
        }
    }

    @objc func getMap() {
        //すべて取得
        let realm = try! Realm()
        let result = realm.objects(Mapdata.self).sorted(byKeyPath: "id", ascending: true)
        print(result)
        allItems = []
        result.forEach{ item in
            allItems.append(item)
            print("item.data:\(item)")
        }
        // Top画面表示時にテーブル内容をリロード
        mytable.reloadData()
    }
    
    //画面遷移(カレンダーページ)
    @objc func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    // セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // セル数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allItems.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor =  colorforIndex(indexPath.row)
        
    }
    // セル内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell") as! TitleTableViewCell
    
        // cellの背景を透過
        cell.backgroundColor = UIColor.clear
        // cell内のcontentViewの背景を透過
        cell.contentView.backgroundColor = UIColor.clear
        cell.textLabel?.font = UIFont(name: "Copperplate-Light", size: 30)
        
        cell.lblNo.text = String(indexPath.row + 1) + "ヵ国"
        cell.lblTitle.text = allItems[indexPath.row].name
        cell.lblDays.text = String(allItems[indexPath.row].days) + "days"

        return cell
    }
    
    @objc func onAllDelete(_ sender: Any) {
        
        let alert: UIAlertController = UIAlertController(title: "Alert", message: "全削除しますか？", preferredStyle:  UIAlertController.Style.alert)
        
        let defaultAction: UIAlertAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            print("Okay")
            
            //削除アクション
            let realm = try! Realm()
            let result = realm.objects(Mapdata.self)
            for Mapdata in result {
                print("event: \(Mapdata.name)")
            }
            try! realm.write() {
                realm.delete(result)
            }
            let alert: UIAlertController = UIAlertController(title: "Alert", message: "Done delete", preferredStyle:  UIAlertController.Style.alert)
            let deleteAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
            })
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
            
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
        })
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: UITableViewDelegate
    
    func colorforIndex(_ index: Int) -> UIColor {
        let itemCount = allItems.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.8
        return UIColor(red: color, green: 0.8, blue: 1.0, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }
    
    func animateTable() {
        
        self.mytable.reloadData()
        let cells = mytable.visibleCells
        let tableHeight: CGFloat = mytable.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        var index = 0
        
        for a in cells {
            
            let cell: UITableViewCell = a as UITableViewCell
            
            UIView.animate(withDuration: 2.0, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                
            }, completion: nil)
            
            index += 1
        }
    }
    
    // セルタップ時の処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(allItems[indexPath.row].name)
        selectedIndex = allItems[indexPath.row].name
        
//        let pasteboard: UIPasteboard = UIPasteboard.general
//        pasteboard.string = selectedIndex
//        print("pasteboard:\(pasteboard)")
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.name = selectedIndex
        print("selectedIndex:\(selectedIndex)")
        
        let jumpView: reviewViewController = self.storyboard!.instantiateViewController( withIdentifier: "reviewViewController" ) as! reviewViewController
            jumpView.modalTransitionStyle = .crossDissolve
            self.present( jumpView as UIViewController, animated: true, completion: nil)
    }

    
}



extension showViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    //要素がないとき画像表示
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return nil
        //return UIImage(named: "Pic1")
    }
    //タイトル表示
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "登録は0件です"
        let font = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 30)! ]
        return NSAttributedString(string: text, attributes: font)
    }
    //説明文表示
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let descripttext = "登録してください"
        let fontfont = [ NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 14)! ]
        return NSAttributedString(string: descripttext, attributes: fontfont)
    }
    
    func buttonImage(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> UIImage! {
        return nil
    }
    
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
}
