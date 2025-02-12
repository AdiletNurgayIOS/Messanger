//
//  DataBaseManager.swift
//  NewMessenger
//
//  Created by Adilet on 08.02.2025.
//

import Foundation
import FirebaseDatabase


struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    
}



final class DatabaseManager {
    static let shared =  DatabaseManager()
    private let database = Database.database().reference()
    
}


extension DatabaseManager {
    public func userExists(with email: String, completion: @escaping ((Bool) -> Void ) ) {
        
        //меняем точку на дефиз,потому что firebase не подерживает точку
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapShot in
            if snapShot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    ///insert new user to database
    public func insertUser(with user: ChatAppUser) {
        ///this method write data in database .setValue
        database.child(user.safeEmail ).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }

}
