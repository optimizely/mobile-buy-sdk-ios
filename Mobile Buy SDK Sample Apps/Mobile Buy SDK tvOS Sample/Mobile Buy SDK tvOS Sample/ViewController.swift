//
//  ViewController.swift
//  Mobile Buy SDK tvOS Sample App
//
//  Created by Shopify.
//  Copyright (c) 2016 Shopify Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import OptimizelySDKTVOS

class ViewController: UIViewController, DataProviderSetter {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collections: CollectionsViewModel!
    var dataProvider: DataProvider!
    var optlyManager: OPTLYManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collections = CollectionsViewModel(dataProvider: self.dataProvider)
        self.collectionView.dataSource = self.collections
        self.collections.getCollections { 
            self.collectionView.reloadData()
        }
        self.optlyManager = OPTLYManager.init({ (builder) in
            builder!.projectId = "8089961867"
        })!
        NotificationCenter.default.addObserver(self, selector: #selector(self.experimentListener), name: NSNotification.Name.OptimizelyDidActivateExperiment, object: nil)
        self.optlyManager.initialize { (error, client) in
            client?.activate("basic_experiment", userId: "user")
        }
    }
    
    func createAlert(alertTitle: String, buttonTitle:String, message: String) -> UIAlertController {
        let alertController = UIAlertController(title: alertTitle, message: message, preferredStyle: .alert)
        let buttonAction = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertController.addAction(buttonAction)
        return alertController
    }
    
    func experimentListener(notification: NSNotification) {
        print("experiment listener fired")
    }
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        if collectionView != self.collectionView {
            return true
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.collectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
            if cell.productItem.productImages.count > 0 {
                let pageViewController = PageViewController(product: cell.productItem)
                self.present(pageViewController, animated: true, completion: nil)
            } else {
                let title = "Oops!"
                let message = "Looks like this product has no images"
                let acceptButtonTitle = NSLocalizedString("OK", comment: "")
                let alertController = self.createAlert(alertTitle: title, buttonTitle: acceptButtonTitle, message: message)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}
