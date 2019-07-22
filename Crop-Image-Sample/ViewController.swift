//
//  ViewController.swift
//  Crop-Image-Sample
//
//  Created by kawaharadai on 2019/07/20.
//  Copyright © 2019 kawaharadai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    private var baseView: UIView!
    private let humanFrame = [CGRect(x: 60, y: 0, width: 176, height: 184)]
    private let pizzaFrame = [CGRect(x: 0, y: 250, width: 264, height: 93),
                              CGRect(x: 120, y: 180, width: 200, height: 70)]
    private let alcoholFrame = [CGRect(x: 0, y: 30, width: 76, height: 280),
                                CGRect(x: 45, y: 130, width: 76, height: 132),
                                CGRect(x: 320, y: 80, width: 100, height: 198)]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tapPizza(_ sender: UIButton) {
        cropImage(frames: pizzaFrame)
    }

    @IBAction func tapHuman(_ sender: UIButton) {
        cropImage(frames: humanFrame)
    }

    @IBAction func tapAlcohol(_ sender: UIButton) {
        cropImage(frames: alcoholFrame)
    }

    @IBAction func tapReset(_ sender: UIButton) {
        reset()
    }

    private func cropImage(frames: [CGRect]) {
        reset()
        baseView = UIView(frame: imageView.frame)
        baseView.backgroundColor = .white
        view.addSubview(baseView)
        frames.forEach { [weak self] (rect) in
            guard let self = self, let image = self.imageView.image,
                let cropImage = image.crop(rect: rect, imageViewSize: self.imageView.frame.size) else {
                    return
            }
            let cropImageView = UIImageView(image: cropImage)
            cropImageView.frame = rect
            cropImageView.contentMode = .scaleAspectFill
            baseView.addSubview(cropImageView)
        }
    }

    private func reset() {
        guard let baseView = baseView else { return }
        baseView.removeFromSuperview()
    }
}

extension UIImage {
    func crop(rect: CGRect, imageViewSize: CGSize) -> UIImage? {
        let imageViewScale = max(imageViewSize.width / self.size.width,
                                 imageViewSize.height / self.size.height)
        let cropSize = CGSize(width: rect.size.width / imageViewScale,
                              height: rect.size.height / imageViewScale)
        let cropOrigin = CGPoint(x: -rect.origin.x / imageViewScale,
                                 y: -rect.origin.y / imageViewScale)
        UIGraphicsBeginImageContextWithOptions(cropSize, true, 0.0)
        self.draw(at: cropOrigin)
        let cropImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return cropImage
    }
}


