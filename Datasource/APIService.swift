//
//  APIService.swift
//  Makent
//
//  Created on 5/30/17.
//  Copyright © 2017. All rights reserved.
//

import UIKit
import AFNetworking

class ServerAPI: NSObject {
    
    static let sharedInstance: ServerAPI = {
        let instance = ServerAPI()
        return instance
    }()
    
    func makeCall(requestMethod : String = "GET", apiName : String,params: NSMutableDictionary, isTokenRequired: Bool = true, forSuccessionBlock successBlock: @escaping (_ newResponse: Any?,_ error: String?) -> Void, andFailureBlock failureBlock: @escaping (_ error: Error) -> Void) {
        
        let manager = AFHTTPSessionManager()
        if(isTokenRequired){
            if KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken) != nil{
                let authToken = KeychainWrapper.standard.string(forKey:keyChainKey.authenticationToken)
                params.setValue(authToken, forKey: "token")
//                let token = "Bearer " + authToken!
//                manager.requestSerializer.setValue(token, forHTTPHeaderField: "Authorization")
            }
            //Here get token
        }
        
        manager.responseSerializer.acceptableContentTypes = ["text/html","application/json"]
        
        if(requestMethod == "GET"){
            if params.value(forKey: GetKey.getType) != nil{
                if (params.value(forKey: GetKey.getType) as! String) == GetKey.location{
                    let url = NSURL(string:"http://www.geoplugin.net/php.gp")
                    let req = NSMutableURLRequest(url: url! as URL)
                    req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
                    let task = URLSession.shared.dataTask(with: req as URLRequest){
                        data,res,err in
                        if(err != nil) {
                            successBlock(nil,error)
                            return
                        }else if(data != nil){
                            successBlock(data,nil)
                        }

                    }
                    task.resume()
                }else if(params.value(forKey: GetKey.getType) as! String) == GetKey.instagram{
                    let token:String = params.value(forKey: "token") as! String
                    let url = "https://api.instagram.com/v1/users/self/?access_token="+token
                    manager.get(url, parameters: nil, progress: { (progress) in
                        print("In process")
                    }, success: { (task, response) in
                        if let result = response as? NSDictionary {
                                successBlock(result, nil)
                        }
                    }) { (task, error) in
                        print(error)
                        showToastMessage(serverError, isSuccess: false)
                        failureBlock(error)
                    }

                }
            }else{
                var apiUrl = ArhebCreateUrl.generateGetUrl(apiName: apiName, params: params)
                apiUrl = apiUrl.replacingOccurrences(of: " ", with: "%20")
                manager.get(apiUrl, parameters: nil, progress: { (progress) in
                    print("In process")
                }, success: { (task, response) in
                    if let result = response as? NSDictionary {
                        let generalModel = GeneralModel().addResponseToModel(res: result)
                        if generalModel.status_code == "1" {
                            successBlock(response, nil)
                        } else if generalModel.status_code == "0" {
                            //                        showToastMessage(generalModel.success_message, isSuccess: false)
                            successBlock(nil, generalModel.success_message)
                        }
                    }
                }) { (task, error) in
                    print(error)
                    showToastMessage(serverError, isSuccess: false)
                    failureBlock(error)
                }
            }
        } else if(requestMethod == "POST") {
            if params.value(forKey: PostKey.postType) != nil{
                if (params.value(forKey: PostKey.postType) as! String) == PostKey.image{
                    params.removeObject(forKey: PostKey.postType)
                    if params.value(forKey: PostKey.imageData) != nil{
                        let imageToUpload:UIImage = params.value(forKey: PostKey.imageData) as! UIImage
                        params.removeObject(forKey: PostKey.imageData)
                        
                        let fileName:String = params.value(forKey: PostKey.filename) as! String
                        params.removeObject(forKey: PostKey.filename)
                        
                        let apiUrl = ArhebCreateUrl.generateGetUrl(apiName: apiName, params: NSDictionary())
                        
                        manager.requestSerializer.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
                        
                        let data = UIImageJPEGRepresentation(imageToUpload, 50)! as Data
                        
                        manager.post(apiUrl, parameters: params, constructingBodyWith: { (_ formData: AFMultipartFormData) in
                            formData.appendPart(withFileData: data, name: "image", fileName: fileName, mimeType: "image/jpeg")
                        }, progress: { (process) in
                            //print(process)
                        }, success: { (task, response) in
                            OperationQueue.main.addOperation {
                                if let result = response as? NSDictionary {
                                    let generalModel = GeneralModel().addResponseToModel(res: result)
                                    if generalModel.status_code == "1" {
                                        successBlock(response, nil)
                                    } else if generalModel.status_code == "0" {
                                        successBlock(nil, generalModel.success_message)
                                    }
                                }
                            }
                        }, failure: { (task, error) in
                            OperationQueue.main.addOperation {
                                failureBlock(error)
                                showToastMessage(serverError, isSuccess: false)
                            }
                        })
                    }
                }
                
            }
            
        }
        
    }
}
