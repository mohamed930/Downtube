//
//  ImageViewController.swift
//  Downtupe1
//
//  Created by Mohamed Ali on 5/2/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import Alamofire
import RappleProgressHUD
import GoogleMobileAds

class ImageViewController: UIViewController {
    
    var ImageURL:String?
    var interstitial: GADInterstitial!
    
    public var imageview : ImageView! {
        guard isViewLoaded else { return nil }
        return (view as! ImageView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Tools.SetInitialize(Banner: imageview.Ad1, ob: self)
        Tools.SetInitialize(Banner: imageview.Ad2, ob: self)
        
        /*
        Use This ID when Upload It in APP Store.
        ca-app-pub-7749348761545617/2364806987
        */
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let request = GADRequest()
        interstitial.load(request)
        
        loadingPage()
    }
    
    @IBAction func BTNBack(_ sender:Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func BTNDownload(_ sender:Any) {
        if self.interstitial.isReady {
          interstitial.present(fromRootViewController: self)
          RappleActivityIndicatorView.startAnimatingWithLabel("Loading", attributes: RappleAppleAttributes)
          if let url = URL(string: ImageURL!),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) {
              UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
              RappleActivityIndicatorView.stopAnimation()
              
              Tools.createAlert(Title: "Sucess", Mess: "Your Photo added Successfully", ob: self)
          }
          
        }
        else {
             interstitial = creadAd()
         }
    }
    
    func loadImage() {
        let url = URL(string: ImageURL!)
        
        RappleActivityIndicatorView.startAnimatingWithLabel("Loading", attributes: RappleAppleAttributes)
        AF.request(url!).responseData{
            (response) in
            switch response.result {
            case .success(_):
                self.imageview.ThumbnailImage.image = UIImage(data: response.data!)
                RappleActivityIndicatorView.stopAnimation()
                break
            case .failure(_):
                print((response.error?.localizedDescription)!)
                RappleActivityIndicatorView.stopAnimation()
                break
            }
        }
    }
    
     func loadingPage() {
       if self.interstitial.isReady {
         interstitial.present(fromRootViewController: self)
         self.loadImage()
       }
       else {
            interstitial = creadAd()
            interstitial.present(fromRootViewController: self)
            self.loadImage()
        }
    }
    
    func creadAd() -> GADInterstitial {
        let inter = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        inter.load(GADRequest())
        return inter
    }
}

extension ImageViewController: GADBannerViewDelegate {
    
    internal func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        imageview.Ad1.isHidden = false
        imageview.Ad2.isHidden = false
    }
    
    internal func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        imageview.Ad1.isHidden = true
        imageview.Ad2.isHidden = true
    }
    
}
