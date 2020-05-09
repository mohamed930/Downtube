//
//  Tools.swift
//  Downtupe
//
//  Created by Mohamed Ali on 4/27/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import Foundation
import SafariServices
import GoogleMobileAds

class Tools {
    
    public static func openSafari (u:String , ob:UIViewController) {
        let url = URL(string: u)
        let safariVC = SFSafariViewController(url: url!)
        ob.present(safariVC, animated: true)
    }
    
    public static func setLeftPadding (textfield:UITextField , Text:String, padding:Double) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: padding, height: 2.0))
        textfield.leftView = leftView
        textfield.leftViewMode = .always
        textfield.placeholder = Text
    }
    
    public static func SetInitialize (Banner:GADBannerView , ob:UIViewController){
        
        /*
         Use This ID when Upload It in APP Store.
         ca-app-pub-7749348761545617/7540956512
         */
        Banner.isHidden = true
        Banner.delegate = ob as? GADBannerViewDelegate
        Banner.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        Banner.adSize = kGADAdSizeSmartBannerPortrait
        Banner.rootViewController = ob
        Banner.load(GADRequest())
    }
    
    public static func setIstential (istential: inout GADInterstitial) {
        
        /*
        Use This ID when Upload It in APP Store.
        ca-app-pub-7749348761545617/2364806987
        */
        istential = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        istential.load(request)
    }
    
    public static func createAlert (Title:String , Mess:String , ob:UIViewController)
    {
        let alert = UIAlertController(title: Title , message:Mess
            , preferredStyle:UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
        ob.present(alert,animated:true,completion: nil)
    }
    
    public static func verifyUrl (urlString: String?) -> Bool {
        if let urlString = urlString {
            if let url = NSURL(string: urlString) {
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }
}
