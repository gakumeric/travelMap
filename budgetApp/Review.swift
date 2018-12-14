//
//  Review.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/24.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import Foundation
import RealmSwift


class ReviewData: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var favorite: String = ""
    @objc dynamic var star = 0.0
    @objc dynamic var photo: NSData? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
