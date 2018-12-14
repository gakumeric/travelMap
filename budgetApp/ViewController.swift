//
//  ViewController.swift
//  budgetApp
//
//  Created by 木下岳 on 2017/09/28.
//  Copyright © 2017年 gakukinoshita. All rights reserved.
//

import UIKit
import LTMorphingLabel
import BubbleTransition

class ViewController: UIViewController {
    
    @IBOutlet weak var sampleLabel0: UILabel!
    
    var words_list:[NSDictionary] = []
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var todoBtn: UIButton!
    @IBOutlet weak var setBtn: UIButton!
    @IBOutlet weak var showBtn: UIButton!
    @IBOutlet weak var killTimeBtn: UIButton!
    @IBOutlet weak var tutorialBtn: UIButton!
    
    private var timer: Timer?
    private var index: Int = 0
    
    private let textList = ["Excursionist","Hello World!",
                            "おはよう　世界!", "Boujour le monde!", "Hallo welt!", "Hola Mundo!",
                            "Olá Mundo!", "Hallo Wereld!", "Ahoj světe!",
                            "Привет мир!", "Dia duit an Domhain!", "Γειά σου Κόσμε!",
                            "Saluton Mondo!", "שלום עולם!", "مرحبا بالعالم!",
                            "Selam Dünya!", "Salamu, Dunia!", "Hello Wêreld!", "नमस्ते दुनिया!", "Chào thế giới!", "สวัสดีชาวโลก!",
                            "안녕하세요 !", "Excursionist"]
    
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bg = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        bg.image = UIImage(named: "pineapple.jpge")
        bg.layer.zPosition = -1
        bg.alpha = 0.8
        self.view.addSubview(bg)
        
        
        mapBtn.backgroundColor = UIColor.white
        mapBtn.layer.borderColor = UIColor.orange.cgColor
        mapBtn.tintColor = .orange
        mapBtn.layer.cornerRadius = 10.0
        mapBtn.layer.borderWidth = 2.0
        mapBtn.setTitleColor(UIColor.orange,for: UIControl.State.normal)
        
        todoBtn.backgroundColor = UIColor.white
        todoBtn.layer.borderColor = UIColor.orange.cgColor
        todoBtn.tintColor = .orange
        todoBtn.layer.cornerRadius = 10.0
        todoBtn.layer.borderWidth = 2.0
        todoBtn.setTitleColor(UIColor.orange,for: UIControl.State.normal)
        
        setBtn.backgroundColor = UIColor.white
        setBtn.layer.borderColor = UIColor.orange.cgColor
        setBtn.tintColor = .orange
        setBtn.layer.cornerRadius = 10.0
        setBtn.layer.borderWidth = 2.0
        setBtn.setTitleColor(UIColor.orange,for: UIControl.State.normal)
        
        showBtn.backgroundColor = UIColor.white
        showBtn.layer.borderColor = UIColor.orange.cgColor
        showBtn.tintColor = .orange
        showBtn.layer.cornerRadius = 10.0
        showBtn.layer.borderWidth = 2.0
        showBtn.setTitleColor(UIColor.orange,for: UIControl.State.normal)
        
        killTimeBtn.backgroundColor = UIColor.white
        killTimeBtn.layer.borderColor = UIColor.orange.cgColor
        killTimeBtn.tintColor = .orange
        killTimeBtn.layer.cornerRadius = 10.0
        killTimeBtn.layer.borderWidth = 2.0
        killTimeBtn.setTitleColor(UIColor.orange,for: UIControl.State.normal)
        
        tutorialBtn.backgroundColor = UIColor.red
        tutorialBtn.layer.borderColor = UIColor.white.cgColor
        tutorialBtn.tintColor = .red
        tutorialBtn.layer.cornerRadius = 10.0
        tutorialBtn.layer.borderWidth = 2.0
        tutorialBtn.setTitleColor(UIColor.white,for: UIControl.State.normal)
        
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        let message = appDelegate.message
        print(message!)
        if message == "2回目" {
            tutorialBtn.isHidden = true
            //tutorialBtn.alpha = 0.8
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination
        controller.transitioningDelegate = self
        controller.modalPresentationStyle = .custom
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
    

    @IBAction func mapAction(_ sender: Any) {
//        let jumpView: MapViewController = self.storyboard!.instantiateViewController( withIdentifier: "MapViewController" ) as! MapViewController
//        self.present( jumpView as UIViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func returnToTop(segue: UIStoryboardSegue) { }
 
    
    @objc func updateLabel(timer: Timer) {
        sampleLabel0.text = textList[index]
        
        index += 1
        if index >= textList.count {
            index = 0
        }
    }
    
}

extension ViewController {
    
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

extension ViewController : UIViewControllerTransitioningDelegate{
    
    //　手順⑤
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = mapBtn.center    //outletしたボタンの名前を使用
        transition.bubbleColor = UIColor.clear         //円マークの色
        return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = mapBtn.center //outletしたボタンの名前を使用
        transition.bubbleColor = UIColor.clear     //円マークの色
        return transition
    }
}

