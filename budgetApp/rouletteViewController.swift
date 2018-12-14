//
//  rouletteViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/19.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import GoogleMobileAds

class rouletteViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, GADInterstitialDelegate, GADBannerViewDelegate {
        //ディスプレイサイズ取得
        let d2w = UIScreen.main.bounds.size.width
        let d2h = UIScreen.main.bounds.size.height
    
        @IBOutlet weak var rolettoPickerView: UIPickerView!
        @IBOutlet weak var startButton: UIButton!
        @IBAction func gogoButtoDidTouch(_ sender: AnyObject) {
        
        rolettoPickerView.selectRow(Int(arc4random()) % 80 + 3, inComponent: 0, animated: true)
        rolettoPickerView.selectRow(Int(arc4random()) % 80 + 3, inComponent: 1, animated: true)
        rolettoPickerView.selectRow(Int(arc4random()) % 80 + 3, inComponent: 2, animated: true)
        
        
        if(dataArray1[rolettoPickerView.selectedRow(inComponent: 0)] == dataArray2[rolettoPickerView.selectedRow(inComponent: 1)] && dataArray2[rolettoPickerView.selectedRow(inComponent: 1)] == dataArray3[rolettoPickerView.selectedRow(inComponent: 2)]) {
        
            resultLabel.text = "Bingo!"
        } else {
            resultLabel.text = "Try again!"
            resultLabel.textColor = .white
        }
        
        
        //animate
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 5, options: .curveLinear, animations: {
        
        self.startButton.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width + 20, height: self.bounds.size.height)
        
        }, completion: { (compelete: Bool) in
        
            
            UIView.animate(withDuration: 0.1, delay: 0.0, options: UIView.AnimationOptions(), animations: {
        
        self.startButton.bounds = CGRect(x: self.bounds.origin.x, y: self.bounds.origin.y, width: self.bounds.size.width, height: self.bounds.size.height)
        
        }, completion: nil)
        
        })
        
    }

        @IBOutlet weak var resultLabel: UILabel!

        var imageArray = [String]()
        var dataArray1 = [Int]()
        var dataArray2 = [Int]()
        var dataArray3 = [Int]()
        var bounds: CGRect = CGRect.zero
    
        // Interstitial AdMob ID を入れてください
        //TestID
        //let AdMobID = "ca-app-pub-3940256099942544/4411468910"
        let AdMobID = "ca-app-pub-2229988624895690/5005569819"

        // delay sec
        let delayTime = 3.0
    
        override func viewDidLoad() {
            super.viewDidLoad()
        
            let interstitial = GADInterstitial(adUnitID: AdMobID)
            interstitial.delegate = self
            let request = GADRequest()

            interstitial.load(request)
            // 3秒間待たせる
            DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                self.showAdMob(interstitial: interstitial)
            }
            
            
            let bannerView:GADBannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
            bannerView.adUnitID = "ca-app-pub-2229988624895690/9728153117"
            bannerView.delegate = self
            bannerView.rootViewController = self
            bannerView.frame.origin = CGPoint(x:0, y:self.view.frame.size.height - bannerView.frame.height)
            bannerView.frame.size = CGSize(width:self.view.frame.width, height:bannerView.frame.height)
            let gadRequest:GADRequest = GADRequest()
            gadRequest.testDevices = [bannerView.adUnitID!]  // テスト時のみ
            bannerView.load(gadRequest)
            self.view.addSubview(bannerView)
            
            
            let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            bg.image = UIImage(named: "tim-easley")
            bg.layer.zPosition = -1
            bg.alpha = 0.9
            self.view.addSubview(bg)
            
            bounds = startButton.bounds
            imageArray = ["👸","💩","😘","🍺","🍸","🕺","🍷"]
            
            for _ in 0...100 {
                self.dataArray1.append((Int)(arc4random() % 7 ))
                self.dataArray2.append((Int)(arc4random() % 7 ))
                self.dataArray3.append((Int)(arc4random() % 7 ))
            }
            
            resultLabel.text = ""
            resultLabel.font = UIFont.systemFont(ofSize: 20)
            
            rolettoPickerView.delegate = self
            rolettoPickerView.dataSource = self
            rolettoPickerView.layer.cornerRadius = 10.0
            rolettoPickerView.layer.borderWidth = 1.0
            startButton.layer.cornerRadius = 6
            
            //「戻る!」ボタン
            let backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.16, width: 200, height: 35))
            backBtn.setTitle("Back", for: UIControl.State())
            backBtn.setTitleColor(.orange, for: UIControl.State())
            backBtn.backgroundColor = .white
            backBtn.layer.cornerRadius = 10.0
            backBtn.layer.borderColor = UIColor.orange.cgColor
            backBtn.layer.borderWidth = 1.0
            backBtn.addTarget(self, action: #selector(onbackClick(_:)), for: .touchUpInside)
            view.addSubview(backBtn)
            
        }
    
        func showAdMob(interstitial: GADInterstitial){
            if (interstitial.isReady)
            {
                interstitial.present(fromRootViewController: self)
            }
        }
    
    
        @objc func onbackClick(_: UIButton) {
            dismiss(animated: true, completion: nil)
        }

        override var preferredStatusBarStyle : UIStatusBarStyle {
            return UIStatusBarStyle.lightContent
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            
            startButton.alpha = 0
            
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            UIView.animate(withDuration: 0.5, delay: 0.3, options: .curveEaseOut, animations: {
                
                self.startButton.alpha = 1
                
            }, completion: nil)
            
        }


        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return 100
        }

        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 3
        }

        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 100.0
        }

        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 100.0
        }

        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            
            let pickerLabel = UILabel()
            
            if component == 0 {
                pickerLabel.text = imageArray[(Int)(dataArray1[row])]
            } else if component == 1 {
                pickerLabel.text = imageArray[(Int)(dataArray2[row])]
            } else {
                pickerLabel.text = imageArray[(Int)(dataArray3[row])]
            }
            
            pickerLabel.font = UIFont(name: "Apple Color Emoji", size: 80)
            pickerLabel.textAlignment = NSTextAlignment.center
            
            return pickerLabel
            
        }

    
}

