//
//  TESTJSONModel.h
//  Mobile Buy SDK Advanced Sample
//
//  Created by Alda Luong on 3/25/17.
//  Copyright © 2017 Shopify. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol TESTJSONModel
@end

@interface TESTJSONModel : JSONModel
    
/// The attribute id
@property (nonatomic, strong) NSString *modelID;
/// The attribute key (name)
@property (nonatomic, strong) NSString *modelKey;

@end

