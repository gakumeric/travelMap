//
//  lottieViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/19.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import Lottie
import BubbleTransition

class lottieViewController: UIViewController {

    var animationView = LOTAnimationView(name: "animation")
    let transition = BubbleTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showAnimation()
        
    }

    func showAnimation() {
        
        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = self.view.center
        animationView.loopAnimation = true
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 2.5
        
        view.addSubview(animationView)
        
        animationView.play()
        
        viewAppear()
    }
    
    
    
    func viewAppear() {
        //少し縮小するアニメーション
        UIView.animate(withDuration: 0.3,
                                   delay: 2.0,
                                   options: UIView.AnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.animationView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: { (Bool) in
            
        })
        
        //拡大させて、消えるアニメーション
        UIView.animate(withDuration: 0.8,
                                   delay: 1.3,
                                   options: UIView.AnimationOptions.curveEaseOut,
                                   animations: { () in
                                    self.animationView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                                    self.animationView.alpha = 0
        }, completion: { (Bool) in
            self.showViewController2()
            self.animationView.removeFromSuperview()
        })
    }
    
    
    func showViewController2() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ViewController") as? ViewController
        vc?.modalTransitionStyle = .crossDissolve
        //partialCurl
        //flipHorizontal
        //coverVertical
        present(vc!, animated: true, completion: nil)
    }
    

}
