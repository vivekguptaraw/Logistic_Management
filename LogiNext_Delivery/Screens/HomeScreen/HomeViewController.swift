//
//  HomeViewController.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 23/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var navigator: IHomeNavigator?
    @IBOutlet weak var menuBottomY: NSLayoutConstraint!
    
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var ordersTableView: UITableView!
    var selectedTabIndex: Int = 0
    var menuTap: UITapGestureRecognizer?
    var isMenuOpen: Bool = false
    
    var viewModel: OrderListViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBottomY.constant = -(self.userButton.frame.height + 20)
        navigator = HomeNavigator(nav: self.navigationController)
        setUIElements()
        setViewModel()
        getAllOrders()
    }
    
    func setUIElements() {
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        ordersTableView.register(OrderTableViewCell.defaultNib, forCellReuseIdentifier: OrderTableViewCell.defaultNibName)
        menuCollectionView.register(OrderTabCollectionViewCell.defaultNib, forCellWithReuseIdentifier: OrderTabCollectionViewCell.defaultNibName)
        menuTap = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        plusImageView.addGestureRecognizer(menuTap!)
        ordersTableView.tableFooterView = UIView()
        ordersTableView.separatorStyle = .none
    }
    
    func getAllOrders() {
        self.viewModel?.getAllOrdersList()
        self.menuCollectionView.reloadData()
        self.selectedTabIndex = 0
    }
    
    func setViewModel() {
        if let logistic = navigator?.logisticViewModel {
            viewModel = OrderListViewModel(logistics: logistic)
            self.viewModel?.reloadBlock = {
                self.ordersTableView.reloadData()
            }
        }
        
    }
    
    @objc func menuTapped() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
            self.menuBottomY.constant = self.isMenuOpen ? -(self.userButton.frame.height + 20) : 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.isMenuOpen = !self.isMenuOpen
        }
    }
    
    @IBAction func userButtonClick(_ sender: Any) {
        menuTapped()
        self.navigator?.showCreateUserScreen()
    }
    
    @IBAction func orderButtonClick(_ sender: Any) {
        menuTapped()
        self.navigator?.createNewOrder()
    }
    
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.allOrders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.defaultNibName, for: indexPath) as? OrderTableViewCell {
            if let object = self.viewModel?.allOrders[indexPath.row] as? OrderDTO {
                cell.configure(object, at: indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.tabHeadings.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrderTabCollectionViewCell.defaultNibName, for: indexPath) as? OrderTabCollectionViewCell {
            if let item = viewModel?.tabHeadings[indexPath.row] {
                cell.configure(item, at: indexPath)
            }
            if selectedTabIndex == indexPath.item {
                cell.backgroundColor =  UIColor(hexString: "#FFEF8C")
            } else {
                cell.backgroundColor =  .clear
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTabIndex = indexPath.item
        self.menuCollectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let item = viewModel?.tabHeadings[indexPath.row] {
            let itemSize = item.size(withAttributes: [
                NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20, weight: .semibold)
            ])
            let size = CGSize(width: itemSize.width + 20, height:  collectionView.bounds.height)
            print(size, item)
            return size
        }
        return .zero
    }
}
