
import UIKit

class CheckBoxButton: UIButton {
    
    fileprivate var check = UIImage(named: "selectedCheckbox")!.withRenderingMode(.alwaysTemplate)
    fileprivate var uncheck = UIImage(named: "unselectedCheckbox")!.withRenderingMode(.alwaysTemplate)
    
    fileprivate var isChe:Bool = false{
        didSet{
            if isChe == true{
                self.setImage(check, for: UIControlState())
            }else{
                self.setImage(uncheck, for: UIControlState())
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(CheckBoxButton.btnclick(_:)), for: UIControlEvents.touchUpInside)
        isChe = false
    }
    
    func UI_type(_ Type_id:Int){
        if Type_id == 1{
            self.check = UIImage(named: "selectedCheckbox")!.withRenderingMode(.alwaysTemplate)
            self.uncheck = UIImage(named: "unselectedCheckbox")!.withRenderingMode(.alwaysTemplate)
        }else if Type_id == 2{
            self.check = UIImage(named: "selectedCheckbox")!.withRenderingMode(.alwaysTemplate)
            self.uncheck = UIImage(named: "unselectedCheckbox")!.withRenderingMode(.alwaysTemplate)
        }
        isChe = false
    }
    func did_Selected(){
        self.isChe = true
    }
    func did_UnSelected(){
        self.isChe = false
    }
    func is_Selected() -> Bool {
        return self.isChe
    }
    @objc fileprivate func btnclick(_ sender:UIButton){
        if sender == self{
            if isChe == true{
                isChe = false
            }else{
                isChe = true
            }
        }
    }
}
