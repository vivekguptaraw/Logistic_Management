//
//  UserListViewModel.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import Foundation

class UserListViewModel {
    fileprivate(set) var users: [UserDTO] = []
    
    var logisiticsMainViewModel: LogisticViewModel?
    var reloadBlock: (() -> Void)?
    
    init(logistics: LogisticViewModel) {
        self.logisiticsMainViewModel = logistics
    }
    
    func getUsers() {
        logisiticsMainViewModel?.getAllUsers {[weak self] (users) in
            guard let slf = self else {return}
            slf.users = users
            slf.reloadBlock?()
        }
    }
    
    func addNewUser(name: String, date: Date) {
        logisiticsMainViewModel?.saveUser(name: name, date: date, completion: { success in
            self.getUsers()
        })
    }
}