//
//  DecorateContactOnline.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/7.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class DecorateContactOnline: BaseViewController {
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT))
        sv.bounces = false
        sv.contentSize = CGSize.init(width: sv.width, height: sv.height)
        return sv
    }()
    var phoneTF: UITextField!
    var codeBtn : UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "在线联系";
        setupUI()
    }
    

    func setupUI() {
        view.addSubview(scrollView)
        let titleArr = ["姓名","联系电话","验证码"]
        for i in 0..<titleArr.count {
            let lab = UILabel.init(frame: CGRect.init(x: 16, y: 35 + (38 + 20) * i, width: 100, height: 20))
            lab.textColor = HexColor("#333333", 1)
            lab.text = titleArr[i]
            lab.font = KFont(14)
            scrollView.addSubview(lab)
            
            let line = UIView.init(frame: CGRect.init(x: 16, y: lab.bottom + 19, width: SCREEN_WIDTH - 32, height: 0.2))
            line.backgroundColor = HexColor("#eeeeee", 1)
            scrollView.addSubview(line)
        }
        
        let nameTF = UITextField.init()
        nameTF.font = KFont(14)
        nameTF.textAlignment = .right
        nameTF.placeholder = "请输入您的姓名"
        scrollView.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(130);
            make.right.equalTo(view.snp.right).offset(-16);
            make.height.equalTo(20);
            make.top.equalTo(35);
        }
        
        phoneTF = UITextField.init()
        phoneTF.font = KFont(14)
        phoneTF.maxLength = 11
        phoneTF.textAlignment = .right
        phoneTF.placeholder = "请输入您的联系电话"
        phoneTF.keyboardType = .numberPad
        scrollView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { (make) in
            make.left.right.height.equalTo(nameTF);
            make.top.equalTo(nameTF.snp.bottom).offset(38);
        }
        
        
        codeBtn = UIButton.init(type: .custom)
        codeBtn.backgroundColor = MainColor
        codeBtn.setTitle("发送验证码", for: .normal)
        codeBtn.setTitleColor(.white, for: .normal)
        codeBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        codeBtn.layer.cornerRadius = 2
        codeBtn.addTarget(self, action: #selector(getSMSCode), for: .touchUpInside)
        scrollView.addSubview(codeBtn)
        codeBtn.snp.makeConstraints { (make) in
            make.right.equalTo(phoneTF);
            make.width.equalTo(75);
            make.top.equalTo(phoneTF.snp.bottom).offset(34);
            make.height.equalTo(28);
        }
        
        let codeTF = UITextField.init()
        codeTF.font = KFont(14);
        codeTF.maxLength = 6;
        codeTF.textAlignment = .right;
        codeTF.placeholder = "请输入验证码";
        codeTF.keyboardType = .numberPad;
        scrollView.addSubview(codeTF)
        codeTF.snp.makeConstraints { (make) in
            make.left.equalTo(phoneTF);
            make.right.equalTo(codeBtn.snp.left).offset(-25);
            make.height.equalTo(20);
            make.centerY.equalTo(codeBtn);
        }
        
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.addTarget(self, action: #selector(checSMSkCodeAndSubmit), for: .touchUpInside)
        submitBtn.backgroundColor = MainColor;
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = KFont(18)
        submitBtn.layer.cornerRadius = 4
        scrollView.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-KFit_H(106) - Bottom_Height_Dif);
            make.left.equalTo(view.snp.left).offset(16);
            make.right.equalTo(view.snp.right).offset(-16);
            make.height.equalTo(49);
        }
    }

}

extension DecorateContactOnline {
    @objc func getSMSCode() {
        self.view.endEditing(true)
        if phoneTF.text?.count == 0 {
            CddHud.showTextOnly("请输入手机号", view: view)
            return;
        } else if phoneTF.text!.count < 11 {
            CddHud.showTextOnly("请输入正确的手机号", view: view)
            return;
        }
        
        let dict: [String: Any] = ["userPhone":phoneTF.text! as String,
                    "status":10,
                    "userType":1]
        
        NetReq.request(url: "member/Note/sendNote", parameters: dict).success {[weak self] json in
            if json["code"].intValue == 200 {
                self?.countDown()
            }
        }.failed {error in
            
        }
        
    }
    
    @objc func checSMSkCodeAndSubmit() {
        
    }
    
    
    func countDown() {
        let countDown: CountDown = CountDown.init()
        let aMinutes: TimeInterval = 60
        let finishDate: Date = Date.init(timeIntervalSinceNow: aMinutes)
        countDown.countDown(withStratDate: Date(), finish: finishDate) { [weak self] (day, hour, min, sec) in
            if sec == 0 {
                self?.codeBtn.isEnabled = true
                self?.codeBtn.setTitle("发送验证码", for: .normal)
            } else {
                self?.codeBtn.isEnabled = false
                self?.codeBtn.setTitle("\(sec)s", for: .normal)
            }
        }
    }
}
