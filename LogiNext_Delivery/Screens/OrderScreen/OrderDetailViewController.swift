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
    
    
    var viewModel: OrderDetailViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setInitialData()
        self.title = ""
        self.setViewModelCallBack()
        self.checkIfCreateOrder()
        self.view.addTapGesture {
            print("Editing ended")
        }
    }
    
    func setViewModelCallBack() {
        self.viewModel?.successBlock = {
            print("Order Saved successfully..")
        }
    }
    
    func checkIfCreateOrder() {
        if self.viewModel?.orderDTO == nil {
            self.setObservers()
            self.orderTitleTextField.keyboardAppearance = .dark
            self.orderTitleTextField.returnKeyType = .next
            self.orderDescTextField.keyboardAppearance = .dark
            self.orderDescTextField.returnKeyType = .done
            self.orderTitleTextField.becomeFirstResponder()
            self.orderTitleTextField.delegate = self
            self.orderDescTextField.delegate = self
        }
    }
    
    static func classFunc() {
        
    }
    
    static func staticFunc() {
        print("Hi..")
    }
    
    func setInitialData() {
        
        
    }
    
    @IBAction func createOrderClicked(_ sender: Any) {
    }
    
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification){

//        let userInfo = notification.userInfo!
//        var keyBoardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        //keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        //var contentInset:UIEdgeInsets = self.scrollView.contentInset
        //contentInset.bottom = keyboardFrame.size.height + 20
        //scrollView.contentInset = contentInset
        if let userInfo = notification.userInfo, let keyBoardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            if let superview = self.orderDescTextField.superview?.superview?.superview?.superview {
                if keyBoardFrame.cgRectValue.intersects(self.view.convert(self.orderDescTextField.frame, from: orderDescTextField)) {
                let bottomPadding = keyBoardFrame.cgRectValue.intersection(self.view.convert(self.orderDescTextField.frame, from: orderDescTextField)).origin.y - keyBoardFrame.cgRectValue.origin.y + self.orderDescTextField.frame.height + 30
                    var contentInset:UIEdgeInsets = self.scrollView.contentInset
                    contentInset.bottom = bottomPadding
                    scrollView.contentInset = contentInset
                }
            }
        }
    }

    @objc func keyboardWillHide(notification:NSNotification){

        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        orderTitleTextField.layer.borderColor = UIColor.white.cgColor
        orderTitleTextField.layer.borderWidth = 1
        orderDescTextField.layer.borderColor = UIColor.white.cgColor
        orderDescTextField.layer.borderWidth = 1
        self.parentTopView.roundCorners(corners: [.topRight, .topLeft], radius: 20)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension OrderDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == orderTitleTextField {
            guard let txt = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {return false}
            orderDescTextField.becomeFirstResponder()
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



