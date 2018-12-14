//
//  CountryCell.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/19.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import UIKit
import Hero

class CountryCell: UICollectionViewCell {
    
    @IBOutlet weak var SMimageView: UIImageView!
    @IBOutlet weak var SMNameView: UILabel!
    @IBOutlet weak var SMDescriptLabel: UILabel!
    
    
    var city: City? {
        didSet {
            guard let city = city else { return }
            let name = city.name
            
            SMNameView.text = name
            SMNameView.hero.id = "\(name)_name"
            SMNameView.hero.modifiers = [.zPosition(4)]
            
            SMimageView.image = city.image
            SMimageView.hero.id = "\(name)_image"
            SMimageView.hero.modifiers = [.zPosition(2)]
            
            SMDescriptLabel.hero.id = "\(name)_description1"
            SMDescriptLabel.hero.modifiers = [.zPosition(4)]
            SMDescriptLabel.text = city.shortDescription
        }
    }
}
