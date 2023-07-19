import Foundation
import Vapor

public struct AppointmentModel: Codable, Content {
    let department: Department
    let email: String
    let fullname: String
    let appointment_date: Date
    let telephone: UInt
}

extension AppointmentModel {
    init(_ model: Appointment) {
        self.department = model.dept
        self.email = model.email
        self.fullname = model.fullname
        self.appointment_date = model.appointment_date
        self.telephone = model.telephone
    }
}