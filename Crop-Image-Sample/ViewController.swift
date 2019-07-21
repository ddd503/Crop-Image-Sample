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
    private let humanFrame = [CGRect(x: 50, y: 156, width: 176, height: 184)]
    private let pizzaFrame = [CGRect(x: 0, y: 250, width: 264, height: 93)]
    private let alcoholFrame = [CGRect(x: 0, y: 199, width: 76, height: 223),
                                CGRect(x: 45, y: 260, width: 76, height: 132),
                                CGRect(x: 289, y: 216, width: 114, height: 198)]

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func tapPizza(_ sender: UIButton) {
        baseView = UIView(frame: imageView.frame)
        baseView.backgroundColor = .white
        view.addSubview(baseView)
        let all = CGRect(x: 0,
                         y: 0,
                         width: imageView.frame.size.width,
                         height: imageView.frame.size.height)
        print("all crop frame: \(all)")
        pizzaFrame.forEach { [weak self] (rect) in
            guard let self = self, let image = self.imageView.image,
                let cropImage = image.crop(rect: rect, displayView: self.imageView) else {
                    return
            }
            let imageView = UIImageView(image: cropImage)
            imageView.frame = rect
            imageView.contentMode = .scaleToFill
            baseView.addSubview(imageView)
        }
    }

    @IBAction func tapHuman(_ sender: UIButton) {
    }

    @IBAction func tapAlcohol(_ sender: UIButton) {
    }

    @IBAction func tapReset(_ sender: UIButton) {
        guard let baseView = baseView else { return }
        baseView.removeFromSuperview()
    }

}

extension UIImage {
    func crop(rect: CGRect, displayView: UIImageView) -> UIImage? {
        let imageViewScale = max(self.size.width * self.scale / displayView.frame.size.width,
                                 self.size.height * self.scale / displayView.frame.size.height)
        let cropZone = CGRect(x: rect.origin.x * imageViewScale,
                              y: rect.origin.y * imageViewScale,
                              width: rect.size.width * imageViewScale,
                              height: rect.size.height * imageViewScale)
        guard let cgImage = self.cgImage, let cropImage = cgImage.cropping(to: cropZone) else {
            return nil
        }
        return UIImage(cgImage: cropImage, scale: self.scale, orientation: self.imageOrientation)
    }
}


