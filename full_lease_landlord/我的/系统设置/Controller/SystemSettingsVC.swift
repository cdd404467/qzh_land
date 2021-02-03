//
//  SystemSettingsVC.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/6.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import SDWebImage

class SystemSettingsVC: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    let titleArray: [Array<String>] = [["清除缓存","隐私协议"]]
    private lazy var tableView: UITableView = {
        var table = UITableView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT), style: .grouped)
        table.delegate = self
        table.dataSource = self
        table.separatorColor = HexColor("#eeeeee", 1)
        table.backgroundColor = .white
        table.separatorInset = UIEdgeInsets.init(top: 0, left: KFit_W(16), bottom: 0, right: 0)
        if #available(iOS 11, *) {
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
            table.contentInsetAdjustmentBehavior = .never
        }
        
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navTitle = "系统设置"
        view.addSubview(tableView)
        if isUserLogin == true {
            setupUI()
        }
    }
    
    func setupUI() {
        let exitLoginBtn = UIButton.init(type: .custom);
        exitLoginBtn.layer.cornerRadius = 4
        exitLoginBtn.setTitle("退出登录", for: .normal)
        exitLoginBtn.titleLabel?.font = KFont(18)
        exitLoginBtn.setTitleColor(.white, for: .normal)
        exitLoginBtn.backgroundColor = MainColor
        exitLoginBtn.addTarget(self, action: #selector(exitLogin), for: .touchUpInside)
        view.addSubview(exitLoginBtn)
        exitLoginBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(-(TABBAR_HEIGHT + KFit_W(57)))
            make.left.equalTo(KFit_W(16))
            make.right.equalTo(KFit_W(-16))
            make.height.equalTo(49)
        }
    }
   
    
    @objc func exitLogin() {
        let sheetView = CddActionSheetView.init(sheetOKTitle: "退出登录", cancelTitle: "取消") {
            [weak self] in
            if isUserLogin {
                UserDefaults.standard.removeObject(forKey: "userInfo")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationName_UserExitLogin"), object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
        sheetView.title = "确定要退出登录吗?"
        sheetView.show()
    }
    
    func clearCache() {
        AlertSystem.alertTwo("是否确定清除缓存?", msg: nil, cancelBtn: "取消", okBtn: "确定") {
            SDWebImageManager.shared.imageCache.clear(with: .disk) {
                [weak self] in
                CddHud.showTextOnly("清理成功", view: self?.view)
            }
        }
    }
}

extension SystemSettingsVC {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        titleArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        KFit_W(57)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                clearCache()
            } else if indexPath.row == 1 {
                let vc = PrivacyAgreementVC.init()
                navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier)
        
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: identifier)
        }
        cell?.textLabel?.font = .systemFont(ofSize: 15)
        cell?.textLabel?.text = titleArray[indexPath.section][indexPath.row]
        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.textColor = HexColor("#333333", 1)
        
        return cell ?? UITableViewCell()
    }
    
    
}
