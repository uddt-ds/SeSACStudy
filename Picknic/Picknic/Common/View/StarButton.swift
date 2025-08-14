//
//  StarButton.swift
//  Picknic
//
//  Created by Lee on 8/14/25.
//

import UIKit
import SnapKit

final class StarButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = Configuration.filled()
        let container = AttributeContainer([
            .foregroundColor : UIColor.white,
            .font : UIFont.systemFont(ofSize: 10)
        ])
        let attributedTitle = AttributedString("1000", attributes: container)
        configuration?.attributedTitle = attributedTitle
        configuration?.image = UIImage(systemName: "star.fill")
        configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 13)
        configuration?.baseBackgroundColor = .gray
        configuration?.baseForegroundColor = .yellow
        configuration?.imagePadding = 4
        configuration?.cornerStyle = .capsule

    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
