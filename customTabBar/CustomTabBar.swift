//
//  CustomTabBar.swift
//  customTabBar
//
//  Created by Admin on 05/12/23.
//

import UIKit

@IBDesignable
class CustomTabBar: UITabBar, CAAnimationDelegate {
        
    private var shapeLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private var count = 0
    private var transparentStroke: CGFloat = 6
    func setupTabbar() {
        tintColor = .white
        self.layer.cornerRadius = self.frame.height / 2
        let path = createNewPath()
        shapeLayer.strokeColor = UIColor.gray.cgColor
        shapeLayer.fillColor = UIColor.blue.cgColor
        shapeLayer.lineWidth = 0
        shapeLayer.path = path.cgPath
        gradientLayer.colors = [UIColor(red: 0.9882, green: 0.2196, blue: 0.698, alpha: 1.0).cgColor /* #fc38b2 */, UIColor(red: 0.6471, green: 0.0157, blue: 0.4863, alpha: 1.0).cgColor /* #a5047c */]
        gradientLayer.frame = bounds
        gradientLayer.mask = shapeLayer
        
        layer.masksToBounds = true
        if layer.sublayers?[0] != gradientLayer{
            layer.insertSublayer(gradientLayer, at: 0)
        }
        
    }
    
    
    private func movePosition() {
        
        let nextXPosition = nextXPosition()
        print(nextXPosition)
        shapeLayer.position = CGPoint(x: nextXPosition - (self.frame.height / 2), y: 0)
        
    }
    
    
    override func draw(_ rect: CGRect) {
        
        if count == 0 {
            setupTabbar()
            movePosition()
        } else {
            animatePath()
        }
        
        count += 1
        
    }
    
    
    func createNewPath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: -self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.height / 2, y: 0))
        
        
        path.addArc(withCenter: CGPoint(x: self.frame.height / 2, y: self.frame.height / 2), radius: self.frame.height / 2 + transparentStroke, startAngle: Double.pi * 27 / 18, endAngle: Double.pi / 2, clockwise: false)
        
        path.addLine(to: CGPoint(x: -self.frame.width, y: self.frame.height))
        path.close()
        
        path.move(to: CGPoint(x: self.frame.height, y: self.frame.height / 2))
        
        path.addArc(withCenter: CGPoint(x: self.frame.height / 2, y: self.frame.height / 2), radius: self.frame.height / 2, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        path.move(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.height / 2, y: 0))
        
        path.addArc(withCenter: CGPoint(x: self.frame.height / 2, y: self.frame.height / 2), radius: self.frame.height / 2 + transparentStroke, startAngle: Double.pi * 27 / 18, endAngle: Double.pi / 2, clockwise: true)
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.close()
        
        return path
        
    }
    
    
    func nextXPosition() -> CGFloat{
        let totalItem = items?.count ?? 0
        var selectedItemIndex = 0
        for (index, item) in (items ?? []).enumerated(){
            if self.selectedItem == item{
                selectedItemIndex = index
            }
        }
        guard let tabView = items?[selectedItemIndex].value(forKey: "view") as? UIView else { return  0 }
        print(tabView.frame.width)
        return tabView.frame.minX + (tabView.frame.width / 2)
        
    }
    
    
    private func animatePath() {
        let nextXPosition = nextXPosition()
        print(nextXPosition)
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.2
        animation.toValue = CGPoint(x: nextXPosition - (self.frame.height / 2), y: 0)
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        animation.delegate = self
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        // Add the animation to the shape layer
        shapeLayer.add(animation, forKey: "positionAnimation")
    }
    
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        movePosition()
    }
    
    func tabbarStartXPositioning() -> CGFloat{
        let midX = UIApplication.shared.keyWindow!.screen.bounds.width / 2
        if UIDevice().userInterfaceIdiom == .phone{
            let itemSize = (items?.count ?? 0) * 70
            return  midX - CGFloat(itemSize / 2)
        }else{
            let itemSize = (items?.count ?? 0) * 70
            return  midX - CGFloat(itemSize / 2)
        }
        
    }
    
    
    override func layoutSubviews() {
        print("****")
        super.layoutSubviews()
        self.isTranslucent = true
        var tabFrame = self.frame
        tabFrame.size.height = 70
        print(tabFrame.size.height)
        print(self.frame.origin.y)
        itemWidth = 70
           tabFrame.origin.y = (UIApplication.shared.keyWindow?.screen.bounds.height ?? 0)  - 75 - (UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0)
        print((UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0))
        print(self.frame.height)
        
        let XPosition = tabbarStartXPositioning()
        
        print("**")
        tabFrame.origin.x = XPosition
        tabFrame.size.width = (UIApplication.shared.keyWindow?.screen.bounds.width ?? 0) - (XPosition * 2)
        self.frame = tabFrame
        
        itemPositioning = .centered
        
//        self.items?.forEach({ item in
//            item.imageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        })
        self.items?.forEach({ $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: -5.0) })
        
    }
    
}


extension UITabBar {
    // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
    // the Master view controller shows the UITabBarItem icon next to the text
//    override open var traitCollection: UITraitCollection {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            return UITraitCollection(horizontalSizeClass: .compact)
//        }
//        return super.traitCollection
//    }
    
    
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if #available(iOS 17.0, *) {
                self.traitOverrides.horizontalSizeClass = .compact
                self.traitOverrides.verticalSizeClass = .compact
            }
            else {
                return UITraitCollection(horizontalSizeClass: .compact)
            }
        }
        return super.traitCollection
    }
}
