//
//  NetTool.swift
//  full_lease_landlord
//
//  Created by apple on 2020/12/28.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation


public typealias SuccessHandler = (_ json: JSON) -> Void
public typealias FailedHandler = (_ error: Error) -> Void
public typealias ProgressHandler = (Progress) -> Void
let NetReq = NetTool.shared
let NetChain = NetChained.shared

public class NetWorkRequest {
    var request: Alamofire.Request?
    private var successHandler: SuccessHandler?
    private var failedHandler: FailedHandler?
    private var progressHandler: ProgressHandler?
    
    func handleResponse(response: AFDataResponse<Any>) {
        switch response.result {
        case .success(let jsonData):
            let json: JSON = JSON.init(jsonData)
            if let closure = successHandler {
                if json["code"].intValue != 200 {
                    print(json)
                    showErrorMsg(msg: json["message"].stringValue)
                }
                closure(json)
            }
        case .failure(let error):
            if let closure = failedHandler {
                print(error)
                closure(error)
                self.dealWithError(task: response, error: error)
            }
        }
        clearReference()
    }
    
    func handleProgress(progress: Foundation.Progress) {
        if let closure = progressHandler {
            closure(progress)
        }
    }
    
    @discardableResult
    func success(_ closure: @escaping SuccessHandler) -> Self {
        successHandler = closure
        return self
    }
    
    @discardableResult
    func failed(_ closure: @escaping FailedHandler) -> Self {
        failedHandler = closure
        return self
    }
    
    @discardableResult
    func progress(closure: @escaping ProgressHandler) -> Self {
        progressHandler = closure
        return self
    }
    
    func cancel() {
        request?.cancel()
    }
    
    func clearReference() {
        successHandler = nil
        failedHandler = nil
        progressHandler = nil
    }
    
    func showErrorMsg(msg: String) {
        CddHud.hide(nil)
        CddHud.hide(Help.currentVC()?.view)
        CddHud.showTextOnly(msg, view: nil)
    }
    
    func dealWithError(task: AFDataResponse<Any>, error: Error) {
        if task.response?.statusCode == 401 {
            UserDefaults.standard.removeObject(forKey: "userInfo")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationName_UserExitLogin"), object: nil)
            let baseVC: BaseViewController = Help.currentVC() as! BaseViewController
            if !baseVC.isKind(of: BaseViewController.self) {
                baseVC.jumpToLogin(complete: nil)
            }
        } else {
            self.showErrorMsg(msg: error.localizedDescription)
        }
    }
}

public class NetTool {
    public static let shared = NetTool()
    var sessionManager: Alamofire.Session!
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20  // Timeout interval
        config.timeoutIntervalForResource = 20  // Timeout interval
        sessionManager = Alamofire.Session(configuration: config)
    }
}

extension NetTool {
    func request(url:String, requestType:HTTPMethod = .post, parameters:[String: Any]? = nil, headers:[String: String]? = ["Authorization":User_Token], encoding: ParameterEncoding = JSONEncoding.default) -> NetWorkRequest {
        let urlString: String = NetMacro.getServerApi(url: url)
        let task = NetWorkRequest()
        var header: HTTPHeaders?
        if let tempHeaders = headers {
            header = HTTPHeaders(tempHeaders)
        }
        task.request = sessionManager.request(urlString, method: requestType, parameters: parameters ,encoding: encoding, headers: header).validate().responseJSON {response in
            task.handleResponse(response: response)
        }
        return task
    }
    
    func upload(url: String,
                       method: HTTPMethod = .post,
                       parameters: [String: String]?,
                       datas: [MultipartData],
                       headers: [String: String]? = nil) -> NetWorkRequest {
        let task = NetWorkRequest()

        var h: HTTPHeaders?
        if let tempHeaders = headers {
            h = HTTPHeaders(tempHeaders)
        }

        task.request = sessionManager.upload(multipartFormData: { (multipartData) in
            if let parameters = parameters {
                for p in parameters {
                    multipartData.append(p.value.data(using: .utf8)!, withName: p.key)
                }
            }
            for d in datas {
                multipartData.append(d.fileData, withName: d.name, fileName: d.fileName, mimeType: d.fileType)
            }
        }, to: url, method: method, headers: h).uploadProgress(queue: .main, closure: { (progress) in
            task.handleProgress(progress: progress)
        }).validate().responseJSON(completionHandler: {response in
            task.handleResponse(response: response)
        })
        return task
    }
}

// MARK: 链式参数请求
public class NetChained {
    public static let shared = NetChained()
    var sessionManager: Alamofire.Session!
    private var requestType: HTTPMethod = .post
    private var parameters: [String:Any]? = nil
    private var headers: [String:String]? = ["Authorization":User_Token]
    private var encoding: ParameterEncoding = JSONEncoding.default
    private init() {
        let config = URLSessionConfiguration.af.default
        config.timeoutIntervalForRequest = 20  // Timeout interval
        config.timeoutIntervalForResource = 20  // Timeout interval
        sessionManager = Alamofire.Session(configuration: config)
    }
    
    func request(url: String) -> NetWorkRequest {
        let urlString: String = NetMacro.getServerApi(url: url)
        var header: HTTPHeaders?
        let task = NetWorkRequest()
        if let tempHeaders = headers {
            header = HTTPHeaders(tempHeaders)
        }
        task.request = sessionManager.request(urlString, method: requestType, parameters: parameters ,encoding: encoding, headers: header).validate().responseJSON {response in
            task.handleResponse(response: response)
        }
        
        return task
    }
    
    @discardableResult
    func requestType(_ type: HTTPMethod) -> Self {
        self.requestType = type
        return self
    }
    
    @discardableResult
    func parameters(_ para: [String:Any]) -> Self {
        self.parameters = para
        return self
    }
    
    @discardableResult
    func headers(_ header: [String:String]) -> Self {
        self.headers = header
        return self
    }
    
    @discardableResult
    func encoding(_ encode: ParameterEncoding) -> Self {
        self.encoding = encode
        return self
    }
}

// 常见数据类型的`MIME Type`
public enum DataFileType: String {
    case JPEG = "image/jpeg"
    case PNG = "image/png"
    case GIF = "image/gif"
    case HEIC = "image/heic"
    case HEIF = "image/heif"
    case WEBP = "image/webp"
    case TIF = "image/tif"
    case JSON = "application/json"
}

public class MultipartData {
    let fileData: Data
    let name: String
    let fileName: String
    let fileType: String
    init(data: Data, name: String, fileName: String, fileType: String) {
        self.fileData = data
        self.name = name
        self.fileName = fileName
        self.fileType = fileType
    }
    
    convenience init(data: Data, name: String, fileName: String, type: DataFileType) {
        self.init(data: data, name: name, fileName: fileName, fileType: type.rawValue)
    }
}
