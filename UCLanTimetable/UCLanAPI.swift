//
//  UCLanAPI.swift
//  UCLanTimetable
//
//  Created by Salah Eddin Alshaal on 28/07/16.
//  Copyright © 2016 Salah Eddin Alshaal. All rights reserved.
//

import Foundation

public class UCLanAPI {
    public static let ENDPOINT = "https://cyprustimetable.uclan.ac.uk/TimetableAPI/TimetableWebService.asmx/"
    public static let SecurityToken = "e84e281d4c9b46f8a30e4a2fd9aa7058"
    public static let listRooms = "app_getRooms"
    public static let login = "app_login"
    public static let getTimetableByStudent = "app_getTimetableByStudent"
    public static let getTimetableByLecturer = "app_getTimetableByLecturer"
    public static let getTimetableByRoom = "app_getTimetableByRoom"
    public static let getUpcomingExams = "app_getUpcomingExams"
    public static let getNotifications = "app_getNotificationsByUser"
    public static let updateNotificationsStatus = "app_updateNotificationStatus"
    public static let getNotificationById = "app_getNotification"
}