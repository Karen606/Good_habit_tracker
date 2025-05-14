//
//  Font.swift
//  Good_habit_tracker
//
//  Created by Karen Khachatryan on 07.11.24.
//

import UIKit

extension UIFont {
    static func inter(size: CFloat) -> UIFont? {
        return UIFont(name: "Inter-Regular", size: CGFloat(size))
    }
    
    static func alternatesRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "MontserratAlternates-Regular", size: CGFloat(size))
    }
    
    static func alternatesMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "MontserratAlternates-Medium", size: CGFloat(size))
    }
    
    static func montserratMedium(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Medium", size: CGFloat(size))
    }
    
    static func montserratRegular(size: CFloat) -> UIFont? {
        return UIFont(name: "Montserrat-Regular", size: CGFloat(size))
    }
}
