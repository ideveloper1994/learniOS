

import UIKit

class Explore_First_CVC: UICollectionViewCell {

    @IBOutlet var btnAnywhere: UIButton!
    @IBOutlet var btnAnyTime: UIButton!
    @IBOutlet var btnGuest: UIButton!
    @IBOutlet var btnClearAll: UIButton!
    @IBOutlet var Btn_close: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.localization()
    }

    // MARK:- Localization Method
    func localization() {
        self.btnClearAll.setTitle(clearAll, for: .normal)
        self.btnGuest.setTitle(guest, for: .normal)
        self.btnAnyTime.setTitle(anytime, for: .normal)
        self.btnAnywhere.setTitle(anywhere, for: .normal)
    }
}
