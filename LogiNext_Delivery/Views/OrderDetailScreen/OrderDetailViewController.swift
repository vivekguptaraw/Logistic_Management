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
    
    @IBOutlet weak var orderTitleTextField: UITextField!
    @IBOutlet weak var orderDescTextField: UITextView!
    @IBOutlet weak var orderDescHeight: NSLayoutConstraint!
    @IBOutlet weak var orderTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var createOrderButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var statusCollectionView: UICollectionView!
    @IBOutlet weak var statusCollectionHeight: NSLayoutConstraint!
    @IBOutlet weak var pickUpButton: UIButton!
    @IBOutlet weak var deliverButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    var viewModel: OrderDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = ""
        self.setCallBacks()
        self.checkIfCreateOrder()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setLayout() {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let w = statusCollectionView.frame.width
        statusCollectionView.backgroundColor = .clear
        let h: CGFloat = 60
        layout.itemSize = CGSize(width: w, height: h)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 8
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.scrollDirection = .vertical
        layout.prepare()
        statusCollectionView.collectionViewLayout = layout
        statusCollectionView.showsHorizontalScrollIndicator = false
        statusCollectionView.showsVerticalScrollIndicator = false
        statusCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setCallBacks() {
        self.view.addTapGesture {
            print("Editing ended")
        }
        self.viewModel?.successBlock = {[weak self] in
            print("Order Saved successfully..")
            guard let slf = self else {return}
            slf.createOrderButton.setTitle("Order added...", for: .normal)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                slf.navigationController?.popViewController(animated: true)
            }
        }
        self.viewModel?.orderUpdateSuccessBlock = {
            self.updateOrderStatus()
        }
    }
    
    func updateOrderStatus() {
        if let order = self.viewModel?.orderDTO {
            if order.isQueued {
                self.pickUpButton.isHidden = false
                self.deliverButton.isHidden = true
                self.cancelButton.isHidden = false
            }
            if order.isInTransit {
                self.deliverButton.isHidden = false
                self.pickUpButton.isHidden = true
                self.cancelButton.isHidden = false
            }
            if order.isDelivered {
                self.deliverButton.isHidden = true
                self.pickUpButton.isHidden = true
                self.cancelButton.isHidden = false
            }
            if order.isCancelled {
                self.deliverButton.isHidden = true
                self.pickUpButton.isHidden = true
                self.cancelButton.isHidden = true
            }
            self.statusCollectionView.reloadData()
        } else {
            self.deliverButton.isHidden = true
            self.pickUpButton.isHidden = true
            self.cancelButton.isHidden = true
        }
        
    }
    
    static func staticFunc() {
        print("Hi..")
    }
    
    func checkIfCreateOrder() {
        if self.viewModel?.orderDTO == nil {
            self.setObservers()
            self.title = "Create Order"
            self.orderTitleTextField.keyboardAppearance = .dark
            self.orderTitleTextField.returnKeyType = .next
            self.orderDescTextField.keyboardAppearance = .dark
            self.orderDescTextField.returnKeyType = .done
            self.orderTitleTextField.becomeFirstResponder()
            self.orderTitleTextField.delegate = self
            self.orderDescTextField.delegate = self
            orderTitleTextField.attributedPlaceholder = NSAttributedString(string: "Order Title", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray.withAlphaComponent(0.9), NSAttributedString.Key.font: UIFont(name: "DIN Alternate", size: 17)])
            orderTitleTextField.layer.borderColor = UIColor.white.cgColor
            orderTitleTextField.layer.borderWidth = 1
            orderDescTextField.layer.borderColor = UIColor.white.cgColor
            orderDescTextField.layer.borderWidth = 1
            statusCollectionHeight.constant = 0
            self.updateOrderStatus()
        } else {
            self.title = self.viewModel?.orderDTO?.name
            self.viewModel?.setOrderStatus()
            self.updateOrderStatus()
            self.createOrderButton.isHidden = true
            orderDescHeight.constant = 0
            orderTitleHeight.constant = 0
            self.view.layoutIfNeeded()
            titleLabel.text = self.viewModel?.orderDTO?.name
            overViewLabel.text = self.viewModel?.orderDTO?.orderDescription
            statusCollectionView.dataSource = self
            statusCollectionView.delegate = self
            statusCollectionView.register(StatusCollectionViewCell.defaultNib, forCellWithReuseIdentifier: StatusCollectionViewCell.defaultNibName)
            setLayout()
            DispatchQueue.main.async {
                self.statusCollectionHeight.constant = self.statusCollectionView.contentSize.height
                self.view.layoutIfNeeded()
                
            }
        }
    }
    
    @IBAction func createOrderClicked(_ sender: Any) {
        guard let txt = orderTitleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), !txt.isEmpty else {
            self.orderTitleTextField.layer.borderColor = UIColor.red.cgColor
            return}
        self.viewModel?.createOrder(name: txt, desc: orderDescTextField.text ?? "N/A", date: Date())
    }
    @IBAction func pickUpClicked(_ sender: Any) {
        self.viewModel?.pickUpOrder()
    }
    
    @IBAction func deliverClicked(_ sender: Any) {
        self.viewModel?.deliverOrder()
    }
    
    @IBAction func cancelClicked(_ sender: Any) {
        self.viewModel?.cancelOrder()
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        if let userInfo = notification.userInfo, let keyBoardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if keyBoardFrame.cgRectValue.intersects(self.view.convert(self.orderDescTextField.frame, from: orderDescTextField)) {
            let bottomPadding = keyBoardFrame.cgRectValue.intersection(self.view.convert(self.orderDescTextField.frame, from: orderDescTextField)).origin.y - keyBoardFrame.cgRectValue.origin.y + self.orderDescTextField.frame.height + 30
                var contentInset:UIEdgeInsets = self.scrollView.contentInset
                contentInset.bottom = bottomPadding
                scrollView.contentInset = contentInset
                scrollView.setContentOffset(CGPoint(x: 0, y:  bottomPadding / 2), animated: true)
            }
        }
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.parentTopView.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBorders()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel = nil
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func addBorders() {
        pickUpButton.addBorder(color: .white, width: 1)
        deliverButton.addBorder(color: .white, width: 1)
        cancelButton.addBorder(color: .white, width: 1)
    }
    
    deinit {
        print("deinit..")
    }
}

extension OrderDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.orderStatus.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatusCollectionViewCell.defaultNibName, for: indexPath) as? StatusCollectionViewCell {
            if let item = self.viewModel?.orderStatus[indexPath.row] {
                cell.configure(item, at: indexPath)
                if let order = self.viewModel?.orderDTO {
                    let color = self.viewModel?.orderDTO?.getStatusColor()
                    if item.0 == order.status {
                        cell.setRadioColor(color: color, shouldShowColor: true)
                    } else {
                        cell.setRadioColor(color: nil, shouldShowColor: false)
                    }
                    
                }
                
                
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

extension OrderDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == orderTitleTextField {
            guard let txt = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return false}
            orderDescTextField.becomeFirstResponder()
            orderTitleTextField.layer.borderColor = UIColor.white.cgColor
            return true
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //highlightTextField(textField: textField)
    }
    
    func highlightTextField(textField: UITextField) {
        if let superview = textField.superview?.superview {
            var point = superview.frame.origin
            point.y = point.y - 5
            scrollView.setContentOffset(point, animated: true)
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //scrollView.setContentOffset(.zero, animated: true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        print("--> Reason \(reason.rawValue)")
    }
}

extension OrderDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
    }
}



