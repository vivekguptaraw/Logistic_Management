//
//  VGRadio.swift
//  LogiNext_Delivery
//
//  Created by Vivek Gupta on 24/05/20.
//  Copyright © 2020 Vivek Gupta. All rights reserved.
//

import UIKit

extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}

class VGRadio: UIView {
    @IBOutlet weak var contentView: UIView?
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var outerView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubViews()
    }
    
    func initSubViews() {
        Bundle.main.loadNibNamed(String(describing: VGRadio.self), owner: self, options: nil)
        guard let content = contentView else { return }
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    } 
}
