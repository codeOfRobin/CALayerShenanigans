//
//  DownloadingViewController.swift
//  CALayerShenanigans
//
//  Created by Robin Malhotra on 25/12/18.
//  Copyright © 2018 tailored-swift. All rights reserved.
//

import UIKit

extension CGPoint {
    init(_ x: CGFloat, _ y: CGFloat) {
        self = CGPoint(x: x, y: y)
    }
}

extension CGMutablePath {
    func moveToPoint(_ point: CGPoint) {
        self.move(to: point)
    }
    func addCurveToPoint(_ point: CGPoint, controlPoint1: CGPoint, controlPoint2: CGPoint) {
        self.addCurve(to: point, control1: controlPoint1, control2: controlPoint2)
    }
    func closePath() {
//        self.closeSubpath()
    }

    func addLineToPoint(_ point: CGPoint) {
        self.addLine(to: point)
    }
}

class ArrowLayer: CAShapeLayer {

    let leftSlanty = CAShapeLayer()
    let rightSlanty = CAShapeLayer()
    let straighty = CAShapeLayer()

    var toggle = true {
        didSet {
            self.animate()
        }
    }

    let leftStroke: CGPath = {
        let path = CGMutablePath()
        path.moveToPoint(CGPoint(50, 100))
        path.addLine(to: CGPoint(25, 75))
        path.closePath()
        return path
    }()

    let straightStroke: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(50, 100))
        path.addLine(to: CGPoint(50, 50))
        path.closePath()
        return path
    }()

    let rightStroke: CGPath = {
        let path = CGMutablePath()
        path.move(to: CGPoint(50, 100))
        path.addLine(to: CGPoint(75, 75))
        path.closePath()
        return path
    }()

    override init() {
        super.init()

        rightSlanty.path = rightStroke
        leftSlanty.path = leftStroke
        straighty.path = straightStroke

        for layer in [leftSlanty, straighty, rightSlanty] {
            layer.fillColor = nil
            layer.strokeColor = UIColor.white.cgColor
            layer.lineWidth = 8
            layer.miterLimit = 4
            layer.lineCap = .round
            layer.masksToBounds = true

            if let strokingPath = layer.path?.copy(strokingWithWidth: 8, lineCap: .round, lineJoin: .miter, miterLimit: 4) {
                layer.bounds = strokingPath.boundingBoxOfPath
            }

            layer.actions = [
                "strokeStart": NSNull(),
                "strokeEnd": NSNull(),
                "transform": NSNull()
            ]
            self.addSublayer(layer)
            layer.anchorPoint = CGPoint.zero
        }

        self.leftSlanty.position = CGPoint.init(0, 50)
        self.straighty.position = CGPoint.init(25, 25)
        self.rightSlanty.position = CGPoint.init(25, 50)
    }

    func animate() {
        //        let strokeStart = CABasicAnimation(keyPath: "strokeStart")
        let strokeEnd = CABasicAnimation(keyPath: "strokeEnd")

        strokeEnd.toValue = self.toggle ? 1.0 : 0.0
        strokeEnd.duration = 0.6
        strokeEnd.timingFunction = CAMediaTimingFunction(controlPoints: 0.25, -0.4, 0.5, 1)

        for layer in [leftSlanty, straighty, rightSlanty] {
            layer.ocb_applyAnimation(strokeEnd)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class CircleLayer: CAShapeLayer {

    let circlePath: CGPath = {
        let path = CGMutablePath()
        path.moveToPoint(CGPoint(100, 50))
        path.addCurveToPoint(CGPoint(50, 100), controlPoint1: CGPoint(100, 77.61), controlPoint2: CGPoint(77.61, 100))
        path.addCurveToPoint(CGPoint(0, 50), controlPoint1: CGPoint(22.39, 100), controlPoint2: CGPoint(0, 77.61))
        path.addCurveToPoint(CGPoint(50, 0), controlPoint1: CGPoint(0, 22.39), controlPoint2: CGPoint(22.39, 0))
        path.addCurveToPoint(CGPoint(100, 50), controlPoint1: CGPoint(77.61, 0), controlPoint2: CGPoint(100, 22.39))
        path.closePath()
        return path
    }()

    let circle = CAShapeLayer()

    override init() {
        super.init()

        circle.path = circlePath
        circle.fillColor = nil
        circle.strokeColor = UIColor.white.cgColor
        circle.lineWidth = 8
        circle.miterLimit = 4
        circle.lineCap = .round
        circle.masksToBounds = true


        if let strokingPath = circle.path?.copy(strokingWithWidth: 8, lineCap: .round, lineJoin: .miter, miterLimit: 4) {
            circle.bounds = strokingPath.boundingBoxOfPath
        }

        circle.position = CGPoint.init(100, 100)

        circle.actions = [
            "strokeStart": NSNull(),
            "strokeEnd": NSNull(),
            "transform": NSNull()
        ]

        self.addSublayer(circle)
        self.circle.strokeEnd = 1.0
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DownloadButton: UIButton {

    var toggle = true {
        didSet {
            self.arrowLayer.toggle.toggle()
        }
    }

    let arrowLayer = ArrowLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = .red

        self.layer.addSublayer(arrowLayer)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.arrowLayer.frame = self.bounds
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class DownloadingViewController: UIViewController {

    let button = DownloadButton(frame: CGRect(x: 100, y: 100, width: 200, height: 200))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        self.view.addSubview(button)

        self.button.addTarget(self, action: #selector(animateButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    @objc func animateButton() {
        self.button.toggle.toggle()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
