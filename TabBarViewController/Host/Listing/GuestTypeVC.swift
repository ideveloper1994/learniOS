
import UIKit

class GuestTypeVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var tblGuestType: UITableView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var lblGuestCategory: UILabel!
    @IBOutlet var lblGuestType: UILabel!

    var arrName = [maleGuest,femaleGuest,familyGuest]
    var arrImages = ["entirehome.png","privateroom.png","sharedroom.png"]
    var ischecked = [true,true,true]
    var strRoomType = ""
    var strPropertyType = ""
    var strPropertyName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblGuestType.delegate = self
        tblGuestType.dataSource = self
        tblGuestType.register(UINib(nibName: "GuestTypeCell", bundle: nil), forCellReuseIdentifier: "GuestTypeCell")
        self.localization()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    // MARK:- Table View Method(s)
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestTypeCell", for: indexPath) as! GuestTypeCell
        cell.lblGuestType.text = arrName[indexPath.row]
        cell.imgCell.image = UIImage(named: arrImages[indexPath.row])
        cell.imgCheckMark.isHidden = ischecked[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        ischecked[indexPath.row] = !ischecked[indexPath.row]        
        tblGuestType.reloadData()
    }
    
    // MARK:- IBOutlet Method(s)
    
    @IBAction func btnBackClicked(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnNextClicked(_ sender: UIButton) {
        let vc = LocationVC(nibName: "LocationVC", bundle: nil)
        vc.strRoomType = strRoomType
        vc.strPropertyType = strPropertyType
        vc.strPropertyName = strPropertyName
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func localization() {
        self.lblGuestCategory.text = guestCategory
        self.lblGuestType.text = guestCategoryType
    }

}
