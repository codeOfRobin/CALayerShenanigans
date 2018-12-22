//
//  ViewController.swift
//  CALayerShenanigans
//
//  Created by Robin Malhotra on 22/12/18.
//  Copyright © 2018 tailored-swift. All rights reserved.
//

import UIKit

class ClockFace: CAShapeLayer {
    var time = Date()

    let hourHand = CAShapeLayer()
    let minuteHand = CAShapeLayer()

    override init() {
        super.init()
        self.bounds = CGRect(x: 0, y: 0, width: 200, height: 200)
        self.path = UIBezierPath(ovalIn: self.bounds).cgPath
        self.fillColor = UIColor.white.cgColor
        self.strokeColor = UIColor.black.cgColor
        self.lineWidth = 4.0

        self.hourHand.path = UIBezierPath(rect: CGRect(x: -2, y: -70, width: 4, height: 70)).cgPath
        self.hourHand.fillColor = UIColor.black.cgColor
        self.hourHand.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2.0)
        self.addSublayer(self.hourHand)

        self.minuteHand.path = UIBezierPath(rect: CGRect(x: -1, y: -90, width: 2, height: 90)).cgPath
        self.minuteHand.fillColor = UIColor.black.cgColor
        self.minuteHand.position = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2.0)
        self.addSublayer(self.minuteHand)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ViewController: UIViewController {

    let datePicker = UIDatePicker()
    let clockFace = ClockFace()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.layer.addSublayer(self.clockFace)

        self.view.addSubview(datePicker)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        self.clockFace.position = CGPoint(x: self.view.bounds.size.width/2, y: 150)

        self.datePicker.frame = CGRect.init(x: 0, y: 200, width: view.bounds.width, height: 150)
    }

}

