//
//  UCLanAPI.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

open class UCLanAPI {
    open static let ENDPOINT = "https://cyprustimetable.uclan.ac.uk/TimetableAPI/TimetableWebService.asmx/"
    open static let SecurityToken = "e84e281d4c9b46f8a30e4a2fd9aa7058"
    open static let listRooms = "app_getRooms"
    open static let login = "app_login"
    open static let getTimetableByStudent = "app_getTimetableByStudent"
    open static let getTimetableByLecturer = "app_getTimetableByLecturer"
    open static let getTimetableByRoom = "app_getTimetableByRoom"
    open static let getUpcomingExams = "app_getUpcomingExams"
    open static let getNotifications = "app_getNotificationsByUser"
    open static let updateNotificationsStatus = "app_updateNotificationStatus"
    open static let getNotificationById = "app_getNotification"
    open static let listBadges = "app_getBadgesByStudent"
    open static let getAvgAttendance = "app_getAverageAtendanceByStudent"
}
