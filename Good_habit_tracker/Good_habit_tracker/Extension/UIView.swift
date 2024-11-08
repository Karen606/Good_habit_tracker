//
//  UIView.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addShadow(color: UIColor = UIColor.black.withAlphaComponent(0.25),
                   offset: CGSize = CGSize(width: 0, height: 4),
                   radius: CGFloat = 4,
                   opacity: Float = 1.0) {
        layer.shadowColor = color.cgColor
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
    }
    
    func addBottomBorder(color: UIColor, thickness: CGFloat) {
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
        bottomBorder.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomBorder)
    }
    
    func toImage() -> UIImage? {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
            defer { UIGraphicsEndImageContext() }
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
}
