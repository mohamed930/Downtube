//
//  ViewController.swift
//  Downtupe
//
//  Created by Mohamed Ali on 4/27/20.
//  Copyright © 2020 Mohamed Ali. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var Bannar1: GADBannerView!
    @IBOutlet weak var Bannar2: GADBannerView!
    
    private var Array = ["172-1725552_facebook-logo-png","The_Instagram_Logo","image-1","Untitled-1","soundcloud-logo","gaming-twitch-tv-logo"]
    private var Color = ["#1877f2","#ff0088","#26bffd","#ff9191","#ffd492","#f94dff"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.register(UINib(nibName: "SocialMediaCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        
        Tools.SetInitialize(Banner: Bannar1 , ob: self)
        Tools.SetInitialize(Banner: Bannar2 , ob: self)
    }
    
    @IBAction func BTNExit(_ sender:Any){
        let alert = UIAlertController(title: "Attention", message: "Are You Sure to Exit?", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Exit", style: .default) { (alert) in
            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
        }
        alert.addAction(action1)
        
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(action2)
        
        self.present(alert, animated: true, completion: nil)
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: SocialMediaCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! SocialMediaCell
        
        cell.FacebookImage.image = UIImage(named: Array[indexPath.row])
        cell.BackGround.backgroundColor = UIColor().hexStringToUIColor(hex: Color[indexPath.row])
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var url:String?
        
        switch indexPath.row {
        case 0:
            url = "https://www.facebook.com"
            Tools.openSafari(u: url!, ob: self)
            break
        case 1:
            url = "https://www.instagram.com"
            Tools.openSafari(u: url!, ob: self)
            break
        case 2:
            url = "https://twitter.com/explore"
            Tools.openSafari(u: url!, ob: self)
            break
        case 3:
            url = "https://www.youtube.com"
            Tools.openSafari(u: url!, ob: self)
            break
        case 4:
            url = "https://soundcloud.com"
            Tools.openSafari(u: url!, ob: self)
            break
        case 5:
            url = "https://www.twitch.tv"
            Tools.openSafari(u: url!, ob: self)
            break
        default:
            print("There is no More Choices")
        }
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath:
        IndexPath) -> CGSize {
        
        let w1 = self.collectionView.frame.width - (8 * 2)
        let cell_width = (w1 - (8)) / 2
        
        return CGSize(width: cell_width, height: 250)
    }
}

extension ViewController: GADBannerViewDelegate {
    
    internal func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        Bannar1.isHidden = false
        Bannar2.isHidden = false
    }
    
    internal func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        Bannar1.isHidden = true
        Bannar2.isHidden = true
    }

    
}

