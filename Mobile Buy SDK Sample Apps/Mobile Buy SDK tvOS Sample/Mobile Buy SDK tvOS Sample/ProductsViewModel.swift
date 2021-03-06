//
//  ProductsViewModel.swift
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

import Foundation
import Buy

class ProductsViewModel: BaseViewModel {
    
    private var collection: BUYCollection!
    fileprivate var products: [BUYProduct?] = []
    
    weak var collectionView: UICollectionView!
 
    var dataProvider: DataProvider!
    
    var hasProducts: Bool {
        return self.products.count > 0
    }
    
    init(collection: BUYCollection, dataProvider: DataProvider) {
        self.collection = collection
        self.dataProvider = dataProvider
    }
    
    func getProducts (completion: @escaping () -> Void) {
        let operation = self.dataProvider.getProducts(collection: self.collection) { (products) in
            self.products = products
            completion()
        }
        self.setCurrentOperation(operation: operation)
    }
}


extension ProductsViewModel: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hasProducts ? self.products.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as! ProductCollectionViewCell
        if hasProducts {
            if let product = self.products[indexPath.row] {
                if let image = product.imagesArray().first {
                    cell.productImage.load(image, animateChange: true, completion: nil)
                } else {
                    cell.productImage.image = UIImage(named: "Placeholder")
                }
                let productItem = ProductItem(images: product.imagesArray())
                let priceString = self.dataProvider.getCurrencyFormatter().string(from: product.minimumPrice)!
                cell.productImage.backgroundColor = UIColor.clear
                cell.configure(item: productItem, price: priceString, title: product.title)

            }
        } else {
            cell.configure(item: ProductItem(images: []), price: "", title: "")
        }
        return cell
    }
}
