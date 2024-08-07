//
//  AdsScreenViewController.swift
//  CoffeeApp
//
//  Created by Adam Khan on 6/25/24.
//

import UIKit
import GoogleMobileAds


class AdsScreenViewController: UIViewController,  GADFullScreenContentDelegate, GADBannerViewDelegate {
    
    
    
    //MARK: variables:
    var videoInterstitial: GADInterstitialAd?
    var interstitial: GADInterstitialAd?
    var adaptiveBannerView: GADBannerView!
    var rewardedAd: GADRewardedInterstitialAd?
    var collapsibleBanner : GADBannerView!
    var appOpenAd: GADAppOpenAd?
    var isLoadingAd = false
    var isShowingAd = false
    
    
    
    
    
    
    override func viewDidLoad() {
        
        navigationController?.delegate = self
        
        super.viewDidLoad()
        Task {
            await loadInterstitial()
        }
        Task {
            await loadVideoInterstitial()
        }
        Task {
            await loadRewardedAd()
        }
        adaptiveBannerAd()
        //        Task {
        //           await loadOpenAd()
        //        }
    }
    
    //    func loadOpenAd() async {
    //        if isLoadingAd || appOpenAd != nil {
    //            return
    //        }
    //
    //        isLoadingAd = true
    //
    //          do {
    //            appOpenAd = try await GADAppOpenAd.load(
    //              withAdUnitID: "ca-app-pub-3940256099942544/5575463023", request: GADRequest())
    //          } catch {
    //            print("App open ad failed to load with error: \(error.localizedDescription)")
    //          }
    //          isLoadingAd = false
    //        }
    //
    //    func showOpenAd(){
    //
    //
    //          guard !isShowingAd else { return }
    //
    //          if appOpenAd != nil {
    //            Task {
    //              await loadOpenAd()
    //            }
    //            return
    //          }
    //
    //          if let ad = appOpenAd {
    //            isShowingAd = true
    //            ad.present(fromRootViewController: self)
    //          }
    //    }
    @IBAction func rewardedAdsBtnPressed(_ sender: UIButton) {
        rewardedAd?.present(fromRootViewController: self, userDidEarnRewardHandler: {
            print("Reward Earned")
        })
        Task{
            await loadRewardedAd()
        }
    }
    
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
    }
    
    
    @IBAction func videoInterstitialBtnPressed(_ sender: Any) {
        videoInterstitial?.present(fromRootViewController: self)
        Task {
            await loadVideoInterstitial()
        }
    }
    
    
    
    @IBAction func interstitialBtnPressed(_ sender: UIButton) {
        interstitial?.present(fromRootViewController: self)
        Task{
            await loadInterstitial()
        }
    }
    
    
    @IBAction func adaptiveSizeBtnPressed(_ sender: UIButton) {
        loadAdoptiveAd()
        //showOpenAd()
    }
    
    
    
    @IBAction func onCountryListClicked(_ sender: UIButton) {
        let countryScreenController = self.storyboard?.instantiateViewController(identifier: "countryListViewController") as! CountryListViewController
        navigationController?.pushViewController(countryScreenController, animated: true)
        //self.navigationController?.pushViewController(countryScreenController, animated: true)
        //        UIView.animate(withDuration: 4) {
        //            countryScreenController.beginAppearanceTransition(true, animated: true)
        //            self.navigationController?.pushViewController(countryScreenController, animated: true)
        //
        //        }
        //        self.transition(from: self, to: countryScreenController, duration: 2) {
        //            //self.navigationController?.pushViewController(countryScreenController, animated: true)
        //        }
        //        countryScreenController.transition(from: self, to: countryScreenController , duration: 2) {
        //            self.navigationController?.pushViewController(countryScreenController, animated: true)
        //        }
    }
    
    
    
    
    
    func adaptiveBannerAd(){
        let adaptiveSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(view.frame.inset(by: view.safeAreaInsets).width)
        adaptiveBannerView = GADBannerView(adSize: adaptiveSize)
        adaptiveBannerView.layer.cornerRadius = 10
        addBannerViewToView(adaptiveBannerView)
    }
    
    
    
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints( [NSLayoutConstraint(item: bannerView,
                                                 attribute: .top,
                                                 relatedBy: .equal,
                                                 toItem: view.safeAreaLayoutGuide,
                                                 attribute: .top,
                                                 multiplier: 1,
                                                 constant: 0),
                              
                              NSLayoutConstraint(item: bannerView,
                                                 attribute: .centerX,
                                                 relatedBy: .equal,
                                                 toItem: view.safeAreaLayoutGuide,
                                                 attribute: .centerX,
                                                 multiplier: 1,
                                                 constant: 0),
        ])
    }
    
    func loadRewardedAd() async {
        do {
            rewardedAd = try await GADRewardedInterstitialAd.load(
                withAdUnitID: "ca-app-pub-3940256099942544/6978759866", request: GADRequest())
            self.rewardedAd?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load rewarded interstitial ad with error: \(error.localizedDescription)")
        }
    }
    
    
    
    
    @IBAction func onCoreDataScreenClicked(_ sender: UIButton) {
        let coreDataHomeScreenController = self.storyboard?.instantiateViewController(identifier: "CoreDataHomeScreen") as! CoreDataHomeScreenViewController
        self.navigationController?.pushViewController( coreDataHomeScreenController, animated: true)
    }
    
    
    func loadAdoptiveAd(){
        adaptiveBannerView.adUnitID = "ca-app-pub-3940256099942544/2435281174"
        adaptiveBannerView.rootViewController = self
        adaptiveBannerView.delegate = self
        adaptiveBannerView.load(GADRequest())
    }
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerView.alpha = 0
        UIView.animate(withDuration: 3, animations: {
            bannerView.alpha = 1
        })
    }
    
    
    
    func loadInterstitial() async {
        do {
            interstitial = try await GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest())
            interstitial?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
    func loadVideoInterstitial() async {
        do {
            videoInterstitial = try await GADInterstitialAd.load(withAdUnitID: "ca-app-pub-3940256099942544/5135589807", request: GADRequest())
            videoInterstitial?.fullScreenContentDelegate = self
        } catch {
            print("Failed to load interstitial ad with error: \(error.localizedDescription)")
        }
    }
}
extension AdsScreenViewController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = CustomNavigationTransition()
        animator.isPresenting = operation == .push
        return animator
    }
}
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

