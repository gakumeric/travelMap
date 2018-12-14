//
//  StoryboardExample.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/16.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import SwiftyOnboard

class StoryboardExample: UIViewController {

    @IBOutlet weak var swiftyOnOnboard: SwiftyOnboard!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        swiftyOnOnboard.style = .light
        swiftyOnOnboard.delegate = self
        swiftyOnOnboard.dataSource = self
        swiftyOnOnboard.backgroundColor = UIColor(red: 46/256, green: 46/256, blue: 76/256, alpha: 1)
    }
    
    @objc func handleSkip() {
        swiftyOnOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnOnboard?.goToPage(index: index + 1, animated: true)
    }
}

extension StoryboardExample: SwiftyOnboardDelegate, SwiftyOnboardDataSource {
    
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let view = CustomPage.instanceFromNib() as? CustomPage
        view?.image.image = UIImage(named: "tutorial\(index).png")
        if index == 0 {
            //On the first page, change the text in the labels to say the following:
            view?.titleLabel.text = "Planet earth is extraordinary"
            view?.subTitleLabel.text = "Earth, otherwise known as the World, is the third planet from the Sun."
        } else if index == 1 {
            //On the second page, change the text in the labels to say the following:
            view?.titleLabel.text = "The mystery of\n outer space"
            view?.subTitleLabel.text = "Outer space or just space, is the void that exists between celestial bodies, including Earth."
        } else {
            //On the thrid page, change the text in the labels to say the following:
            view?.titleLabel.text = "Extraterrestrial\n life"
            view?.subTitleLabel.text = "Extraterrestrial life, also called alien life, is life that does not originate from Earth."
        }
        return view
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = CustomOverlay.instanceFromNib() as? CustomOverlay
        overlay?.skip.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay?.buttonContinue.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let overlay = overlay as! CustomOverlay
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.buttonContinue.tag = Int(position)
        if currentPage == 0.0 {
            overlay.buttonContinue.setTitle("Next", for: .normal)
            overlay.skip.setTitle("Back", for: .normal)
            overlay.skip.isHidden = false
        } else if currentPage == 1.0 {
            overlay.buttonContinue.setTitle("Continue", for: .normal)
            overlay.skip.setTitle("Back", for: .normal)
            overlay.skip.isHidden = false
        } else {
            overlay.buttonContinue.setTitle("Get Started!", for: .normal)
            overlay.skip.isHidden = true
        }
    }
}
