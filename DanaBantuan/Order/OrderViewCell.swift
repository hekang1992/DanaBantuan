//
//  OrderViewCell.swift
//  DanaBantuan
//
//  Created by Thomas Brown on 2025/12/28.
//

import UIKit
import SnapKit
import Kingfisher

class OrderViewCell: UITableViewCell {
    
    var model: clearficModel? {
        didSet {
            guard let model = model else { return }
            let logoUrl = model.vituage ?? ""
            logoImageView.kf.setImage(with: URL(string: logoUrl))
            nameLabel.text = model.tic ?? ""
            descLabel.text = model.raphite ?? ""
            moneyLabel.text = model.situationsion ?? ""
            applyLabel.text = model.could?.placeuous ?? ""
            oneLabel.text = model.could?.relateform ?? ""
            twoLabel.text = model.could?.paintingsion ?? ""
            threeLabel.text = model.could?.agyrry ?? ""
            fourLabel.text = model.could?.scalactivityern ?? ""
            
            let octogenia = model.could?.octogenia ?? ""
            
            switch octogenia {
            case "optionain":
                applyView.backgroundColor = UIColor.init(hex: "#FFB843")
                break
            case "tachoenne":
                applyView.backgroundColor = UIColor.init(hex: "#EF5045")
                applyLabel.textColor = UIColor.init(hex: "#FFFFFF")
                break
            case "hippproof":
                applyView.backgroundColor = UIColor.init(hex: "#7EE706")
                applyLabel.textColor = UIColor.init(hex: "#FFFFFF")
                break
            case "tredecwise":
                applyView.backgroundColor = UIColor.init(hex: "#D2F4FC")
                applyLabel.textColor = UIColor.init(hex: "#1CC7EF")
                break
            case "gnar":
                applyView.backgroundColor = UIColor.init(hex: "#E4EAEB")
                applyLabel.textColor = UIColor.init(hex: "#759199")
                break
            default:
                applyView.backgroundColor = UIColor.init(hex: "#D2F4FC")
                applyLabel.textColor = UIColor.init(hex: "#1CC7EF")
                break
            }
            
        }
    }
    
    lazy var whiteView: UIView = {
        let whiteView = UIView()
        whiteView.backgroundColor = .white
        whiteView.layer.cornerRadius = 14.pix()
        whiteView.layer.masksToBounds = true
        return whiteView
    }()
    
    lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.layer.cornerRadius = 5
        logoImageView.layer.masksToBounds = true
        logoImageView.backgroundColor = .gray
        return logoImageView
    }()
    
    lazy var nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.textAlignment = .left
        nameLabel.textColor = UIColor.init(hex: "#0A1121")
        nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        return nameLabel
    }()
    
    lazy var descLabel: UILabel = {
        let descLabel = UILabel()
        descLabel.textAlignment = .left
        descLabel.textColor = UIColor.init(hex: "#759199")
        descLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return descLabel
    }()
    
    lazy var moneyLabel: UILabel = {
        let moneyLabel = UILabel()
        moneyLabel.textAlignment = .left
        moneyLabel.textColor = UIColor.init(hex: "#0A1121")
        moneyLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return moneyLabel
    }()
    
    lazy var applyView: UIView = {
        let applyView = UIView()
        applyView.layer.cornerRadius = 11.pix()
        applyView.layer.masksToBounds = true
        return applyView
    }()
    
    lazy var applyLabel: UILabel = {
        let applyLabel = UILabel()
        applyLabel.textAlignment = .center
        applyLabel.textColor = UIColor.init(hex: "#FFFFFF")
        applyLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return applyLabel
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = UIColor(hex: "#DBF1F9")
        lineView.layer.cornerRadius = 1
        lineView.layer.masksToBounds = true
        return lineView
    }()
    
    lazy var oneLabel: UILabel = {
        let oneLabel = UILabel()
        oneLabel.textAlignment = .left
        oneLabel.textColor = UIColor.init(hex: "#759199")
        oneLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return oneLabel
    }()
    
    lazy var twoLabel: UILabel = {
        let twoLabel = UILabel()
        twoLabel.textAlignment = .left
        twoLabel.textColor = UIColor.init(hex: "#0A1121")
        twoLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return twoLabel
    }()
    
    lazy var threeLabel: UILabel = {
        let threeLabel = UILabel()
        threeLabel.textAlignment = .left
        threeLabel.textColor = UIColor.init(hex: "#759199")
        threeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return threeLabel
    }()
    
    lazy var fourLabel: UILabel = {
        let fourLabel = UILabel()
        fourLabel.textAlignment = .left
        fourLabel.textColor = UIColor.init(hex: "#0A1121")
        fourLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return fourLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5.pix())
            make.size.equalTo(CGSize(width: 345.pix(), height: 125.pix()))
            make.bottom.equalToSuperview().offset(-10.pix())
        }
        
        whiteView.addSubview(logoImageView)
        logoImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(12.pix())
            make.width.height.equalTo(38.pix())
        }
        
        whiteView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11.pix())
            make.left.equalTo(logoImageView.snp.right).offset(10.pix())
            make.height.equalTo(16.pix())
        }
        
        whiteView.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5.pix())
            make.left.equalTo(logoImageView.snp.right).offset(10.pix())
            make.height.equalTo(16.pix())
        }
        
        whiteView.addSubview(moneyLabel)
        moneyLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(5.pix())
            make.left.equalTo(logoImageView.snp.right).offset(10.pix())
            make.height.equalTo(20.pix())
        }
        
        whiteView.addSubview(applyView)
        applyView.snp.makeConstraints { make in
            make.top.equalTo(moneyLabel.snp.bottom).offset(5.pix())
            make.left.equalTo(logoImageView)
            make.size.equalTo(CGSize(width: 140.pix(), height: 38.pix()))
        }
        
        applyView.addSubview(applyLabel)
        applyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        whiteView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().offset(15.pix())
            make.width.equalTo(1)
            make.left.equalToSuperview().offset(195.pix())
        }
        
        whiteView.addSubview(oneLabel)
        whiteView.addSubview(twoLabel)
        whiteView.addSubview(threeLabel)
        whiteView.addSubview(fourLabel)
        
        oneLabel.snp.makeConstraints { make in
            make.left.equalTo(lineView.snp.right).offset(20.pix())
            make.top.equalToSuperview().offset(14.pix())
            make.height.equalTo(16.pix())
        }
        
        twoLabel.snp.makeConstraints { make in
            make.left.equalTo(oneLabel)
            make.top.equalTo(oneLabel.snp.bottom).offset(7.pix())
            make.height.equalTo(16.pix())
        }
        
        threeLabel.snp.makeConstraints { make in
            make.left.equalTo(oneLabel)
            make.top.equalTo(twoLabel.snp.bottom).offset(14.pix())
            make.height.equalTo(16.pix())
        }
        
        fourLabel.snp.makeConstraints { make in
            make.left.equalTo(oneLabel)
            make.top.equalTo(threeLabel.snp.bottom).offset(7.pix())
            make.height.equalTo(16.pix())
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
