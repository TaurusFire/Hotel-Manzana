//
//  Registration.swift
//  HotelManzana
//
//  Created by Cheks Nweze on 05/09/2020.
//  Copyright © 2020 Cheks. All rights reserved.
//

import Foundation

struct Registration {
    var firstName: String
    var lastName: String
    var emailAddress: String

    var checkInDate: Date
    var checkOutDate: Date
    var numberOfAdults: Int
    var numberOfChildren: Int

    var roomType: RoomType
    var wifi: Bool
}
