
import UIKit
//import MBProgressHUD

let imageBase_URL = ""

let Signature_imageUrl = "set image upload url"

let download_signatureimage = ""


let urlBase = "https://jsonplaceholder.typicode.com/"
let delegate = UIApplication.shared.delegate as! AppDelegate
var  count = 0
var timer:  Timer?
var window: UIWindow?
var navController: UINavigationController?

class WebServiceClass: NSObject
{
    static let shared = WebServiceClass()
    
    
    var objappDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func webService(webService : WebServiceClass) -> WebServiceClass {
        return webService
    }
    
    var finalnumberid  = String()
    //MARK: - get method
    func jsonCallGET(classURL: NSString, completionHandler: @escaping (_ result:Any?,_ error:Error?) -> Swift.Void)
    {
        DispatchQueue.main.async {
//            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                MBProgressHUD.showAdded(to: window, animated: true)
//
//            }
        
        
        }
        
        let urlString = "\(urlBase)\(classURL)"
        var request = URLRequest(url: URL(string: urlString)!)
        let session = URLSession.shared
        request.httpMethod = "GET"
        session.dataTask(with: request) {data, response, error in
            if error != nil
            {
                print(error!.localizedDescription)
                return
            }
            do
            {
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print("Synchronous\(String(describing: jsonResult))")
                
                if(jsonResult?.value(forKey: "status") as! NSInteger == 0)
                {
                    DispatchQueue.main.async {
//
//                        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                            MBProgressHUD.hide(for: window, animated: false)
//
//                        }
                    }
                    completionHandler(jsonResult?.object(forKey: "data"),error)
                }
                else
                {
                    DispatchQueue.main.async {
//                        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                            MBProgressHUD.hide(for: window, animated: false)
//                        }
                    }
                    completionHandler(nil, error)
                }
            }
            catch
            {
                DispatchQueue.main.async {
//                    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                        MBProgressHUD.hide(for: window, animated: false)
//                    }
                }
                
                print(error.localizedDescription)
            }
            
            }.resume()
    }
    
    
    //MARK: - POST method
    
    func jsonCallwithData(dicData: [AnyHashable: Any] , ClassUrl : String , completionHandler: @escaping (NSMutableDictionary?, Error?) -> Swift.Void)
    {
        
        print("dicData :\(dicData)")
        let url = URL(string: urlBase + ClassUrl)!
        let session = URLSession.shared
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 30
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if UserDefaults.standard.value(forKey: "userdefaultAuthHeader") != nil
        {
            let BaseLoginString = UserDefaults.standard.value(forKey: "userdefaultAuthHeader") as! String
            print("BaseLoginString : \(BaseLoginString)")
            
            request.setValue("\(BaseLoginString)", forHTTPHeaderField: "Authorization")
        }
        else{
        print("im here")
        }
        
        
        var bodyData : Data
      
        do {
           
            bodyData = try JSONSerialization.data(withJSONObject: dicData, options: JSONSerialization.WritingOptions(rawValue: 0)) as Data
           
            request.httpBody = bodyData
        } catch {
            print(error)
        }
        
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil
            {
                print(error!.localizedDescription)
                DispatchQueue.main.async {
//                    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                        MBProgressHUD.hide(for: window, animated: false)
//                    }
                    // this call to func for alret internet call
                     self.showFailureMessage(error: error! as NSError)
                }
                return
            }
            do
            {
                
              
            let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                print("Synchronous\(String(describing: jsonResult))")
                
                if(jsonResult?.value(forKey: "code") as! NSInteger == 200)
                {
                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                }
                else
                {
//                    let alertController = UIAlertController(title: "Appname", message: (jsonResult?.value(forKey: "message") as! NSString) as String, preferredStyle: .alert)
//                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//                    {
//                        (action: UIAlertAction) in print("You have pressed ok button")
//                    }
//                    alertController.addAction(OKAction)
                    DispatchQueue.main.async {
//                        if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                            MBProgressHUD.hide(for: window, animated: false)
//                        }
                    }

                    DispatchQueue.main.async
                        {
//                            delegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            catch
            {
                DispatchQueue.main.async {
//                    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                        MBProgressHUD.hide(for: window, animated: false)
//                    }
                }
                print(error.localizedDescription)
                
            }
        }
        task.resume()
    }
    
    //MARK: - POST method WithImage
    
    func jsonCallWithImage(imageData: Data, strfieldName: String, urlClass: String, completionHandler: @escaping (NSMutableDictionary?, Error?) -> Swift.Void) {
        
//        DispatchQueue.main.async {
//            if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                MBProgressHUD.showAdded(to: window, animated: true)
//        }
//        }
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: nil)
        let BoundaryConstant = "----------V2ymHFg03ehbqgZCaKO6jy"
        
        let FileParamConstant: String = strfieldName
      
        let url = URL(string: "\(urlBase)\(urlClass)")
        var request: URLRequest = URLRequest(url: url!)
        request.httpMethod = "POST"
        let contentType = "multipart/form-data; boundary=\(BoundaryConstant)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        if imageData != nil{
            body.append("--\(BoundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(FileParamConstant)\"; filename=\"image.png\"\r\n".data(using: String.Encoding.utf8)!)
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: String.Encoding.utf8)!)
            body.append(imageData as Data)
            body.append("\r\n".data(using: String.Encoding.utf8)!)
        }
        body.append("--\(BoundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        request.httpBody = body
        let postLength = "\(UInt(body.count))"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        // set URL
        request.url = url
        let task = session.dataTask(with: request) { data, response, error in
            
            if error != nil
            {
                print(error!.localizedDescription)
                return
            }
            do
            {
                
                let jsonResult: NSDictionary? = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                print("Synchronous\(String(describing: jsonResult))")
                
               if((jsonResult?.value(forKey: "Image key-name")) != nil)
               {
//                DispatchQueue.main.async {
//                    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                        MBProgressHUD.hide(for: window, animated: false)
//                    }
//                }
                    completionHandler(jsonResult?.mutableCopy() as? NSMutableDictionary,error)
                }
                else
                {
//                    let alertController = UIAlertController(title: "Alert", message: (jsonResult?.value(forKey: "message") as! NSString) as String, preferredStyle: .alert)
//                    let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
//                    {
//                        (action: UIAlertAction) in print("You have pressed ok button")
//                    }
//                    alertController.addAction(OKAction)
//
//                    DispatchQueue.main.async
//                        {
////                            DispatchQueue.main.async {
////                                if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
////                                    MBProgressHUD.hide(for: window, animated: false)
////                                }}
//                            delegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
//                    }
                }
            }
            catch
            {
//                DispatchQueue.main.async {
//                    if let app = UIApplication.shared.delegate as? AppDelegate, let window = app.window {
//                        MBProgressHUD.hide(for: window, animated: false)
//                    }
//                }
                print(error.localizedDescription)
            }
        }
       
        task.resume()
    }
    
 //MARK: - internet connection request
    
    func showFailureMessage(error : NSError)  {
        
        if (error.localizedDescription.range(of: "The request timed out."))  != nil {
            showAlertwithTitle(strTitle: "Appname", message: "The request timed out, please verify your internet connection and try again.")
        }
        else if (error.localizedDescription.range(of: "The server can not find the requested page"))  != nil ||  (error.localizedDescription.range(of: "A server with the specified hostname could not be found."))  != nil
        {
            showAlertwithTitle(strTitle: "Appname", message: "Unable to reach to the server, please try again after few minutes")
        }
        else if (error.localizedDescription.range(of: "The network connection was lost."))  != nil  {
            showAlertwithTitle(strTitle: "Appname", message: "The network connection was lost, please try again.")
        }
        else if (error.localizedDescription.range(of:"The Internet connection appears to be offline."))  != nil  {
            showAlertwithTitle(strTitle:"Appname", message: "The Internet connection appears to be offline.")
        }
        else if (error.localizedDescription.range(of:"JSON text did not start with array or object and option to allow fragments not set."))  != nil  {
            
            showAlertwithTitle(strTitle: "Appname", message: "Server error!")
        }
        else{
            showAlertwithTitle(strTitle: "Appname", message: "Unable to connect, please try again!")
        }
    }
    
    func showAlertwithTitle(strTitle: String?, message strMessage: String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        let alertOK = UIAlertAction(title: "OK", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(alertOK)
        DispatchQueue.main.async {
            if let view = window?.rootViewController{
                view.present(alert, animated: true, completion: nil)
            }
        }
    }

}
