//
//  CalenderEvent.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 16/06/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

class CalendarEvent {
    var ModuleName: String
    var ModuleCode: String
    var Room: String
    var Lecturer: String
    var Time: String
    var Details: String
    var Link: NSURL
    var NotificationType: String
    
    internal init(mName:String, mCode:String ,room:String, lec:String, time:String){
        ModuleName = mName
        ModuleCode = mCode
        Lecturer  = lec
        Time = time
        Room = room
        Link = NSURL()
        NotificationType = ""
        Details = ""
    }
    
    internal init(mName:String, mCode:String ,room:String, lec:String, time:String, details: String, notificationType: String, link: NSURL){
        ModuleName = mName
        ModuleCode = mCode
        Lecturer  = lec
        Time = time
        Room = room
        Link = link
        NotificationType = notificationType
        Details = details
    }
    
    internal init(){
        ModuleName = ""
        ModuleCode = ""
        Lecturer  = ""
        Time = ""
        Room = ""
        Link = NSURL()
        NotificationType = ""
        Details = ""
    }
}