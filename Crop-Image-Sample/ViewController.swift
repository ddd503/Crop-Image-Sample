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
    private let humanFrame = [CGRect(x: 60, y: 5, width: 176, height: 184)]
    private let pizzaFrame = [CGRect(x: 15, y: 230, width: 264, height: 80),
                              CGRect(x: 120, y: 180, width: 180, height: 70)]
    private let alcoholFrame = [CGRect(x: 15, y: 10, width: 76, height: 280),
                                CGRect(x: 45, y: 110, width: 76, height: 132),
                                CGRect(x: 320, y: 80, width: 90, height: 190)]

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
        // 白背景のbaseViewを用意
        baseView = UIView(frame: imageView.frame)
        baseView.backgroundColor = .white
        view.addSubview(baseView)

        // baseView上に表示中の画像から指定箇所を切り取ってImageViewを作り乗せていく、最後にbaseViewを元画像の上から重ねる
        frames.forEach { [weak self] (rect) in
            guard let self = self, let image = self.imageView.image?.resize(self.imageView.frame.size),
                let cropImage = image.cropUseCgImage(rect: rect, imageViewSize: self.imageView.frame.size) else {
                    return
            }
            let cropImageView = UIImageView(image: cropImage)
            cropImageView.frame = rect
            cropImageView.layer.masksToBounds = true
            cropImageView.layer.cornerRadius = 10
            cropImageView.contentMode = .scaleAspectFit // 画像の比率は固定で
            baseView.addSubview(cropImageView)
        }
    }

    private func reset() {
        guard let baseView = baseView else { return }
        baseView.removeFromSuperview()
    }
}

// 切り取りの方法は２つ用意（どちらも同様の結果）
extension UIImage {
    func cropUseUIGraphics(rect: CGRect, imageViewSize: CGSize) -> UIImage? {
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

    func cropUseCgImage(rect: CGRect, imageViewSize: CGSize) -> UIImage? {
        let imageViewScale = max(self.size.width * self.scale / imageViewSize.width,
                                 self.size.height * self.scale / imageViewSize.height)
        let cropZone = CGRect(x: rect.origin.x * imageViewScale,
                              y: rect.origin.y * imageViewScale,
                              width: rect.size.width * imageViewScale,
                              height: rect.size.height * imageViewScale)
        guard let cgImage = self.cgImage, let cropImage = cgImage.cropping(to: cropZone) else {
            return nil
        }
        return UIImage(cgImage: cropImage, scale: self.scale, orientation: self.imageOrientation)
    }

    // 指定したsizeにリサイズする
    func resize(_ size: CGSize) -> UIImage? {
        let widthRatio = size.width / self.size.width
        let heightRatio = size.height / self.size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let resizedSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)

        UIGraphicsBeginImageContextWithOptions(resizedSize, true, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}
