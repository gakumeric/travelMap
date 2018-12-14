//
//  MapData.swift
//  mapApp
//
//  Created by 木下岳 on 2018/07/13.
//  Copyright © 2018年 gakukinoshita. All rights reserved.
//

import Foundation
import RealmSwift


class Mapdata: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var number: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var purpose: String = ""
    @objc dynamic var money = 0
    @objc dynamic var exchange: String = ""
    @objc dynamic var todoone: String = ""
    @objc dynamic var todotwo: String = ""
    @objc dynamic var todothree: String = ""
    @objc dynamic var days = 0
    @objc dynamic var buyone: String = ""
    @objc dynamic var buytwo: String = ""
    @objc dynamic var buythree: String = ""
    @objc dynamic var memotext: String = ""
    @objc dynamic var priority = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
