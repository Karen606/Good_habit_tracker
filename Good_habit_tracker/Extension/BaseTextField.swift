//
//  BaseTextField.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 08.11.24.
//

import UIKit

class BaseTextField: UITextField {
    private var padding = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 14)
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func checkValidation() -> Bool {
        if let text = text?.trimmingCharacters(in: .whitespaces), text.isEmpty {
            return false
        } else {
            return true
        }
    }
    
    func commonInit() {
        self.backgroundColor = .baseGray
        self.font = .montserratRegular(size: 22)
        self.layer.cornerRadius = 16
        self.textColor = .text
    }
}

extension UITextField {
    func addInputAccessoryView(title: String, target: Any, selector: Selector) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar
    }
}
