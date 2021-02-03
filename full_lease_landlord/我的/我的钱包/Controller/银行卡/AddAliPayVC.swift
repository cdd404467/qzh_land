//
//  AddAliPayVC.swift
//  full_lease_landlord
//
//  Created by apple on 2021/2/1.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class AddAliPayVC: BaseViewController {

    var nameTF: UITextField!
    var accountTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "添加支付宝"
        view.backgroundColor = HexColor("#FAFAFA", 1)
        setupUI()
            
    }
    
    func setupUI() {
        let nameLab = UILabel.init()
        nameLab.text = "账户名"
        nameLab.textColor = HexColor("#333333", 1)
        nameLab.font = .systemFont(ofSize: 14)
        nameLab.setContentHuggingPriority(.init(rawValue: 1000), for: .horizontal)
        view.addSubview(nameLab)
        nameLab.snp.makeConstraints { make in
            make.left.equalTo(26)
            make.top.equalTo(NAV_HEIGHT + 30)
            make.height.equalTo(20)
        }
        
        nameTF = UITextField.init()
        nameTF.placeholder = "请输入支付宝账户实名认证的姓名"
        nameTF.font = .systemFont(ofSize: 13)
        view.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab.snp.right).offset(25)
            make.height.equalTo(50)
            make.centerY.equalTo(nameLab)
            make.right.equalTo(-26)
        }
        
        let line1 = UIView.init()
        line1.backgroundColor = HexColor("#EEEEEE", 1)
        view.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.right.equalTo(nameTF)
            make.height.equalTo(0.5)
            make.top.equalTo(nameTF.snp.bottom)
        }
        
        let accountLab = UILabel.init()
        accountLab.text = "账号"
        accountLab.textColor = HexColor("#333333", 1)
        accountLab.font = .systemFont(ofSize: 14)
        accountLab.setContentHuggingPriority(.init(rawValue: 1000), for: .horizontal)
        view.addSubview(accountLab)
        accountLab.snp.makeConstraints { make in
            make.left.equalTo(26)
            make.top.equalTo(line1.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        
        accountTF = UITextField.init()
        accountTF.placeholder = "请输入支付宝账户/手机号"
        accountTF.font = .systemFont(ofSize: 13)
        view.addSubview(accountTF)
        accountTF.snp.makeConstraints { (make) in
            make.left.right.equalTo(nameTF)
            make.height.equalTo(50)
            make.centerY.equalTo(accountLab)
        }
        
        let line2 = UIView.init()
        line2.backgroundColor = HexColor("#EEEEEE", 1)
        view.addSubview(line2)
        line2.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(line1)
            make.top.equalTo(accountTF.snp.bottom)
        }
        
        let addBtn = UIButton.init(type: .custom)
        addBtn.backgroundColor = MainColor
        addBtn.setTitle("添加支付宝", for: .normal)
        addBtn.setTitleColor(UIColor.white, for: .normal)
        addBtn.titleLabel?.font = .systemFont(ofSize: 18)
        addBtn.addTarget(self, action: #selector(addAlipay), for: .touchUpInside)
        addBtn.layer.cornerRadius = 4
        view.addSubview(addBtn)
        addBtn.snp.makeConstraints { (make) in
            make.top.equalTo(line2.snp.bottom).offset(146)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(49)
        }
        
    }
    
    @objc func addAlipay() {
        if nameTF.text?.count == 0 {
            CddHud.showTextOnly("请输入支付宝实名认证名字", view: view)
            return
        } else if accountTF.text?.count == 0 {
            CddHud.showTextOnly("请输入支付宝账号", view: view)
            return
        }
        
        let dict:[String: Any] = ["createperson":nameTF.text ?? "",
                                  "account":accountTF.text ?? "",
                                  "userid":User_Id
        ]
        
        NetReq.request(url: "member/bank/insertZfb", parameters: dict).success {(json) in
            print(json)
            if json["code"].intValue == 200 {
                CddHud.showTextOnly("添加成功", view: self.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    NotificationCenter.default.post(name: .init(NotificationName_AddBankCardSuccess), object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
