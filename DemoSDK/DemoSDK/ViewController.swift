//
//  ViewController.swift
//  DemoSDK
//
//

import UIKit
import CiedSDKTest
class ViewController: UIViewController ,CieIdDelegate{
    
    var mode: Mode = .Default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func entraConCied(_ sender: CieIDButton) {
        let vc = CieIDWKWebViewController()
        vc.setupDelegate(delegate: self, and: .Redirect, and: self.mode)
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func actionSegmented(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.mode = .Default
        }
        else {
            self.mode = .Universal
        }
    }
    
    func CieIDAuthenticationClosedWithSuccess() {
        print("Success")
    }
    
    func CieIDAuthenticationClosedWithError(errorMessage: String) {
//        DispatchQueue.main.async {
//            self.presentingViewController?.dismiss(animated: true, completion: nil)
//        }

    }
    
    func CieIDAuthenticationCanceled() {
        print("cancelled")
    }
}

