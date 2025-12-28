//
//  SelectableItemView.swift
//  DanaBantuan
//
//  Created by hekang on 2025/12/28.
//

import UIKit
import SnapKit

class SelectableItemView: UIControl {

    private let bgImageView = UIImageView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()

    private var normalBgImage: UIImage?
    private var selectedBgImage: UIImage?
    private var normalLogoImage: UIImage?
    private var selectedLogoImage: UIImage?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(bgImageView)
        addSubview(logoImageView)
        addSubview(titleLabel)

        bgImageView.contentMode = .scaleToFill
        logoImageView.contentMode = .scaleAspectFit

        titleLabel.font = .systemFont(ofSize: 14, weight: .medium)

        bgImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        logoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15.pix())
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 26.pix(), height: 26.pix()))
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(logoImageView.snp.right).offset(15.pix())
            make.centerY.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-12)
        }

        layer.cornerRadius = 8
        layer.masksToBounds = true
    }

    func configure(
        title: String,
        normalBg: UIImage,
        selectedBg: UIImage,
        normalLogo: UIImage,
        selectedLogo: UIImage
    ) {
        titleLabel.text = title
        normalBgImage = normalBg
        selectedBgImage = selectedBg
        normalLogoImage = normalLogo
        selectedLogoImage = selectedLogo
        updateUI()
    }

    override var isSelected: Bool {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        bgImageView.image = isSelected ? selectedBgImage : normalBgImage
        logoImageView.image = isSelected ? selectedLogoImage : normalLogoImage
        titleLabel.textColor = isSelected
            ? UIColor(hex: "#1CC7EF")
            : UIColor(hex: "#759199")
    }
}
