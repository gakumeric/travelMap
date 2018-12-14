//
//  recognizeViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/19.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import Hero

class recognizeViewController: UIViewController {

    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    var cities = City.cities
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionTableView.layer.cornerRadius = 10.0
        
        //「戻る!」ボタン
        let backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.08, width: 200, height: 35))
        backBtn.setTitle("戻る", for: UIControl.State())
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
    override func viewWillAppear(_ animated: Bool) {
        animateTable()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let currentCell = sender as? CountryCell,
            let vc = segue.destination as? recognizeTwoViewController {
            vc.city = currentCell.city
        }
    }

    func animateTable() {
        
        self.collectionTableView.reloadData()
        
        let cells = collectionTableView.visibleCells
        let tableHeight: CGFloat = collectionTableView.bounds.size.height
        
        for i in cells {
            let cell: UICollectionViewCell = i as UICollectionViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            
            let cell: UICollectionViewCell = a as UICollectionViewCell
            
            UIView.animate(withDuration: 1.4, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: {
                
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
                
            }, completion: nil)
            
            index += 1
        }
    }
    
}



extension recognizeViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "item", for: indexPath) as? CountryCell)!
        cell.city = cities[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height / CGFloat(cities.count-47))
    }
}
