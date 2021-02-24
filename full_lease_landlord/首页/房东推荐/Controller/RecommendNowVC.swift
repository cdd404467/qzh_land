//
//  RecommendNowVC.swift
//  full_lease_landlord
//
//  Created by apple on 2021/2/19.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class RecommendNowVC: BaseViewController {

    private var nameTF: UITextField!
    private var phoneTF: UITextField!
    private var bakTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "立即推荐";
        setupUI()
    }
    

    func setupUI() {
        let imageView = UIImageView()
        imageView.frame = CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: KFit_W(182))
        imageView.image = UIImage.init(named: "recommend_bgview")
        view.addSubview(imageView)
        
        let bgView = UIView.init()
        bgView.backgroundColor = .white
        bgView.frame = CGRect(x: KFit_W(16), y: NAV_HEIGHT + KFit_W(116), width: SCREEN_WIDTH - KFit_W(16) * 2, height: KFit_W(340))
        view.addSubview(bgView)
        _ = bgView.shadowOpacity(0.7)?.shadowOffset(CGSize(width: 0, height: 3))?.shadowColor(HexColor("#D3D3D3", 1))?.conrnerRadius(3)?.shadowRadius(3)?.showVisual()
        
        let cat = UIImageView.init()
        cat.image = UIImage(named: "image_icon_cat")
        imageView.addSubview(cat)
        cat.snp.makeConstraints {
            $0.bottom.equalTo(bgView.snp.top)
            $0.right.equalTo(KFit_W(-42))
            $0.size.equalTo(CGSize(width: KFit_W(65), height: KFit_W(44)))
        }
        
        let nameLab = UILabel()
        nameLab.text = "姓名"
        nameLab.font = KFont(15)
        nameLab.textColor = HexColor("#333333", 1)
        bgView.addSubview(nameLab)
        nameLab.snp.makeConstraints { (make) in
            make.left.equalTo(KFit_W(20))
            make.top.equalTo(KFit_W(37))
            make.height.equalTo(KFit_W(30))
        }
        nameLab.setContentHuggingPriority(.required, for: .horizontal)
        
        nameTF = UITextField()
        nameTF.placeholder = "请输入您的姓名"
        nameTF?.font = KFont(14)
        nameTF.textAlignment = .right
        bgView.addSubview(nameTF)
        nameTF.snp.makeConstraints({
            $0.left.equalTo(nameLab.snp.right).offset(20)
            $0.right.equalTo(KFit_W(-20))
            $0.centerY.height.equalTo(nameLab)
        })
        
        let line_1 = UIView()
        line_1.backgroundColor = HexColor("#EEEEEE", 1)
        bgView.addSubview(line_1)
        line_1.snp.makeConstraints { (make) in
            make.top.equalTo(nameLab.snp.bottom).offset(KFit_W(13))
            make.height.equalTo(0.5)
            make.left.equalTo(nameLab)
            make.right.equalTo(nameTF)
        }
        
        let phoneLab = UILabel()
        phoneLab.text = "联系电话"
        phoneLab.font = KFont(15)
        phoneLab.textColor = HexColor("#333333", 1)
        bgView.addSubview(phoneLab)
        phoneLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(line_1.snp.bottom).offset(KFit_W(12))
            make.height.equalTo(KFit_W(30))
        }
        phoneLab.setContentHuggingPriority(.required, for: .horizontal)
        
        phoneTF = UITextField()
        phoneTF.placeholder = "请输入您的联系电话"
        phoneTF.keyboardType = .numberPad
        phoneTF?.font = KFont(14)
        phoneTF.maxLength = 11
        phoneTF.textAlignment = .right
        bgView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints({
            $0.left.equalTo(phoneLab.snp.right).offset(20)
            $0.right.equalTo(KFit_W(-20))
            $0.centerY.height.equalTo(phoneLab)
        })
        
        let line_2 = UIView()
        line_2.backgroundColor = HexColor("#EEEEEE", 1)
        bgView.addSubview(line_2)
        line_2.snp.makeConstraints { (make) in
            make.top.equalTo(phoneLab.snp.bottom).offset(KFit_W(13))
            make.height.equalTo(0.5)
            make.left.equalTo(phoneLab)
            make.right.equalTo(phoneTF)
        }
        
        let bakLab = UILabel()
        bakLab.text = "备注"
        bakLab.font = KFont(15)
        bakLab.textColor = HexColor("#333333", 1)
        bgView.addSubview(bakLab)
        bakLab.snp.makeConstraints { (make) in
            make.left.equalTo(nameLab)
            make.top.equalTo(line_2.snp.bottom).offset(KFit_W(12))
            make.height.equalTo(KFit_W(30))
        }
        
        bakTextView = UITextView.init()
        _ = bakTextView.borderColor(HexColor("#EEEEEE", 1))?.borderWidth(0.5)?.showVisual()
        bgView.addSubview(bakTextView)
        bakTextView.snp.makeConstraints { (make) in
            make.left.equalTo(bakLab)
            make.right.equalTo(line_2)
            make.height.equalTo(KFit_W(100))
            make.top.equalTo(bakLab.snp.bottom).offset(6)
        }
        
        let submitBtn = UIButton.init(type: .custom)
        submitBtn.addTarget(self, action: #selector(submit), for: .touchUpInside)
        submitBtn.backgroundColor = HexColor("#CF0019", 1);
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.titleLabel?.font = KFont(18)
        submitBtn.layer.cornerRadius = 4
        view.addSubview(submitBtn)
        submitBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-KFit_H(106) - Bottom_Height_Dif);
            make.left.equalTo(view.snp.left).offset(16);
            make.right.equalTo(view.snp.right).offset(-16);
            make.height.equalTo(49);
        }
    }

    @objc private func submit() {
        view.endEditing(true)
        if nameTF.text?.count == 0 {
            CddHud.showTextOnly("请输入姓名", view: view)
            return;
        } else if phoneTF.text?.count == 0 {
            CddHud.showTextOnly("请输入联系电话", view: view)
            return;
        } else if phoneTF.text!.count < 11 {
            CddHud.showTextOnly("请输入正确的手机号", view: view)
            return;
        }
        
        var dict: [String: Any] = [
            "name":nameTF.text! as String,
            "phone":phoneTF.text! as String,
            "usertype":1,
            "currentUserId":User_Id,
        ]
        if bakTextView.text.count > 0 {
            dict["postscript"] = bakTextView.text
        }
    
        CddHud.show(view)
        NetChain.parameters(dict).request(url: "landlord/referrer/insertReferrer").success {[weak self] json in
            CddHud.hide(self?.view)
            if json["code"].intValue == 200 {
                CddHud.showTextOnly("提交成功", view: self?.view)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.navigationController?.popViewController(animated: true)
                }
            } 
        }
    }
}
