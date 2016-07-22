//
//  Badge.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 21/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

public class Badge {
    var badgeLink: String? = nil
    var name: String? = nil
    var desc: String? = nil
    
    init(link: String, badgeName: String, badgeDesc: String){
        badgeLink = link
        name = badgeName
        desc = badgeDesc
    }
}