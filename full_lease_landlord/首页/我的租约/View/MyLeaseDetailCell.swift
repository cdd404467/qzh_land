//
//  MyLeaseDetailCell.swift
//  full_lease_landlord
//
//  Created by apple on 2021/3/23.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class MyLeaseDetailCell: UITableViewCell {
    @objc var leftLab: UILabel!
    @objc var subLab: UILabel?
    @objc var rightLab: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        leftLab = UILabel()
        leftLab.textColor = HexColor("#1C1C1C", 1)
        leftLab.font = KFont(14)
        self.contentView.addSubview(leftLab)
        leftLab.snp.makeConstraints({ (make) in
            make.left.equalTo(16)
            make.centerY.equalTo(self.contentView)
        })
        leftLab.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        subLab = UILabel()
        subLab?.isHidden = true
        subLab?.textColor = HexColor("#1C1C1C", 1)
        subLab?.font = KFont(11)
        self.contentView.addSubview(subLab!)
        subLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(leftLab.snp.right)
            make.centerY.equalTo(self.contentView)
        })
        subLab?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        rightLab = UILabel()
        rightLab?.textColor = HexColor("#888888", 1)
        rightLab?.font = KFont(14)
        rightLab?.textAlignment = .right
        self.contentView.addSubview(rightLab!)
        rightLab?.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.left.equalTo(subLab!.snp.right)
            make.centerY.equalTo(self.contentView)
        })
        rightLab?.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
}
