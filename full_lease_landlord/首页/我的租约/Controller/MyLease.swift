//
//  MyLease.swift
//  full_lease_landlord
//
//  Created by apple on 2021/1/12.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class MyLease: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    lazy var tableView: UITableView = {
        let table = UITableView.init(frame: CGRect.init(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT), style: .plain)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = HexColor("#f5f5f5", 1)
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: TABBAR_HEIGHT + 30 , right: 0)
        if #available(iOS 11, *) {
            table.estimatedSectionHeaderHeight = 0;
            table.estimatedSectionFooterHeight = 0;
            table.contentInsetAdjustmentBehavior = .never
        }
        return table
    }()
    
    lazy var dataSource: [ContractModel] = {
        var arr = Array<ContractModel>.init()
        return arr
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navTitle = "我的租约";
        view.addSubview(tableView)
        loadData()
    }
    

    func loadData() {
        let dict:[String: Any] = ["userPhone":User_Phone,"pageNumber":self.pageNumber]
        NetReq.request(url: "landlord/landlordcont/getTonercontractList", parameters: dict).success { json in
//            guard let list = [MyLeaMod].deserialize(from: json["data"]["dataList"].arrayObject) as? [MyLeaMod] else {return}
            
            guard let list = ContractModel.mj_objectArray(withKeyValuesArray: json["data"]["dataList"].arrayObject) as? [ContractModel] else {return}
        
            self.dataSource = list
            self.tableView.reloadData()
        }
    }

}

extension MyLease {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        KFit_W(124)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MyLeaseCell = tableView.cddDequeueReusableCell(cellType: MyLeaseCell.self)
        
        cell.addressLab?.text = self.dataSource[indexPath.row].adress
        return cell
    }
}
