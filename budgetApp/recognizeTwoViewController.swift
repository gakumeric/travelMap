//
//  recognizeTwoViewController.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/19.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import Hero


func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

class recognizeTwoViewController: UIViewController {

    var city:City?
    
    @IBOutlet weak var PicimageView: UIImageView!
    @IBOutlet weak var naLabel: UILabel!
    @IBOutlet weak var sendescriptionLabel: UILabel!
    @IBOutlet weak var rikuLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var exmoneyLabel: UILabel!
    @IBOutlet weak var colorLabel: UITextView!
    
    var panGR: UIPanGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let city = city {
            let name = city.name
            naLabel.text = name
            naLabel.hero.id = "\(name)_name"
            naLabel.hero.modifiers = [.zPosition(4)]
            
            PicimageView.image = city.image
            PicimageView.hero.id = "\(name)_image"
            PicimageView.hero.modifiers = [.zPosition(2)]
            
            sendescriptionLabel.hero.id = "\(name)_description1"
            sendescriptionLabel.hero.modifiers = [.zPosition(4)]
            sendescriptionLabel.text = city.description1
            
            rikuLabel.hero.id = "\(name)_shortDescription"
            rikuLabel.hero.modifiers = [.zPosition(4)]
            rikuLabel.text = city.shortDescription
            
            languageLabel.hero.id = "\(name)_language"
            languageLabel.hero.modifiers = [.zPosition(4)]
            languageLabel.text = city.language
            
            exmoneyLabel.hero.id = "\(name)_money"
            exmoneyLabel.hero.modifiers = [.zPosition(4)]
            exmoneyLabel.text = city.money
            
            colorLabel.hero.id = "\(name)_color"
            colorLabel.hero.modifiers = [.zPosition(4)]
            colorLabel.text = city.color
        }
        
        panGR = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
        view.addGestureRecognizer(panGR)
    }
    
    
    @objc func handlePan(gestureRecognizer:UIPanGestureRecognizer) {
        // calculate the progress based on how far the user moved
        let translation = panGR.translation(in: nil)
        let progress = translation.y / 2 / view.bounds.height
        
        switch panGR.state {
        case .began:
            // begin the transition as normal
            dismiss(animated: true, completion: nil)
        case .changed:
            Hero.shared.update(progress)
            
            // update views' position (limited to only vertical scroll)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:PicimageView.center.x, y:translation.y + PicimageView.center.y))], to: PicimageView)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:naLabel.center.x, y:translation.y + naLabel.center.y))], to: naLabel)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:sendescriptionLabel.center.x, y:translation.y + sendescriptionLabel.center.y))], to: sendescriptionLabel)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:rikuLabel.center.x, y:translation.y + rikuLabel.center.y))], to: rikuLabel)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:languageLabel.center.x, y:translation.y + languageLabel.center.y))], to: languageLabel)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:exmoneyLabel.center.x, y:translation.y + exmoneyLabel.center.y))], to: exmoneyLabel)
            Hero.shared.apply(modifiers: [.position(CGPoint(x:colorLabel.center.x, y:translation.y + colorLabel.center.y))], to: colorLabel)
        default:
            // end or cancel the transition based on the progress and user's touch velocity
            if progress + panGR.velocity(in: nil).y / view.bounds.height > 0.3 {
                Hero.shared.finish()
            } else {
                Hero.shared.cancel()
            }
        }
    }
    
    
    
}
