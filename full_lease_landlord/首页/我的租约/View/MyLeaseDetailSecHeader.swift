//
//  MyLeaseDetailSecHeader.swift
//  full_lease_landlord
//
//  Created by apple on 2021/3/23.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class MyLeaseDetailSecHeader: UITableViewHeaderFooterView {
    @objc var nameLab: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = HexColor("#f5f5f5", 0.5)
        setupUI()
    }
    
    private func setupUI() {
        nameLab = UILabel.init()
        nameLab.font = .boldSystemFont(ofSize: KFit_W(16))
        nameLab.textColor = HexColor("#262626", 1)
        self.contentView.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(KFit_W(16))
            make.height.equalTo(KFit_W(20))
        }
    }
}
