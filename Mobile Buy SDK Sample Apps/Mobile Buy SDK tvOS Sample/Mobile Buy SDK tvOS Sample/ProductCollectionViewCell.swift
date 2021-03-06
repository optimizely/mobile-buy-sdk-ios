//
//  ProductCollectionViewCell.swift
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

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ProductCollectionViewCell"
    
    @IBOutlet weak var productImage: AsyncImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    var productItem:ProductItem!
    
    override func awakeFromNib() {
        self.productImage.adjustsImageWhenAncestorFocused = true
        self.productImage.clipsToBounds = false
        
        self.productTitleLabel.alpha = 0
        self.productPriceLabel.alpha = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.productTitleLabel.alpha = 0
        self.productPriceLabel.alpha = 0
        self.productImage.cancelImageTask()
        self.productImage.image = nil
    }
    
    func configure(item: ProductItem, price: String, title: String) {
        self.productItem = item
        self.productPriceLabel.text = price
        self.productTitleLabel.text = title
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
        	self.productTitleLabel.alpha = self.isFocused ? 1.0 : 0.0
        	self.productPriceLabel.alpha = self.isFocused ? 1.0 : 0.0
        }, completion: nil)
    }
}
