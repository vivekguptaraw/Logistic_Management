//
//  OrderDetailViewController.swift
//  GithubFetchDemo
//
//  Created by Vivek Gupta on 13/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

class OrderDetailViewController: UIViewController {
    
    @IBOutlet weak var topImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var parentTopView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var contributorsCollectionView: UICollectionView!
    
    @IBOutlet weak var similarViewHeight: NSLayoutConstraint!
    @IBOutlet weak var sizeCountLabel: UILabel!
    @IBOutlet weak var starGazerCountLabel: UILabel!
    @IBOutlet weak var forksCountLabel: UILabel!
    
    var viewModel: OrderDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialData()
        self.title = ""
        self.setViewModelCallBack()
    }
    
    func setViewModelCallBack() {
        self.viewModel?.successBlock = {
            print("Order Saved successfully..")
        }
    }
    
    func addMySubViews() {
        
    }
    
    static func classFunc() {
        
    }
    
    static func staticFunc() {
        print("Hi..")
    }
    
    func setInitialData() {
        
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.parentTopView.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.contentInset = UIEdgeInsets(top: self.topImageView.frame.height - 40, left: 0, bottom: 0, right: 0)
    }
    

}



