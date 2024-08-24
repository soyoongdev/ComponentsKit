// Copyright © SwiftKit. All rights reserved.

import UIKit

open class UKLoading: UIView {
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayer()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupLayer()
  }

  private func setupLayer() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.black.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = 6.0
    shapeLayer.lineCap = .round
    
    // Adjust the layer's frame to fit within the view's bounds
    shapeLayer.frame = bounds

    let radius = min(bounds.width, bounds.height) / 2 - shapeLayer.lineWidth / 2
    let center = CGPoint(x: bounds.midX, y: bounds.midY)
    shapeLayer.path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true).cgPath

    layer.addSublayer(shapeLayer)

    addSpinnerAnimation(to: shapeLayer)
  }

  private func addSpinnerAnimation(to shapeLayer: CAShapeLayer) {
    // Rotation animation
    let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.fromValue = 0
    rotationAnimation.toValue = CGFloat.pi * 2
    rotationAnimation.duration = 2.0
    rotationAnimation.repeatCount = .infinity
    rotationAnimation.timingFunction = CAMediaTimingFunction(name: .linear)
    shapeLayer.add(rotationAnimation, forKey: "rotationAnimation")
    
    // Stroke end animation
    let strokeEndAnimation = CAKeyframeAnimation(keyPath: "strokeEnd")
    strokeEndAnimation.keyTimes = [0.0, 0.475, 0.95, 1.0]
    strokeEndAnimation.values = [0, 0.8, 0.95, 1.0]
    strokeEndAnimation.duration = 1.5
    strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    strokeEndAnimation.repeatCount = .infinity
    shapeLayer.add(strokeEndAnimation, forKey: "strokeEndAnimation")
    
    // Stroke start animation
    let strokeStartAnimation = CAKeyframeAnimation(keyPath: "strokeStart")
    strokeStartAnimation.keyTimes = [0.0, 0.475, 0.95, 1.0]
    strokeStartAnimation.values = [0.0, 0.1, 0.8, 1.0]
    strokeStartAnimation.duration = 1.5
    strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    strokeStartAnimation.repeatCount = .infinity
    shapeLayer.add(strokeStartAnimation, forKey: "strokeStartAnimation")
  }
}
