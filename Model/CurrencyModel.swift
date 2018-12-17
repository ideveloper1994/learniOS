
import Foundation
import UIKit

class CurrencyModel : NSObject {
    
    //MARK Properties
    
    var success_message : String = ""
    var status_code : String = ""
    var currency_code : String = ""
    var currency_symbol : String = ""

   // MARK: Inits
    
    func initiateCurrencyData(jsonData: Any) -> [CurrencyModel] {
        var dataCurrency = [CurrencyModel]()
        let jsonDic = jsonData as! NSDictionary
        let jsonArr = jsonDic.value(forKey: "currency_list") as! NSArray
        for data in jsonArr {
            let objList = CurrencyModel()
            let obj = data as! NSDictionary
            bindData(dic: obj, str: "code", type: &objList.currency_code)
            bindData(dic: obj, str: "symbol", type: &objList.currency_symbol)
            dataCurrency.append(objList)
        }
        return dataCurrency
    }
}
