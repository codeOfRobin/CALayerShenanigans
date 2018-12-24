//
//  HamburgerViewController.swift
//  CALayerShenanigans
//
//  Created by Robin Malhotra on 25/12/18.
//  Copyright © 2018 tailored-swift. All rights reserved.
//

import UIKit

class 🍔yButton: UIButton {

    let top = CAShapeLayer()
    let middle = CAShapeLayer()
    let bottom = CAShapeLayer()

    let menuStrokeStart: CGFloat = 0.325
    let menuStrokeEnd: CGFloat = 0.9

    let hamburgerStrokeStart: CGFloat = 0.028
    let hamburgerStrokeEnd: CGFloat = 0.111

    let shortStroke = { () -> CGMutablePath in
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 2, y: 2))
        path.addLine(to: CGPoint(x: 28, y:2))
        return path
    }()

    let outline: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 10, y: 27))
        path.addCurve(to: CGPoint(x: 40, y: 27), control1: CGPoint(x: 12, y: 27), control2: CGPoint(x: 28.02, y: 27))
        path.addCurve(to: CGPoint(x: 27, y: 02), control1: CGPoint(x: 55.92, y: 27), control2: CGPoint(x: 50.47, y: 2))
        path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
        path.addCurve(to: CGPoint(x: 27, y: 52), control1: CGPoint(x: 2, y: 40.84), control2: CGPoint(x: 13.16, y: 52))
        path.addCurve(to: CGPoint(x: 52, y: 27), control1: CGPoint(x: 40.84, y: 52), control2: CGPoint(x: 52, y: 40.84))
        path.addCurve(to: CGPoint(x: 27, y: 2), control1: CGPoint(x: 52, y: 13.16), control2: CGPoint(x: 42.39, y: 2))
        path.addCurve(to: CGPoint(x: 2, y: 27), control1: CGPoint(x: 13.16, y: 2), control2: CGPoint(x: 2, y: 13.16))
        return path
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.top.path = shortStroke
        self.middle.path = outline
        self.bottom.path = shortStroke

        [top, middle, bottom].forEach { layer in
            layer.fillColor = nil
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 4
            layer.miterLimit = 4
            layer.lineCap = .round
            layer.masksToBounds = true

            if let strokingPath = layer.path?.copy(strokingWithWidth: 4, lineCap: .round, lineJoin: .miter, miterLimit: 4) {
                layer.bounds = strokingPath.boundingBoxOfPath
            }

            layer.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            self.layer.addSublayer(layer)
        }

        self.top.anchorPoint = CGPoint(x: 28.0 / 30.0, y: 0.5)
        self.top.position = CGPoint(x: 40, y: 18)

        self.middle.position = CGPoint(x: 27, y: 27)
        self.middle.strokeStart = hamburgerStrokeStart
        self.middle.strokeEnd = hamburgerStrokeEnd

        self.bottom.anchorPoint = CGPoint(x: 28.0 / 30.0, y: 0.5)
        self.bottom.position = CGPoint(x: 40, y: 36)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var showsMenu: Bool = false {
        didSet {
            let strokeStart = CABasicAnimation(keyPath: "strokeStart")
            let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")

            if self.showsMenu {
                strokeStart.toValue = menuStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)

                strokeEnd.toValue = menuStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)
            } else {
                strokeStart.toValue = hamburgerStrokeStart
                strokeStart.duration = 0.5
                strokeStart.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.5, 1.2)
                strokeStart.beginTime = CACurrentMediaTime() + 0.1
                strokeStart.fillMode = .backwards

                strokeEnd.toValue = hamburgerStrokeEnd
                strokeEnd.duration = 0.6
                strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, 0.3, 0.5, 0.9)
            }

            self.middle.ocb_applyAnimation(strokeStart)
            self.middle.ocb_applyAnimation(strokeEnd)

            let topTransform = CABasicAnimation(keyPath: "transform")
            topTransform.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, -0.8, 0.5, 1.85)
            topTransform.duration = 0.4
            topTransform.fillMode = .backwards

            let bottomTransform = topTransform.copy() as! CABasicAnimation

            if self.showsMenu {
                let translation = CATransform3DMakeTranslation(-4, 0, 0)

                topTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, -0.7853975, 0, 0, 1))
                topTransform.beginTime = CACurrentMediaTime() + 0.25

                bottomTransform.toValue = NSValue(caTransform3D: CATransform3DRotate(translation, 0.7853975, 0, 0, 1))
                bottomTransform.beginTime = CACurrentMediaTime() + 0.25
            } else {
                topTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
                topTransform.beginTime = CACurrentMediaTime() + 0.05

                bottomTransform.toValue = NSValue(caTransform3D: CATransform3DIdentity)
                bottomTransform.beginTime = CACurrentMediaTime() + 0.05
            }

            self.top.ocb_applyAnimation(topTransform)
            self.bottom.ocb_applyAnimation(bottomTransform)
        }
    }
}

extension CALayer {
    func ocb_applyAnimation(_ animation: CABasicAnimation) {
        let copy = animation.copy() as! CABasicAnimation

        if copy.fromValue == nil {
            copy.fromValue = self.presentation()!.value(forKeyPath: copy.keyPath!)
        }

        self.add(copy, forKey: copy.keyPath)
        self.setValue(copy.toValue, forKeyPath:copy.keyPath!)
    }
}

class HamburgerViewController: UIViewController {

    let button = 🍔yButton(frame: CGRect(x: 133, y: 133, width: 54, height: 54))

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 38.0 / 255, green: 151.0 / 255, blue: 68.0 / 255, alpha: 1)
        self.button.addTarget(self, action: #selector(HamburgerViewController.toggle(_:)), for:.touchUpInside)

        self.view.addSubview(button)
        // Do any additional setup after loading the view.
    }


    override var preferredStatusBarStyle : UIStatusBarStyle  {
        return .lightContent
    }

    @objc func toggle(_ sender: AnyObject!) {
        self.button.showsMenu.toggle()
    }

}
