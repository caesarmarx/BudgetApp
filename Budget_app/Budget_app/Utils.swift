//
//  FileUtils.swift
//  Budget_app
//
//  Created by app on 1/27/17.
//  Copyright © 2017 Aulavara Design & Development. All rights reserved.
//

import Foundation

func importData(from url: URL) {
    // 1
    /*guard let dictionary = NSDictionary(contentsOf: url),
        let beerInfo = dictionary as? [String: AnyObject],
        let name = beerInfo[Keys.Name.rawValue] as? String,
        let rating = beerInfo[Keys.Rating.rawValue] as? NSNumber else {
            return
    }
    
    // 2
    let beer = Beer(name: name, note: beerInfo[Keys.Note.rawValue] as? String, rating: rating.intValue)
    
    // 3
    if let base64 = beerInfo[Keys.ImagePath.rawValue] as? String,
        let imageData = Data(base64Encoded: base64, options: .ignoreUnknownCharacters),
        let image = UIImage(data: imageData) {
        beer.saveImage(image)
    }
    
    // 4
    BeerManager.sharedInstance.beers.append(beer)
    BeerManager.sharedInstance.saveBeers()
    
    // 5
    do {
        try FileManager.default.removeItem(at: url)
    } catch {
        print("Failed to remove item from Inbox")
    }*/
}

func takeScreenshot(view: UIView) -> URL? {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    guard let path = FileManager.default
        .urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
    }
    
    let saveFileURL = path.appendingPathComponent("shared_budgeat_random.jpg")
    
    if let data = UIImageJPEGRepresentation(image!, 0.8) {
        try? data.write(to: saveFileURL)
    }
    
    return saveFileURL
}

//

func LoadFromURL(fromURL: String, completenHandler: ((NSDictionary, ((NSDictionary) -> Void)?) -> Void)!, finishHandler: ((NSDictionary) -> Void)!) {
    var task: URLSessionDownloadTask!
    var session: URLSession!
    session = URLSession.shared
    task = URLSessionDownloadTask()
    let url:URL! = URL(string: fromURL)
    task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
        if location != nil{
            let data:Data! = try? Data(contentsOf: location!)
            do{
                let httpResponse = response as! HTTPURLResponse
                if httpResponse.statusCode != 200 {
                    return
                }
                let strData = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
                completenHandler(json!, finishHandler)
            }catch{
                print("something went wrong, try again")
            }
        }
    })
    task.resume()
}

func FinishImage(json: NSDictionary, finishHandler: ((NSDictionary) -> Void)?) {
    let imageJson = json["Album"] as? NSArray
    if imageJson?.count == 0 {
        return
    } else {
        let random = Int(arc4random_uniform(UInt32((imageJson?.count)!)))
        let a = imageJson?[random] as? NSDictionary
        finishHandler!(a!)
    }
}

func LoadImage(fromURL: String, downloadImage: ((NSDictionary) -> Void)!) {
    LoadFromURL(fromURL: fromURL, completenHandler: FinishImage, finishHandler: downloadImage)
}

func FinishInfo(json: NSDictionary, finishHandler: ((NSDictionary) -> Void)?) {
    let imageJson = json["data"] as? NSArray
    if imageJson?.count == 0 {
        return
    } else {
        let random = Int(arc4random_uniform(UInt32((imageJson?.count)!)))
        let a = imageJson?[random] as? NSDictionary
        finishHandler!(a!)
    }
}

func LoadInfo(fromURL: String, downloadInfo: ((NSDictionary) -> Void)!) {
    LoadFromURL(fromURL: fromURL, completenHandler: FinishInfo, finishHandler: downloadInfo)
}

//

func postURL(params : Dictionary<String, String>, url : String, view: UIView) {
    var request = NSMutableURLRequest(url: NSURL(string: url) as! URL)
    var session = URLSession.shared
    request.httpMethod = "POST"
    
    try? request.httpBody = JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    var task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
        print("Response: \(response)")
        if error == nil{
            DispatchQueue.main.async() { () -> Void in
                view.makeToast(message: "Successfully added")
            }
        } else {
            DispatchQueue.main.async() { () -> Void in
                view.makeToast(message: "Failed")
            }
            print(error?.localizedDescription)
        }
        
    })
    
    task.resume()
}

