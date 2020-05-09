//
//  DownloadViewController.swift
//  Downtupe
//
//  Created by Mohamed Ali on 4/27/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Alamofire
import RappleProgressHUD


class DownloadViewController: UIViewController {
    
    public var downloadview : DownloadView! {
        guard isViewLoaded else { return nil }
        return (view as! DownloadView)
    }
    
    var interstitial: GADInterstitial!
    var flag = 0
    
    let key = "a94abdc88cmshbb9e632101681ccp131628jsnedf29d651b1e"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Tools.setLeftPadding(textfield: downloadview.LinkTextField , Text: "Enter Your Link to Download Video", padding: 10.0)
        
        Tools.SetInitialize(Banner: downloadview.Ad1, ob: self)
        Tools.SetInitialize(Banner: downloadview.Ad2, ob: self)
        
        
        /*
        Use This ID when Upload It in APP Store.
        ca-app-pub-7749348761545617/2364806987
        */
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
    }
    
    @IBAction func BTNDownloadImage(_ sender:Any) {
        
        self.performSegue(withIdentifier: "DownloadThumbnail", sender: self)
        //print("Image URL: \(self.ImageUrL)")
    }
    
    @IBAction func BTNDownloadHD(_ sender:Any){
        flag = 1
        self.performSegue(withIdentifier: "DownloadVideo", sender: self)
    }
    
    @IBAction func BTNDownloadSD(_ sender:Any){
        flag = 2
        self.performSegue(withIdentifier: "DownloadVideo", sender: self)
    }
    
    @IBAction func BTNDownloadAudio(_ sender:Any){
        
        if (downloadview.LinkTextField.text?.hasPrefix("https://soundcloud.com/"))! {
            flag = 4
        }
        else {
            flag = 3
        }
        self.performSegue(withIdentifier: "DownloadVideo", sender: self)
    }
    
    @IBAction func BTNDownload(_ sender:Any){
        
        if downloadview.LinkTextField.text == "" {
            Tools.createAlert(Title: "Error", Mess: "You Must Enter The Valid URL", ob: self)
        }
        else {
            
            if Tools.verifyUrl(urlString: downloadview.LinkTextField.text) {
                
                let url = downloadview.LinkTextField.text!
                
                if url.hasPrefix("https://soundcloud.com/") {
                    print("Rcieved")
                    AnalysisLinkSoundCloud(url: url)
                }
                else {
                    AnalysisLink(url: url)
                }
                
                /*if (self.interstitial.isReady) {
                    interstitial.present(fromRootViewController: self)
                    
                }
                else {
                    interstitial = creadAd()
                }*/
            }
            else {
                Tools.createAlert(Title: "Error", Mess: "Your URL isn't Valid", ob: self)
            }
        }
    }
    
    func AnalysisLink (url:String) {
        
        let p:[String:Any] = ["url":URL(string: url)!,"rapidapi-key":key]

        RappleActivityIndicatorView.startAnimatingWithLabel("Loading", attributes: RappleAppleAttributes)
        AF.request(URL(string: "https://getvideo.p.rapidapi.com/")!, method: .get , parameters: p).response{
            (responds) in
            switch responds.result {

            case .success(_):
                //print(responds.result)
                let data = responds.data
                self.parseJson(json: data!)
                break
            case .failure(_):
                RappleActivityIndicatorView.stopAnimation()
                print("Error")
                break
            }
        }
    }
    
    func AnalysisLinkSoundCloud (url:String) {
        
        let parameters: [String:String] = ["url":url,"rapidapi-key":key]
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading", attributes: RappleAppleAttributes)
        AF.request("https://getvideo.p.rapidapi.com/", method: .get, parameters: parameters).response{
            response in
            
            switch response.result {
                
            case .success(_):
                print("Sended")
                let data = response.data
                self.parseAudioJSON(d: data!)
                break
            case .failure(_):
                RappleActivityIndicatorView.stopAnimation()
                print("Error")
                break
            }
        }
        
    }
    
    
    func parseAudioJSON(d:Data) {
        do {
            
            let JSONdecoder = try JSONDecoder().decode(AudioURL1.self, from: d)
            
            if JSONdecoder.status == false {
                print("Error")
                Tools.createAlert(Title: "Error", Mess: "Sorry We Can't Find Your Audio!", ob: self)
                RappleActivityIndicatorView.stopAnimation()
            }
            else {
                print("Completed!")
                RappleActivityIndicatorView.stopAnimation()
                downloadview.BTNHD.isHidden = true
                downloadview.BTNSD.isHidden = true
                downloadview.Scroll.isHidden = false
                downloadview.TitleLabel.text = JSONdecoder.title!
                downloadview.AuthorLabel.text = JSONdecoder.uploader!
                self.AudioURL = (JSONdecoder.streams?.first?.url)!
                self.ImageUrL = JSONdecoder.thumbnail!
            }
        }catch {
            print("Can't Parse!")
            RappleActivityIndicatorView.stopAnimation()
        }
    }
    
    var ImageUrL = ""
    var HDURL = ""
    var SDURL = ""
    var AudioURL = ""
    
    func parseJson(json:Data) {
        
        do {
            let JSONdecoder = try JSONDecoder().decode(url.self, from: json)
            
            if JSONdecoder.statue == true {
                RappleActivityIndicatorView.stopAnimation()
                downloadview.BTNHD.isHidden = false
                downloadview.BTNSD.isHidden = false
                downloadview.Scroll.isHidden = false
                downloadview.TitleLabel.text = JSONdecoder.title!
                downloadview.AuthorLabel.text = JSONdecoder.uploader!
                ImageUrL = JSONdecoder.thumbnil!
                
                HDURL = JSONdecoder.Streams![0].url!
                SDURL = JSONdecoder.Streams![1].url!
                AudioURL = (JSONdecoder.Streams?.last?.url)!
            }
            else {
//                let Alert = UIAlertController(title: "Error", message: "Sorry We Can't Find Your Video try Again", preferredStyle: .alert)
//                let action = UIAlertAction(title: "OK", style: .default) { (alert) in
//
//                }
//                Alert.addAction(action)
//                self.present(Alert, animated: true, completion: nil)
                self.AnalysisLink(url: self.downloadview.LinkTextField.text!)
            }
        }catch {
            print("Error \(error.localizedDescription)")
            RappleActivityIndicatorView.stopAnimation()
        }
    }
    
    func creadAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        inter.load(GADRequest())
        return inter
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DownloadThumbnail" {
            let vc = segue.destination as! ImageViewController
            vc.ImageURL = self.ImageUrL
        }
        else if segue.identifier == "DownloadVideo" {
            let vc = segue.destination as! DownloadVideoViewController
            
            if flag == 1 {
                vc.type = "HD:"
                vc.url = self.HDURL
                vc.videoName = self.downloadview.TitleLabel.text!
            }
            else if flag == 2 {
                vc.type = "SD:"
                vc.url = self.SDURL
                vc.videoName = self.downloadview.TitleLabel.text!
            }
            else if flag == 3 {
                vc.type = "m4a:"
                vc.url = self.AudioURL
            }
            else if flag == 4 {
                vc.type = "mp3:"
                vc.url = self.AudioURL
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension DownloadViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
}

extension DownloadViewController: GADBannerViewDelegate {
    
    internal func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        downloadview.Ad1.isHidden = false
        downloadview.Ad2.isHidden = false
    }
    
    internal func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        downloadview.Ad1.isHidden = true
        downloadview.Ad2.isHidden = true
    }
    
}
