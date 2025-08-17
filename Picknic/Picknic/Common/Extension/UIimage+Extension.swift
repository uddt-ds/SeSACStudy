//
//  UIimage+Extension.swift
//  Picknic
//
//  Created by Lee on 8/17/25.
//

import UIKit

extension UIImage {
    func resizeImage(size: CGSize) -> UIImage {
        let originalSize = self.size
        let ratio: CGFloat = {
            return originalSize.width > originalSize.height ?
            1 / (size.width / originalSize.width) : 1 / (size.height / originalSize.height)
        }()


        guard let cgImage = self.cgImage else { return .init() }
        return UIImage(cgImage: cgImage, scale: self.scale * ratio, orientation: self.imageOrientation)
    }
}
