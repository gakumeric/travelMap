//
//  reviewViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/24.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import LTMorphingLabel
import Cosmos
import TextFieldEffects
import RealmSwift

fileprivate struct TransformProperty {
    private let kMaxBackgroundAlpha: CGFloat = 0.77
    private let kMinBackgroundAlpha: CGFloat = 0.4
    
    var point: CGPoint
    var scale: CGFloat
    var backgroundAlpha: CGFloat {
        didSet {
            // Round the value
            backgroundAlpha = min(kMaxBackgroundAlpha, max(kMinBackgroundAlpha, backgroundAlpha))
        }
    }
    
    init() {
        point = CGPoint(x: 0, y: 0)
        scale = 1.0
        backgroundAlpha = kMinBackgroundAlpha
    }
}

class reviewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var filterView: UIView!
    lazy fileprivate var transformProperty = TransformProperty()

    @IBOutlet weak var YoshikoTextField1: YoshikoTextField!
    @IBOutlet weak var likeView: CosmosView!
    @IBOutlet weak var moveLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    private var timer: Timer?
    private var index: Int = 0
    private let textList = ["Your review", "How are you?", "How was it?", "How did you feel?","Did you enjoy?", "Did you find something?", "Where did you go?", "where is best place?"]
    var scSelectedIndex = ""
    var imageView:UIImageView!
    let imagePicker = UIImagePickerController()
    var imagedate: NSData!
    var dataLating = 0.0
    
    //ディスプレイサイズ取得
    let d2w = UIScreen.main.bounds.size.width
    let d2h = UIScreen.main.bounds.size.height

    let rect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        scSelectedIndex = appDelegate.name!
        nameLabel.text = scSelectedIndex
        
        
        likeView.didTouchCosmos = { rating in
            print(rating)
        }
        likeView.didFinishTouchingCosmos = { rating in
            self.dataLating = rating
            print(rating)
        }
        
        YoshikoTextField1.textAlignment = .center
        YoshikoTextField1.delegate = self
        YoshikoTextField1.placeholderColor = .black
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(onPinchGesture))
        //UIImageViewの設定
        imageView = UIImageView()
        imageView.image = UIImage(named: "noImage.png")
        //imageView.frame = CGRect(x:30,y:70,width:50,height:60)
        imageView.frame = CGRect(x:d2w / 3.8 ,y: d2h / 1.89,width:180,height:180)
            if UIDevice.current.userInterfaceIdiom == .pad {
                imageView.frame = CGRect(x:d2w / 3.8 ,y: d2h / 2.7,width:400,height:400)
            }
        imagePicker.delegate = self
        imageView.translatesAutoresizingMaskIntoConstraints = true
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.isMultipleTouchEnabled = true
        imageView.addGestureRecognizer(pinchGestureRecognizer)
        imageView.addGestureRecognizer(panGestureRecognizer)
        self.view.addSubview(imageView)
        
        //「選択!」ボタン
        let getBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.22, width: 200, height: 30))
        getBtn.setTitle("Get picture", for: UIControl.State())
        getBtn.setTitleColor(.orange, for: UIControl.State())
        getBtn.backgroundColor = .white
        getBtn.layer.cornerRadius = 10.0
        getBtn.layer.borderColor = UIColor.orange.cgColor
        getBtn.layer.borderWidth = 1.0
        getBtn.addTarget(self, action: #selector(getPicture(_:)), for: .touchUpInside)
        view.addSubview(getBtn)
        
        //「save!」ボタン
        let saveBtn = UIButton(frame: CGRect(x: d2w / 2 - 100, y: d2h / 1.13, width: 200, height: 30))
        saveBtn.setTitle("save", for: UIControl.State())
        saveBtn.setTitleColor(.white, for: UIControl.State())
        saveBtn.backgroundColor = .orange
        saveBtn.layer.cornerRadius = 10.0
        saveBtn.layer.borderColor = UIColor.orange.cgColor
        saveBtn.layer.borderWidth = 1.0
        saveBtn.addTarget(self, action: #selector(saveEvent(_:)), for: .touchUpInside)
        view.addSubview(saveBtn)
        
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
        
        getdata()
    }

    @objc func onbackClick(_: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    //DB書き込み処理
    @objc func saveEvent(_ : UIButton){
        
        print("データ書き込み開始")
        
        if imagedate == nil {
            let noImagedata = UIImage(named: "noImage.png")
            let emptydata = noImagedata!.pngData() as NSData?
            imagedate = emptydata
        }
        
        let realm = try! Realm()
        
        try! realm.write {
            
            if (imagedate != nil || dataLating != 0.0 || YoshikoTextField1.text != "") {
                
                print("データ書き込み中")
                //日付表示の内容とスケジュール入力の内容が書き込まれる。
            let Reviews = [ReviewData(value: ["id": Int(NSDate().timeIntervalSince1970), "name": nameLabel.text!,"favorite": YoshikoTextField1.text!, "star": dataLating, "photo": imagedate])]
                realm.add(Reviews, update: true)
                print(Reviews)
                print("データ書き込み完了")
                
            } else {
                let alert: UIAlertController = UIAlertController(title: "Alert", message: "miss", preferredStyle:  UIAlertController.Style.alert)
                
                let defaultAction: UIAlertAction = UIAlertAction(title: "選択と記入が必要", style: UIAlertAction.Style.default, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                alert.addAction(defaultAction)
                present(alert, animated: true, completion: nil)
                print("書き込み失敗")
            }
            
        }
        //前のページに戻る
        dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateLabel(timer:)), userInfo: nil,
                                     repeats: true)
        timer?.fire()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer?.invalidate()
    }
    @objc func updateLabel(timer: Timer) {
        moveLabel.text = textList[index]
        
        index += 1
        if index >= textList.count {
            index = 0
        }
    }
    
    //写真取得
    @objc func getPicture(_ : UIButton) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
            if let img = imageView.image {
                let imgdata = img.pngData() as NSData?
                imagedate = imgdata
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func getdata() {
        
        let realm = try! Realm()
        let result = realm.objects(ReviewData.self)
        print(result)
        for ev in result {
            if ev.name == nameLabel.text {
                nameLabel.text = ev.name
                YoshikoTextField1.text = ev.favorite
                likeView.rating = ev.star
                
                //NSData -> UIimage
                imageView.image = UIImage(data: ev.photo! as Data)
                view.addSubview(imageView)
            }
        }
    }
    
    @objc func onPinchGesture(_ sender: UIPinchGestureRecognizer) {
        switch sender.state {
        case .changed:
            let scale = sender.scale
            if scale <= 1 {
                break
            }
            transformProperty.scale = (sender.scale - 1.0) * 0.5 + 1.0
            transform()
            // Darken the background color when scaled
            transformProperty.backgroundAlpha = (sender.scale - 1.0) * 0.8
            changeBaseViewBackgroundColor()
        case .ended, .cancelled:
            revertTransform()
        default:
            break
        }
    }
    @objc func onPanGesture(_ sender: UIPanGestureRecognizer) {
        guard let view = sender.view else {
            return
        }
        switch sender.state {
        case .changed:
            transformProperty.point = sender.translation(in: view)
            transform()
            changeBaseViewBackgroundColor()
        case .ended, .cancelled:
            revertTransform()
        default:
            break
        }
    }
}


extension reviewViewController {
    func transform() {
        imageView.transform = CGAffineTransform(translationX: transformProperty.point.x, y: transformProperty.point.y)
            .scaledBy(x: transformProperty.scale, y: transformProperty.scale)
    }
    
    func revertTransform() {
        transformProperty = TransformProperty()
        UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { () -> Void in
            self.imageView.transform = CGAffineTransform.identity
            self.transform()
            self.filterView.backgroundColor = UIColor.clear
        }, completion: nil)
    }
    
    func changeBaseViewBackgroundColor() {
        filterView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: transformProperty.backgroundAlpha)
    }
}

extension reviewViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension reviewViewController {
    
    func morphingDidStart(_ label: LTMorphingLabel) {
        print("morphingDidStart")
    }
    
    func morphingDidComplete(_ label: LTMorphingLabel) {
        print("morphingDidComplete")
    }
    
    func morphingOnProgress(_ label: LTMorphingLabel, progress: Float) {
        print("morphingOnProgress", progress)
    }
}
