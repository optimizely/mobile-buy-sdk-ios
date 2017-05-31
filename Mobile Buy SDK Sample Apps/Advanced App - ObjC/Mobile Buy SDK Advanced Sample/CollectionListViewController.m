//
//  CollectionListViewController.m
//  Mobile Buy SDK Advanced Sample
//
//  Created by Shopify.
//  Copyright (c) 2015 Shopify Inc. All rights reserved.
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

@import Buy;

#import "AppDelegate.h"
#import <OptimizelySDKiOS/OptimizelySDKiOS.h>
#import "CollectionListViewController.h"
#import "Credentials.h"
#import "ProductViewController.h"
#import "ProductListViewController.h"

@interface CollectionListViewController ()

@property (nonatomic, strong) BUYClient *client;
@property (nonatomic, strong) NSArray *collections;

@end

@implementation CollectionListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
    NSString *controllersCTAExperimentKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyControllersCtaExperimentKey"];
    NSString *userAttributesString = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyUserAttributes"];
    NSData *userAttributesData = [userAttributesString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *userAttributesDict = nil;
    if (userAttributesData) {
        userAttributesDict = [NSJSONSerialization JSONObjectWithData:userAttributesData options:nil error:nil];
    }
    OPTLYVariation *variation = [appDelegate.client variation:controllersCTAExperimentKey
                                                       userId:appDelegate.userId
                                                   attributes:userAttributesDict];
    NSString *title = @"Collections Control";
    if (variation) {
        if ([variation.variationKey isEqualToString:@"control"]) {
            // default text already set
        } else if ([variation.variationKey isEqualToString:@"variation_a"]) {
            title = @"Collections Variation A";
        } else if ([variation.variationKey isEqualToString:@"variation_b"]) {
            title = @"Collections Variation B";
        }
    }
    
    self.navigationController.navigationBar.topItem.title = title;
    self.navigationController.navigationBar.topItem.accessibilityValue = title;
//    self.navigationController.navigationBar.topItem.titleView.accessibilityIdentifier = @"collections_table_view_title";
    self.view.accessibilityIdentifier = @"collections_table_view_title";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.client = [[BUYClient alloc] initWithShopDomain:SHOP_DOMAIN
                                                 apiKey:API_KEY
                                                  appId:APP_ID];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.client getCollectionsPage:1 completion:^(NSArray *collections, NSUInteger page, BOOL reachedEnd, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (error == nil && collections) {
            self.collections = collections;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error fetching products: %@", error);
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 1:
            return [self.collections count];
            break;
        default:
            return 1;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.section) {
        case 1: {
            BUYCollection *collection = self.collections[indexPath.row];
            cell.textLabel.text = collection.title;
            cell.accessibilityIdentifier = [NSString stringWithFormat:@"collection_list_item_%ld", indexPath.row];
        }
            break;
        default:
            cell.textLabel.text = @"All products (no collection)";
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BUYCollection *collection = nil;
    if (indexPath.section == 1) {
        collection = self.collections[indexPath.row];
    }
    ProductListViewController *productListViewController = [[ProductListViewController alloc] initWithClient:self.client collection:collection];
    [self.navigationController pushViewController:productListViewController animated:YES];
}

- (void)restoreUserActivityState:(NSUserActivity *)activity
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    NSNumber *productId = activity.userInfo[@"product"];
    
    if (productId) {
        [self.client getProductById:productId completion:^(BUYProduct * _Nullable product, NSError * _Nullable error) {
            if (!error) {
                Theme *theme = [Theme new];
                theme.style = ThemeStyleLight;
                theme.tintColor = [UIColor colorWithRed:0.48f green:0.71f blue:0.36f alpha:1.0f];
                theme.showsProductImageBackground = YES;
                ProductViewController *productViewController = [[ProductViewController alloc] initWithClient:self.client theme:theme];
                productViewController.merchantId = MERCHANT_ID;
                [productViewController loadWithProduct:product completion:^(BOOL success, NSError *error) {
                    if (error == nil) {
                        [self.navigationController pushViewController:productViewController animated:YES];
                    }
                }];
            }
        }];
    }
}

@end
