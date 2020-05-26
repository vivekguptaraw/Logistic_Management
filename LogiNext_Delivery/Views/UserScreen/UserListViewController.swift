//
//  UserListViewController.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var viewModel: UserListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIControls()
        self.setViewModel()
    }
    
    func setViewModel() {
        viewModel?.reloadBlock = {
            self.tableView.reloadData()
        }
        viewModel?.getUsers()
    }
    
    func setUIControls() {
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UserTableViewCell.defaultNib, forCellReuseIdentifier: UserTableViewCell.defaultNibName)
        tableView.dataSource = self
        tableView.delegate = self
        textField.returnKeyType = .done
        textField.delegate = self
        textField.becomeFirstResponder()
        self.view.addTapGesture(onClick: didTap)
    }
    
    @objc func didTap() {
        if self.textField.isFirstResponder {
            self.view.endEditing(true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.textField.borderStyle = .line
        self.textField.backgroundColor = .white
    }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.users.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.defaultNibName, for: indexPath) as? UserTableViewCell {
            if let user = self.viewModel?.users[indexPath.row] {
                cell.configure(user, at: indexPath)
                cell.selectedDelegate = self
                if let uid = self.viewModel?.logisiticsMainViewModel?.currentUser?.userId {
                    cell.setUserHighlight(uid: uid)
                }
                
            }
            return cell
        }
        return UITableViewCell()
    }
}

extension UserListViewController: UserSelected {
    func selectedUser(model: UserDTO) {
        self.viewModel?.logisiticsMainViewModel?.setCurrentUser(userDTO: model)
        self.dismiss(animated: true, completion: {
            self.viewModel?.navigator?.userUpdated?()
        })
    }
}

extension UserListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let txt = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !txt.isEmpty else {return false}
        textField.text = nil
        textField.resignFirstResponder()
        viewModel?.addNewUser(name: txt, date: Date())
        return true
    }
}
