//
//  PunchCardController.swift
//  Budget_app
//
//  Created by app on 1/25/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import UIKit
import AVFoundation

class PunchCardController: UIViewController, MenuProtocol, QRCodeReaderViewControllerDelegate{

    @IBOutlet weak var viewTap: UIView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var viewRightBtn: UIView!
    @IBOutlet weak var viewInfo: UIView!
    @IBOutlet weak var viewLoyal: UIView!
    @IBOutlet weak var viewImageloyal: UIView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var loyalButton: UIButton!
    @IBOutlet weak var imageLoyal: UIImageView!
    @IBOutlet weak var viewScroll: UIScrollView!
    @IBOutlet weak var textfieldCode: UITextField!
    @IBOutlet weak var scrollviewFood: UIScrollView!
    @IBOutlet var imageAward: [UIImageView]!
    
    var buttonData: UIButton = UIButton()
    
    var PHOTOSERVICE_URL = "https://raw.githubusercontent.com/Lazarus118/Budgeat_Rand_Image_src/master/file.json"
    var verificationCode = ["313-919", "428-036", "564-425"]
    
    lazy var readerVC = QRCodeReaderViewController(builder: QRCodeReaderViewControllerBuilder {
        $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode])
        $0.showTorchButton = true
    })
    
    var userName: String = ""
    var currentID: Int = 0
    let maxAward: Int = 15
    
    // Actions
    
    @IBAction func onTapDiscover(_ sender: Any) {
        viewTap.isHidden = true
        viewRightBtn.backgroundColor = UIColor.black
        viewRightBtn.alpha = 1
        
        self.view.makeToast(message: "fetching...", duration: 10.0, position: "bottom" as AnyObject)
        LoadImage(fromURL: PHOTOSERVICE_URL, downloadImage: downloadImage)
    }
    
    @IBAction func onTapRight(_ sender: Any) {
        self.view.makeToast(message: "fetching...", duration: 10.0, position: "bottom" as AnyObject)
        LoadImage(fromURL: PHOTOSERVICE_URL, downloadImage: downloadImage)
    }
    
    @IBAction func onTapFood(_ sender: Any) {
        performSegue(withIdentifier: "StartToRandom", sender: self)
    }
    
    @IBAction func onTapInfo(_ sender: Any) {
        infoButton.isSelected = !infoButton.isSelected
        updateInfo()
    }
    
    @IBAction func onTapLoyal(_ sender: Any) {
        currentID = (currentID + 1) % 3
        if currentID == 0 {
            imageLoyal.image = UIImage(named: "b_loyal")
        } else if currentID == 1 {
            imageLoyal.image = UIImage(named: "guiyave")
        } else {
            imageLoyal.image = UIImage(named: "smoothie")
        }
        updateAwards()
    }
    
    @IBAction func onTapShare(_ sender: Any) {
        guard let url = takeScreenshot(view: view) else {
            return
        }
        
        let activityViewController = UIActivityViewController(
            activityItems: ["WOW! I've just discovered this 'MEAL' for this 'PRICE' at this 'PLACE', get yours via || #Budgeat_app || www.budgeat.co", url],
            applicationActivities: nil)
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onTapCameraScan(_ sender: Any) {
        showQRAlert()
    }
    
    @IBAction func onTapFly(_ sender: Any) {
        var count = 0
        let punchCode = textfieldCode.text
        if (punchCode == verificationCode[0]){
            count = (loadAwards(id: 0) + 1) % maxAward
            saveAwards(id: 0, count: count)
        } else if (punchCode == verificationCode[1]){
            count = (loadAwards(id: 1) + 1) % maxAward
            saveAwards(id: 1, count: count)
        } else if (punchCode == verificationCode[2]){
            count = (loadAwards(id: 2) + 1) % maxAward
            saveAwards(id: 2, count: count)
        }
        if count != 0 {
            updateAwards()
        }
    }
    
    //override functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewScroll.contentSize = CGSize(width: view.frame.width, height: 315)
        textfieldCode.textColor = UIColor.yellow
        textfieldCode.backgroundColor = UIColor.clear
        
        updateInfo()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            let menuViewController = self.revealViewController().rearViewController as! MenuViewController
            menuViewController.task = self
        }
        
        let defaults = UserDefaults.standard
        if let value = defaults.value(forKey: "UserName") as? String {
            navigationItem.title = value
            userName = value
        }
        
        //loadAwards(id: 0)
        updateAwards()
        
        addFoodView(newfood: UIImage(named: "food")!)
        
        buttonData.frame.origin.x = (scrollviewFood.frame.size.width - 133) / 2
        buttonData.frame.origin.y = 15
        buttonData.frame.size.width = 133
        buttonData.frame.size.height = 101
        buttonData.addTarget(self, action: #selector(onTapFood(_:)), for: .touchUpInside)
        scrollviewFood.addSubview(buttonData)
        scrollviewFood.contentSize = CGSize(width: scrollviewFood.frame.size.width * 3 / 2, height: 131)
        
        //addFoodView(newfood: "food")
        //addFoodView(newfood: "food")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewTap.isHidden = false
    }
    
    // functions
    
    func updateInfo() {
        if infoButton.isSelected == false {
            viewInfo.isHidden = true
            var rt:CGRect = viewLoyal.frame
            rt.origin.y -= 115
            rt.size.height += 115
            viewLoyal.frame = rt
            var rt1:CGRect = viewImageloyal.frame
            rt1.origin.y = (rt.size.height - rt1.size.height) / 2
            viewImageloyal.frame = rt1
        } else {
            viewInfo.isHidden = false
            var rt:CGRect = viewLoyal.frame
            rt.origin.y += 115
            rt.size.height -= 115
            viewLoyal.frame = rt
            var rt1:CGRect = viewImageloyal.frame
            rt1.origin.y = (rt.size.height - rt1.size.height) / 2
            viewImageloyal.frame = rt1
        }
    }
    
    func addFoodView(newfood: UIImage) {
        buttonData.frame.origin.x = scrollviewFood.frame.size.width - 66
        buttonData.setImage(newfood, for: .normal)
    }
    
    func doTapReservation() {
        performSegue(withIdentifier: "StartToReservation", sender: self)
    }
    func doTapChat() {
        let defaults = UserDefaults.standard
        defaults.setValue("https://budgeat-chat-server.herokuapp.com/", forKey: "WebViewURL")
        defaults.synchronize()
        performSegue(withIdentifier: "StartToChat", sender: self)
    }
    func doTapLeaderboard() {
        performSegue(withIdentifier: "StartToLeaderboard", sender: self)
    }
    func doTapSugesstion() {
        performSegue(withIdentifier: "StartToSuggestion", sender: self)
    }
    func doTapAbout() {
        performSegue(withIdentifier: "StartToAbout", sender: self)
    }
    
    func downloadImage(url: NSDictionary) {
        if let urls = NSURL(string: url["url"] as! String) {
            print("Download Started")
            getDataFromUrl(url: urls as URL) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? urls.lastPathComponent)
                print("Download Finished")
                
                DispatchQueue.main.async() { () -> Void in
                    self.view.makeToast(message: "fetched")
                    self.addFoodView(newfood: UIImage(data: data as Data)!)
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func showQRAlert() {
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                readerVC.modalPresentationStyle = .formSheet
                readerVC.delegate               = self
                
                readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        print("Completion with result: \(result.value) of type \(result.metadataType)")
                    }
                }
                
                present(readerVC, animated: true, completion: nil)
            }
        } catch let error as NSError {
            switch error.code {
            case -11852:
                let alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.open(settingsURL, options: [:])
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
                
                
            case -11814:
                let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
            default:()
            }
        }
    }
    
    func saveAwards(id: Int, count: Int){
        print("saved")
        let defaults = UserDefaults.standard
        let numberOfAwards = NSNumber(value: count)
        defaults.setValue(numberOfAwards, forKey: userName + "awards" + String(id))
        defaults.synchronize()
    }
    
    func loadAwards(id: Int) -> Int{
        let defaults = UserDefaults.standard
        var count = 0
        if let value = defaults.value(forKey: userName + "awards" + String(id)) as? NSNumber {
            count = value.intValue
        }
        return count
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true){ [weak self] in
            if result.value == self?.verificationCode[0] || result.value == self?.verificationCode[1] || result.value == self?.verificationCode[2]{ // TO DO: Show "Success!" image or popup.
                print("Approved!")
 
                DispatchQueue.main.async {
                    var count = 0
                    if(result.value == self?.verificationCode[0]){
                        count = ((self?.loadAwards(id: 0))! + 1) % (self?.maxAward)!
                        self?.saveAwards(id: 0, count: count)
                    } else if(result.value == self?.verificationCode[1]){
                        count = ((self?.loadAwards(id: 1))! + 1) % (self?.maxAward)!
                        self?.saveAwards(id: 1, count: count)
                    } else {
                        count = ((self?.loadAwards(id: 2))! + 1) % (self?.maxAward)!
                        self?.saveAwards(id: 2, count: count)
                    }
                    self?.updateAwards()
                }
            } else { // TO DO: Show "Failed!" image or popup.
                // fails authorization
                
                let alert = UIAlertController(
                    title: "",
                    message: "Invalid QR Code!",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:  { (_) in
                    DispatchQueue.main.async {
                        //self?.ScanQRCode(scannedString: "", isSuccess: false)
                        print("Authorization Failed!")
                    }
                }))
                self?.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
    }
    
    func updateAwards() {
        var count = loadAwards(id: currentID)
        if count != 0 {
            for var i in 0...count - 1 {
                imageAward[i].image = UIImage(named: "ic_punch_front")
            }
        }
        for var i in count...imageAward.count - 1 {
            imageAward[i].image = UIImage(named: "ic_punch_back")
        }
    }
}
