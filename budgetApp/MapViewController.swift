//
//  MapViewController.swift
//  budgetApp
//
//  Created by 木下岳 on 2017/09/28.
//  Copyright © 2017年 gakukinoshita. All rights reserved.
//

import UIKit
import MapKit
import INTULocationManager
import RealmSwift
import SwiftShareBubbles
import GoogleMobileAds


class MapViewController: UIViewController, MKMapViewDelegate, SwiftShareBubblesDelegate, GADInterstitialDelegate, GADBannerViewDelegate {
    
    //ディスプレイサイズ取得
    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var plusBtn: UIButton!
    
    var checkBtn:UIButton!
    var moneyBtn:UIButton!
    var daysBtn:UIButton!
    var snsBtn:UIButton!
    var backBtn:UIButton!
    
    var array:NSMutableArray = []
    var nameArray:NSArray = []
    var capArray:NSArray = []
    var latArray:NSArray = []
    var lonArray:NSArray = []
    
    var routeArray:NSMutableArray = []
    var realmArray:NSArray = []
    
    var coordinateArray:NSMutableArray = []
    
    var nameRoute:NSArray = []
    var jsonData:NSMutableArray = []
    var routeName = ""
    var pinpriority:NSArray = []
    
    var bubbles: SwiftShareBubbles?
    let customBubbleId = 400
    
    // Interstitial AdMob ID を入れてください
    //TestID
    //let AdMobID = "ca-app-pub-3940256099942544/4411468910"
    let AdMobID = "ca-app-pub-2229988624895690/5005569819"
    
    // delay sec
    let delayTime = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        readData()
        pinData()
        
        
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
        
        mapView.mapType = .mutedStandard
        mapView.register(LocationView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.mapView.delegate = self
        
        
        //マップ機能
        let coordinate = CLLocationCoordinate2DMake(36.204824, 138.252924)
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated:true)
        
        
        checkBtn = UIButton(frame: CGRect(x: 10, y: 30, width: 80, height: 30))
        checkBtn.setTitle("Country", for: UIControl.State())
        checkBtn.setTitleColor(.orange, for: UIControl.State())
        checkBtn.backgroundColor = .white
        checkBtn.layer.cornerRadius = 10.0
        checkBtn.layer.borderColor = UIColor.orange.cgColor
        checkBtn.layer.borderWidth = 2.0
        checkBtn.addTarget(self, action: #selector(nextAction(_:)), for: .touchUpInside)
        view.addSubview(checkBtn)
        
        moneyBtn = UIButton(frame: CGRect(x: 10, y: 70, width: 80, height: 30))
        moneyBtn.setTitle("Budgets", for: UIControl.State())
        moneyBtn.setTitleColor(.orange, for: UIControl.State())
        moneyBtn.backgroundColor = .white
        moneyBtn.layer.cornerRadius = 10.0
        moneyBtn.layer.borderColor = UIColor.orange.cgColor
        moneyBtn.layer.borderWidth = 2.0
        moneyBtn.addTarget(self, action: #selector(nextbubbleAction(_:)), for: .touchUpInside)
        view.addSubview(moneyBtn)
        
        daysBtn = UIButton(frame: CGRect(x: 10, y: 110, width: 80, height: 30))
        daysBtn.setTitle("Days", for: UIControl.State())
        daysBtn.setTitleColor(.orange, for: UIControl.State())
        daysBtn.backgroundColor = .white
        daysBtn.layer.cornerRadius = 10.0
        daysBtn.layer.borderColor = UIColor.orange.cgColor
        daysBtn.layer.borderWidth = 2.0
        daysBtn.addTarget(self, action: #selector(nextdaysAction(_:)), for: .touchUpInside)
        view.addSubview(daysBtn)
        
        snsBtn = UIButton(frame: CGRect(x: 10, y: 150, width: 80, height: 30))
        snsBtn.setTitle("SNS", for: UIControl.State())
        snsBtn.setTitleColor(.orange, for: UIControl.State())
        snsBtn.backgroundColor = .white
        snsBtn.layer.cornerRadius = 10.0
        snsBtn.layer.borderColor = UIColor.orange.cgColor
        snsBtn.layer.borderWidth = 2.0
        snsBtn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        view.addSubview(snsBtn)
        
        bubbles = SwiftShareBubbles(point: CGPoint(x: view.frame.width / 2, y: view.frame.height / 2), radius: 120, in: view)
        bubbles?.showBubbleTypes = [Bubble.facebook, Bubble.twitter, Bubble.line, Bubble.google,Bubble.youtube,Bubble.instagram,Bubble.pintereset,Bubble.whatsapp,Bubble.linkedin,Bubble.weibo,Bubble.safari]
        bubbles?.delegate = self
        
        backBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.16, width: 200, height: 35))
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
    
    
    
    func readData() {

        let path = Bundle.main.path(forResource: "counteryAll", ofType: "json")
        let jsondata = try? Data(contentsOf: URL(fileURLWithPath: path!))
        let jsonArray = (try! JSONSerialization.jsonObject(with: jsondata!, options: [])) as! NSArray
        for data in jsonArray {
            let _:NSDictionary = data as! NSDictionary
            let myData = Mapdata(value: data)
            jsonData.add(myData)
            array.add(data)
        }
        let realm = try! Realm()
        let resultData = realm.objects(Mapdata.self)
        for data in resultData {
            routeArray.add(data)
        }
        realmArray = Array(realm.objects(Mapdata.self)) as NSArray
    }
    
    
    
    func pinData() {
        
        DispatchQueue.global(qos: .background).async {
            
            // Background Thread
            DispatchQueue.main.async {
                
                self.nameArray = self.array.value(forKey: "name") as! NSArray
                self.capArray = self.array.value(forKey: "cap") as! NSArray
                self.latArray = self.array.value(forKey: "lat") as! NSArray
                self.lonArray = self.array.value(forKey: "lon") as! NSArray
                self.nameRoute = self.routeArray.value(forKey: "name") as! NSArray
                self.pinpriority = self.routeArray.value(forKey: "priority") as! NSArray
                
                var coords : [CLLocationCoordinate2D] = []
                var coords2 : [CLLocationCoordinate2D] = []
                var latitute =  [String]()
                var longtitude =  [String]()
                var nameCountry = [String]()
                var nameCapital = [String]()
                var priorityData = [String]()
                
                for data in 0..<self.realmArray.count {
                    let ev = self.nameRoute[data] as! String
                    //print(ev)
                    for route in 0..<self.nameArray.count {
                        let vo = self.nameArray[route] as! String
                        if vo == ev {
                            let iv = self.array[route]
                            //print(iv)
                            let val1 = (iv as AnyObject).value(forKey: "lat")
                            let val2 = (iv as AnyObject).value(forKey: "lon")
                            let val3 = (iv as AnyObject).value(forKey: "name")
                            let val4 = (iv as AnyObject).value(forKey: "cap")
                            latitute.append(String(format:"%@",val1 as! CVarArg))
                            longtitude.append(String(format:"%@",val2 as! CVarArg))
                            nameCountry.append(String(format:"%@",val3 as! CVarArg))
                            nameCapital.append(String(format:"%@",val4 as! CVarArg))
                        }
                    }
                }
                
                for data in 0..<self.pinpriority.count {
                    let ev = self.nameRoute[data] as! String
                    for route in 0..<self.nameArray.count {
                        let vo = self.nameArray[route] as! String
                        if vo == ev {
                            let iv = self.realmArray[data]
                            let val1 = (iv as AnyObject).value(forKey: "priority")
                            priorityData.append(String(format:"%@",val1 as! CVarArg))
                        }
                    }
                }
                
                for i in 0..<latitute.count {
                    let coordinate2 = CLLocationCoordinate2D(latitude: Double(latitute[i])! , longitude: Double(longtitude[i])!)
                    coords.append(coordinate2)
                    //let myPin1: MKPointAnnotation = MKPointAnnotation()
                    let myPin1 = Location()
                    myPin1.coordinate = coordinate2
                    myPin1.title = nameCountry[i]
                    myPin1.subtitle = nameCapital[i]
                    //myPin1.type = .two
                    
                    if Int(priorityData[i])! == 1 {
                        myPin1.type = .one
                    } else if Int(priorityData[i])! == 2 {
                        myPin1.type = .two
                    } else if Int(priorityData[i])! == 3 {
                        myPin1.type = .three
                    } else if Int(priorityData[i])! == 4 {
                        myPin1.type = .four
                    } else if Int(priorityData[i])! == 5 {
                        myPin1.type = .five
                    }
                    
                    self.mapView.addAnnotation(myPin1)
                }
                
                for k in stride(from: 0, to: coords.count, by: 1) {
                    if(k != coords.count-1 ){
                        let coordinates = [coords[k], coords[k+1]]
                        coords2.append(contentsOf: coordinates)
                    }
                }
                //print("coords2:\(coords2)")
                let myPolyLine_1: MKPolyline = MKPolyline(coordinates:coords2, count: coords2.count)
                self.mapView.addOverlay(myPolyLine_1)
            }
        }
        
    }
    
    func showAdMob(interstitial: GADInterstitial){
        if interstitial.isReady{
            print("広告準備あり")
            interstitial.present(fromRootViewController: self)
        } else {
            print("広告の準備がない")
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        for view in views {
            view.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.system)
        }
    }
    
    @IBAction func returnToMe(segue: UIStoryboardSegue) { }
    
    //addOverlayした際に呼ばれるデリゲートメソッド.
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        // rendererを生成.
        let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
        // 線の太さを指定.
        myPolyLineRendere.lineWidth = 3
        // 線の色を指定.
        myPolyLineRendere.strokeColor = UIColor.red
        
        return myPolyLineRendere
    }
    
    @objc func nextAction(_ sender: Any) {
                let jumpView: recognizeViewController = self.storyboard!.instantiateViewController( withIdentifier: "recognizeViewController" ) as! recognizeViewController
                jumpView.modalTransitionStyle = .crossDissolve
                self.present( jumpView as UIViewController, animated: true, completion: nil)
    }
    
    @objc func nextbubbleAction(_ sender: Any) {
        let jumpView: bubbleViewController = self.storyboard!.instantiateViewController( withIdentifier: "bubbleViewController" ) as! bubbleViewController
        jumpView.modalTransitionStyle = .crossDissolve
        self.present( jumpView as UIViewController, animated: true, completion: nil)
    }
    
    @objc func nextdaysAction(_ sender: Any) {
        let jumpView: daysViewController = self.storyboard!.instantiateViewController( withIdentifier: "daysViewController" ) as! daysViewController
        jumpView.modalTransitionStyle = .crossDissolve
        self.present( jumpView as UIViewController, animated: true, completion: nil)
    }
    
    @IBAction func ishideAction(_ sender: UISwitch) {
        if sender.isOn {
            checkBtn.isHidden = false
            moneyBtn.isHidden = false
            daysBtn.isHidden = false
            snsBtn.isHidden = false
            backBtn.isHidden = false
            plusBtn.isHidden = false
        } else {
            checkBtn.isHidden = true
            moneyBtn.isHidden = true
            daysBtn.isHidden = true
            snsBtn.isHidden = true
            backBtn.isHidden = true
            plusBtn.isHidden = true
        }
    }
    
    
    func bubblesTapped(bubbles: SwiftShareBubbles, bubbleId: Int) {
        if let bubble = Bubble(rawValue: bubbleId) {
            print("\(bubble)")
            switch bubble {
            case .facebook:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "facebook://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "facebook://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .twitter:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "twitter://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "twitter://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .line:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "line://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "line://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .youtube:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "https://www.youtube.com/?hl=JA!")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "https://www.youtube.com/?hl=JA!")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .instagram:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "instagram://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "instagram://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .google:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "https://www.google.co.jp/!")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "https://www.google.co.jp/!")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .pintereset:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "pinterest://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "pinterest://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .whatsapp:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "whatsapp://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "whatsapp://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .weibo:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "weibo://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "weibo://")
                    UIApplication.shared.openURL(url!)
                }
                break
            case .safari:
                if #available(iOS 10.0, *) {
                    let url = URL(string: "safari://")
                    UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                } else {
                    let url = URL(string: "safari://")
                    UIApplication.shared.openURL(url!)
                }
                break
            default:
                break
            }
            
        } else {
            if customBubbleId == bubbleId {
                print("custom tapped")
            }
        }
    }
    
    func bubblesDidHide(bubbles: SwiftShareBubbles) {
    }
    
    @objc func buttonTapped(_ sender: AnyObject) {
        bubbles?.show()
    }
 
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        let jumpView: RootViewController = self.storyboard!.instantiateViewController( withIdentifier: "RootViewController" ) as! RootViewController
        jumpView.modalTransitionStyle = .flipHorizontal
        self.present( jumpView as UIViewController, animated: true, completion: nil)
    }
    
    //広告の読み込みが完了した時
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {}
    //広告の読み込みが失敗した時
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {}
    //広告画面が開いた時
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {}
    //広告をクリックして開いた画面を閉じる直前
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {}
    //広告をクリックして開いた画面を閉じる直後
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {}
    //広告をクリックした時
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {}
    
}


fileprivate class Location: MKPointAnnotation {
    enum LocationType: Int {
        case one
        case two
        case three
        case four
        case five
//        case famousPlace
//        case shop
//        case other
    }
    
    var type: LocationType = .five
}

fileprivate class LocationView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            if let location = newValue as? Location {
                switch location.type {
                case .one:
                    markerTintColor = #colorLiteral(red: 0.1764705926, green: 0.01176470611, blue: 0.5607843399, alpha: 1)
                    glyphText = "☆１"
                case .two:
                    // Icon by https://iconmonstr.com/
                    markerTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    glyphText = "☆２"
                case .three:
                    markerTintColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                    glyphText = "☆３"
                case .four:
                    markerTintColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
                    glyphText = "☆４"
                case .five:
                    glyphText = "☆５"
                    break
                }
            }
        }
    }
}
