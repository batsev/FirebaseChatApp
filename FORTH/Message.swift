//
//  Message.swift
//  FORTH
//
//  Created by Никита Бацев on 09.06.2018.
//  Copyright © 2018 Никита Бацев. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {

    var fromId: String?
    var text: String?
    var timestamp: NSNumber?
    var toId: String?
    
    func chatPartnerId() -> String? {
        return fromId == Auth.auth().currentUser?.uid ? toId : fromId
    }
}
