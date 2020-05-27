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
    var menuTap: UITapGestureRecognizer?
    var isMenuOpen: Bool = false
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var trackButton: UIButton!
    var emptyLabel: UILabel = UILabel()
    let bottomPadding: CGFloat = 10
    var viewModel: HomeViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuBottomY.constant = -(self.userButton.frame.height + bottomPadding)
        navigator = HomeNavigator(nav: self.navigationController)
        setUIElements()
        setViewModel()
        getAllOrders()
        setMenuButtons()
    }
    
    func setUIElements() {
        ordersTableView.estimatedRowHeight = 300
        ordersTableView.rowHeight = UITableView.automaticDimension
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        ordersTableView.backgroundColor = .white
        ordersTableView.register(OrderTableViewCell.defaultNib, forCellReuseIdentifier: OrderTableViewCell.defaultNibName)
        menuCollectionView.register(OrderTabCollectionViewCell.defaultNib, forCellWithReuseIdentifier: OrderTabCollectionViewCell.defaultNibName)
        menuTap = UITapGestureRecognizer(target: self, action: #selector(menuTapped))
        plusImageView.addGestureRecognizer(menuTap!)
        ordersTableView.tableFooterView = UIView()
        ordersTableView.separatorStyle = .none
        self.menuView.backgroundColor = UIColor.init(hexString: "#3c84a6")
        self.title = "Logistic Manager"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func getAllOrders() {
        self.viewModel?.getAllOrdersList()
        self.menuCollectionView.reloadData()
        self.viewModel?.selectedTabIndex = 0
    }
    
    func setViewModel() {
        if let logistic = navigator?.logisticViewModel {
            viewModel = HomeViewModel(logistics: logistic)
            self.setUserName()
            self.viewModel?.reloadBlock = {
                self.ordersTableView.reloadData()
                self.menuCollectionView.reloadData()
                self.menuCollectionView.scrollToItem(at: IndexPath(item: self.viewModel?.selectedTabIndex ?? 0, section: 0), at: .centeredHorizontally, animated: true)
                self.setEmptyView()
            }
        }
        navigator?.userUpdated = {
            self.setMenuButtons()
            self.setUserName()
            self.viewModel?.loadOrdersAsPerTabIndex(index: self.viewModel?.selectedTabIndex ?? 0)
        }
        navigator?.orderUpdated = {
            self.viewModel?.loadOrdersAsPerTabIndex(index: self.viewModel?.selectedTabIndex ?? 0)
        }
    }
    
    func setEmptyView() {
        if let count = self.viewModel?.allOrders.count, count > 0 {
            ordersTableView.backgroundView = nil
        } else {
            emptyLabel.text = "No orders present."
            emptyLabel.textColor = .lightGray
            emptyLabel.textAlignment = .center
            ordersTableView.backgroundView = emptyLabel
        }
    }
    
    func setUserName() {
        self.userNameLabel.text = navigator?.logisticViewModel.currentUser?.firstName
    }
    
    func setMenuButtons() {
        if self.viewModel?.logisiticsMainViewModel?.currentUser == nil {
            self.orderButton.isHidden = true
        } else {
            self.orderButton.isHidden = false
        }
    }
    
    @objc func menuTapped() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveLinear], animations: {
            self.menuBottomY.constant = self.isMenuOpen ? -(self.userButton.frame.height + self.bottomPadding) : 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.isMenuOpen = !self.isMenuOpen
        }
    }
    
    @IBAction func userButtonClick(_ sender: Any) {
        self.navigator?.showCreateUserScreen()
        menuTapped()
    }
    
    @IBAction func orderButtonClick(_ sender: Any) {
        self.navigator?.createNewOrder()
        menuTapped()
        
    }
    
    @IBAction func trackClicked(_ sender: Any) {
        self.navigator?.showGoogleMapLiveTracker()
        //self.navigator?.showAppleMapLiveTracker()
    }
}


extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.allOrders.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: OrderTableViewCell.defaultNibName, for: indexPath) as? OrderTableViewCell {
            if let object = self.viewModel?.allOrders[indexPath.row] {
                cell.configure(object, at: indexPath)
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let object = self.viewModel?.allOrders[indexPath.row] {
            self.navigator?.showOrderDetailScreen(orderDTO: object)
        }
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
            cell.highLightSelected(selectedIndex: self.viewModel?.selectedTabIndex ?? 0, indexPath: indexPath.item)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel?.selectedTabIndex = indexPath.item
        self.menuCollectionView.reloadData()
        var scrollposition = UICollectionView.ScrollPosition.centeredHorizontally
        if let count = self.viewModel?.tabHeadings.count, indexPath.item == count - 1 {
            scrollposition = .right
        }
        collectionView.scrollToItem(at: indexPath, at: scrollposition, animated: true)
        self.viewModel?.loadOrdersAsPerTabIndex(index: indexPath.item)
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
