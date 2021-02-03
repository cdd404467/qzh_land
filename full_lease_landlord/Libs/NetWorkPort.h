//
//  NetWorkPort.h
//  full_lease_landlord
//
//  Created by apple on 2020/8/26.
//  Copyright © 2020 apple. All rights reserved.
//

#ifndef NetWorkPort_h
#define NetWorkPort_h

//#import "DevelopTool.h"
#import "full_lease_landlord-Swift.h"

//#define _PRODUCTION_NETWORK
////#define _TEST_1_NETWORK
////#define _TEST_2_NETWORK
//
//#ifdef _PRODUCTION_NETWORK
//#define Server_Api(urlstring) [DevelopTool selectProductServerApi:urlstring]
//#else
//#ifdef _TEST_1_NETWORK
////#define Server_Api(urlstring) @"http://Site.girders.cn/"
//#define Server_Api(urlstring) @"http://101.132.154.194/"
//#else
//#define Server_Api(urlstring) @"https://sit.girders.cn/"
//#endif
//#endif

#define Server_Api(urlstring) [NetMacro getServerApiWithUrl:urlstring]

#pragma mark - 登陆流程
//验证码
#define URLPost_SMS_Code @"member/userInfo/SendSMS"
//登陆
#define URLPost_user_Login @"member/userInfo/login"
//除登陆外的短信验证码
#define URLPost_OtherSMS_Code @"member/Note/sendNote"
//除登陆外的短信验证码校验
#define URLPost_OtherSMS_Check @"member/Note/verifyNote"


#pragma mark - 其他
//获取首页banner
#define URLGet_Banner_List @"landlord/banner/getBannerList"
//消息列表接口、累计收益接口和待签约条数接口整合
#define URLGet_MinePage_Info @"landlord/homePage/getHomeData"

//版本更新
#define URLPost_Check_Version @"house/config/getCurrentAppVersion"

#pragma mark - 我的租约
//我的租约（合同）
#define URLPost_Con_List @"landlord/landlordcont/getTonercontractList"
//租约详情
#define URLGet_Con_Detail @"landlord/landlordcont/getTonercontract/%@"
//下载合同
#define URLPost_Con_Download @"contract/contract/GetJzqDownContract"

#pragma mark - 租客合同
//租客合同
#define URLPost_ZuKeCon_List @"landlord/landlordcont/getContractList"
//租客合同详情
#define URLGet_ZuKeCon_Detail @"landlord/landlordcont/getContract/%@"


#pragma mark - 在线签约
//房东同意或者拒绝
#define URLPost_Land_AgreeOrRefuse @"landlord/landlordcont/updateContract"
//调用电子签约
#define URLPost_Sign_Online @"landlord/landlordcont/applySign"
//在线签约--更新租金价格
#define URLPost_ChangeMoney_SignOnline @"contract/bill/convertRequestToNet/updateHousePriceChangeContract"
//预览租客合同
#define URLPost_Preview_Con @"contract/contract/morenQuery"
//获取签约状态
#define URLPost_Sign_State @"contract/contract/GetBothSignStatus"

#pragma mark - 房源
//房源列表
//#define URLGet_HouseResource_List @"landlord/landlordcont/getHouseList/%@"
#define URLPost_HouseResource_List @"landlord/landlordcont/getHouseListByphone"
//房源详情
#define URLGet_HouseResource_Detail @"house/houseInfo/selectTHouresourcesDTOBYId/%@"
//房源详情--更新租金价格
#define URLPost_ChangeMoney_HRD @"house/houseInfo/updateTHouresourcesDTOBYId"


#pragma mark - 我的账单
//我的账单列表
#define URLPost_My_Bill @"contract/bill/getLandlordBillList"
//我的账单详情
#define URLGet_MyBill_Detail @"contract/bill/getBillDetailgetBillDetail/%@"


#pragma mark - 支付
//获取支付方式
#define URLPost_Pay_RateSet @"contract/bill/convertRequestToNet/getPayRateSet"
//在线支付下单
#define URLPost_Pay_Online @"contract/bill/convertRequestToNet/onlinePay"
//检查支付状态
#define URLGet_Check_PayState @"contract/bill/convertRequestToNet/queryOrderStatus/%@"


#pragma mark - 租客账单
//租客账单列表
#define URLPost_Lease_Bill @"contract/bill/listTenantForLandlord"
//租客账单详情
#define URLGet_LeaseBill_Detail @"contract/bill/getBillTenantsDetails/%@"


#pragma mark - 消息
//获取未读消息
#define URLGet_UnRead_Message @"member/message/getMsgListTotalVo/%@"
//获取消息列表
#define URLPost_Message_List @"member/message/listMsgDetails"


#pragma mark - 收入明细
//收入明细列表
#define URLPost_Income_List @"member/bank/financeFinal"
//收入详情
#define URLPost_Income_Detail @"member/bank/leaseDetails"

#pragma mark - 银行卡
//个人银行卡列表
#define URLPost_MyBankCard_List @"member/bank/selectBankCard"
//查询开户银行列表
#define URLPost_Check_BankList @"member/bank/getAllBankList"
//根据银行卡号查询银行名称
#define URLPost_GetBankName @"member/bank/getBankInformation"
//添加银行卡
#define URLPost_Add_BankCard @"member/bank/insertBankCard"

#pragma mark - 钱包
//钱包余额
#define URLPost_Wallet_Amount @"member/bank/walletamount"
//钱包收入列表
#define URLPost_Wallet_Income @"member/bank/incomelist"
//钱包支出列表
#define URLPost_Wallet_Spend @"member/bank/withdrawallist"

#pragma mark - 密码相关
//是否设置密码
#define URLGet_IsSet_Password @"member/userInfo/getPayPassword"
//设置支付密码
#define URLPost_Set_Password @"member/userInfo/setPayPassword"
//验证支付密码是否正确
#define URLPost_Chect_Password @"member/userInfo/validationPayPassword"
//修改支付密码
#define URLPost_Change_Password @"member/userInfo/paymentCode"
//验证银行卡号
#define URLPost_Check_Bankcard @"member/bank/judgeBankCardAndBanks"

#pragma mark - 提现
//系统配置项
#define URLPost_Tixian_SystemSet @"contract/bill/convertRequestToNet/owernconfiguration"
//提现
#define URLPost_withdraw @"member/bank/withdrawDeposit"

#pragma mark - 查询信息和提供服务
//在线委托
#define URLPost_Online_Entrust @"landlord/entrust/insertEntrust"
//查询业主信息
#define URLGet_Check_LandInfo @"landlord/towerntenant/getTowerntenantInfo/%@"
//查询租客信息
#define URLGet_Check_LeaseInfo @"contract/tenant/getTenant/%@"
//根据租客/业主合同编号查询管家信息
#define URLGet_Check_ManagerInfo @"member/sysuser/getSysuserKeeper/%@"
//空置赔偿金
#define URLPost_Empty_Compensate @"landlord/landlordcont/GetSystemPayOrder"


#pragma mark - 智能门锁
//设置锁的手势 以及校验手势接口
#define URLPost_Set_ChectPass @"member/smartDevices/setElectronicLock"
//根据房东端token，获取独立App的用户信息以及token
#define URLGet_landlady_Login @"member/smartDevices/landladyLogin"
//系统配置
#define URLPost_System_Setting @"contract/bill/convertRequestToNet/configurationnet"


#endif /* NetWorkPort_h */
