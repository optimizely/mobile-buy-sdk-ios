//
//  AppDelegate.m
//  Mobile Buy SDK Advanced Sample
//
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

#import <OptimizelySDKiOS/OptimizelySDKiOS.h>
#import "AppDelegate.h"
#import "CheckoutViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // ---- Initialize Optimizely ----
    self.optlyManager = [OPTLYManager init:^(OPTLYManagerBuilder * _Nullable builder) {
        
        builder.projectId = @"8356170303"; //ShopifyManualTestingObjCSDK
        
        // ---- Object Manager Initialization ----
        // check that the modules are set properly
        // Custom Logger
        builder.logger = [[OPTLYLoggerDefault alloc] initWithLogLevel:OptimizelyLogLevelDebug];
        // Custom Error Handler
        //builder.errorHandler = [OPTLYErrorHandlerDefault new];
        // Custom Event Dispatcher
        //builder.eventDispatcher = [OPTLYEventDispatcherNoOp new];
        // Custom User Profile
        //builder.userProfile = [OPTLYUserProfileNoOp new];
        // Custom Datafile Manager
        //builder.datafileManager = [OPTLYDatafileManagerNoOp new];
        
    }];
    
    
    [self.optlyManager initializeWithCallback:^(NSError * _Nullable error, OPTLYClient * _Nullable client) {
        
//        OPTLYVariation *variation = [client activate:@"ColorThemeExperiment" userId:@"alda" attributes:@{@"buyerType":@"frequent"}];
//        
//        NSLog(@"*********** User was bucketed into %@ variation. ***********", variation.variationKey);
        
        // Activate invalid experiment
        //OPTLYVariation *variation = [client activate:@"invalidExperiment" userId:@"alda"];
        
        // Activate no audience, no user attributes
        //OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda1"];
        
        // Activate with audience off, user attributes
        //OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda2" attributes:@{@"abc":@"123"}];
        
        // Activate with audience on, user attributes match (variations: ewa_var1, ewa_var2)
        //OPTLYVariation *variation = [client activate:@"ExperimentWithAudience" userId:@"alda3" attributes:@{@"testAttribute1":@"testAttributeValue1"}];
        
        // Activate with audience on, user attributes no match
        //OPTLYVariation *variation = [client activate:@"ExperimentWithAudience" userId:@"alda4" attributes:@{@"testAttribute1":@"testAttributeValueBad"}];
        
        // Activate with invalid attribute (not in datafile)
        //OPTLYVariation *variation = [client activate:@"ExperimentWithAudience" userId:@"alda5" attributes:@{@"abc":@"123"}];
        //OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda6" attributes:@{@"abc":@"123"}];
        
        // Activate experiment in group (variation: ega_var1, ega_var2)
        // * Confirm that either ExperimentInGroupA_1 or ExperimentInGroupA_2 is bucketed
        // * The experiment is bucketed according to the group and user id
        //OPTLYVariation *variation = [client activate:@"ExperimentInGroupA_1" userId:@"alda7"];
        // (variation: ega_var3, ega_var4)
        //OPTLYVariation *variation = [client activate:@"ExperimentInGroupA_2" userId:@"alda7"];
    
        // Whitelisted, user in group (ena_var1)
        //OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda8"];
        
        //Track invalid event
        //[client track:@"blah" userId:@"alda9"];
        
        //Track valid event, whitelisted user (in "ExperimentNoAudience")
        //OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda8"];
        //[client track:@"testEvent1" userId:@"alda8"];
        
        //Track valid event, whitelisted user (in "ExperimentNoAudience") with revenue
//        OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda8"];
//        [client track:@"testEvent1" userId:@"alda8" eventValue:@500]; // --> this API will be deprecated
//        [client track:@"testEvent1" userId:@"alda8" eventTags:@{@"revenue":@123, @"testEvent1":@"aldaEventTagValue1"}];
        
        //Track valid event with revenue
//        OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda12"];
//        NSLog(@"bucketed variation: %@", variation.variationKey);
//        [client track:@"testEvent1" userId:@"alda12" eventValue:@500]; // --> this API will be deprecated
//        [client track:@"testEvent1" userId:@"alda12" eventTags:@{@"revenue":@123, @"testEvent1":@"aldaEventTagValue1"}];
        
        //Track experiment in group
//        OPTLYVariation *variation = [client activate:@"ExperimentInGroupA_1" userId:@"alda13"];
//        NSLog(@"bucketed variation 1: %@", variation.variationKey);
//        variation = [client activate:@"ExperimentInGroupA_2" userId:@"alda13"];
//        NSLog(@"bucketed variation 2: %@", variation.variationKey);
//        [client track:@"testEventExperimentInGroup" userId:@"alda13"];
        
        //Track with audience off, user attributes (variation1)
//        OPTLYVariation *variation = [client activate:@"ExperimentNoAudience" userId:@"alda14" attributes:@{@"device_type":@"blah"}];
//        [client track:@"testEvent1" userId:@"alda14" attributes:@{@"device_type":@"blah"}];
        
        //Track with audience on, user attributes match
//        OPTLYVariation *variation = [client activate:@"ExperimentWithAudience" userId:@"alda15" attributes:@{@"testAttribute1":@"testAttributeValue1"}];
//        NSLog(@"bucketed variation: %@", variation.variationKey);
//        [client track:@"testEvent1" userId:@"alda15" attributes:@{@"testAttribute1":@"testAttributeValue1"}];
        
         // Track with invalid attribute (not in datafile)
        OPTLYVariation *variation = [client activate:@"ExperimentWithAudience" userId:@"alda23" attributes:@{@"testAttribute1":@"testAttributeValue1"}];
        //NSLog(@"bucketed variation: %@", variation.variationKey);
        [client track:@"testEvent1" userId:@"alda23" attributes:@{@"blah":@"ios"}];
        
        //Track with audience on, user attributes no match
//        OPTLYVariation *variation = [client activate:@"ExperimentWithAudience" userId:@"alda17" attributes:@{@"testAttribute1":@"testAttributeValue1"}];
//        NSLog(@"bucketed variation: %@", variation.variationKey);
        //[client track:@"testEvent1" userId:@"alda17" attributes:@{@"testAttribute1":@"123"}];
        
        
        // ---- Get Variation ----
        // Get Variation valid experiment (variation1)
        //OPTLYVariation *variation = [client variation:@"experimentNoAudience" userId:@"alda"];
        //NSLog(@"get variation 1: %@", variation.variationKey);
        
        // Invalid experiment (null)
        //variation = [client variation:kExperimentInvalid userId:kUserID];
        //NSLog(@"get variation 2: %@", variation.variationKey);
        
        // Activate with audience off, user attributes (default)
        //variation = [client variation:kExperimentNoAudience userId:@"alda1" attributes:@{@"abc":@"123"}];
        //NSLog(@"get variation 3: %@", variation.variationKey);
        
        // Activate with audience on, user attributes match (aud_exp_2)
        //variation = [client variation:kExperimentUsingAudience userId:@"alda1" attributes:@{@"device_type":@"android"}];
        //NSLog(@"get variation 4: %@", variation.variationKey);
        
        // Activate with audience on, user attributes no match (null)
        //variation = [client variation:kExperimentUsingAudience userId:@"alda2" attributes:@{@"invalidKey":@"invalidValue"}];
        //NSLog(@"get variation 5: %@", variation.variationKey);
        //variation = [client variation:kExperimentUsingAudience userId:@"alda2" attributes:@{@"device_type":@"invalidValue2"}];
        //NSLog(@"get variation 6: %@", variation.variationKey);
        
        // Activate with invalid attribute (not in datafile) (variation1)
        //variation = [client variation:kExperimentNoAudience userId:@"alda3" attributes:@{@"abc":@"123"}];
        //NSLog(@"get variation 7: %@", variation.variationKey);
        
        // Activate experiment in group (exp_grp_var_1)
        //variation = [client variation:kExperimentInGroup userId:@"alda5"];
        //NSLog(@"get variation 8: %@", variation.variationKey);
        
        // Whitelisted, user in group (exp_grp_var_1)
        //variation = [client variation:kExperimentInGroup userId:@"vigraja"];
        //NSLog(@"get variation 9: %@", variation.variationKey);
        
        // Whitelisted, audience on (aud_exp_1)
        //variation = [client variation:kExperimentUsingAudience userId:@"aliriz"];
        //NSLog(@"get variation 10: %@", variation.variationKey);
        
        //NSLog(@"bucketed variation: %@", variation);
    }];
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CheckoutCallbackNotification object:nil userInfo:@{@"url": url}];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//@"8174444717";
//
//self.optlyManager = [OPTLYManager init:^(OPTLYManagerBuilder * _Nullable builder) {
//    builder.projectId = @"8174444717";
//    // Custom Logger
//    builder.logger = [[OPTLYLoggerNoOp alloc] initWithLogLevel:OptimizelyLogLevelDebug];
//    // Custom Error Handler
//    builder.errorHandler = [OPTLYErrorHandlerDefault new];
//    // Custom Event Dispatcher
//    builder.eventDispatcher = [OPTLYEventDispatcherNoOp new];
//    // Custom User Profile
//    builder.userProfile = [OPTLYUserProfileNoOp new];
//    // Custom Datafile Manager
//    builder.datafileManager = [OPTLYDatafileManagerNoOp new];
//}];

@end
