//
//  UserListViewModel.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class UserListViewModel {
    fileprivate(set) var users: [UserDTO] = []
    
    var logisiticsMainViewModel: LogisticViewModel?
    var reloadBlock: (() -> Void)?
    var navigator: IHomeNavigator?
    
    init(logistics: LogisticViewModel, orderDTO: OrderDTO? = nil) {
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
        self.logisiticsMainViewModel?.manager.deleteOldUsersLocationFromDb()
        let userDTO = UserDTO(name: name, id: Int(date.timeIntervalSince1970))
        logisiticsMainViewModel?.saveUser(userDTO: userDTO, completion: { success in
            self.getUsers()
        })
    }
}
