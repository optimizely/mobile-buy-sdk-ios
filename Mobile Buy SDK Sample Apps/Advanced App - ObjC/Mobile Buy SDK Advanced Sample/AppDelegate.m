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

#import "AppDelegate.h"
#import "CheckoutViewController.h"
#import <OptimizelySDKiOS/OptimizelySDKiOS.h>

@interface AppDelegate ()
@property(nonatomic, strong, readwrite) OPTLYClient *client;
@property(nonatomic, strong, readwrite) NSString *userId;
@property(nonatomic, strong, readwrite) NSString *experimentKey;
@property(nonatomic, strong, readwrite) NSString *route;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // [OPTLY - Doc] For E2E testing purposes we inject the userId and projectId via NSUserDefaults
    self.userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyUserId"];
    if (!self.userId) {
        // [OPTLY - Doc] Add user here for local testing
        self.userId = @"";
    }
    
    NSString *projectId = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyProjectId"];
    if (!projectId) {
        // [OPTLY - Doc] Add project ID here for local testing
        projectId = @"";
    }
    
    self.experimentKey = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyCheckoutCtaExperimentKey"];
    
    OPTLYUserProfileServiceDefault *userProfileService = [OPTLYUserProfileServiceDefault init:^(OPTLYUserProfileServiceBuilder *builder) {
        builder.logger = [[OPTLYLoggerDefault alloc] initWithLogLevel:OptimizelyLogLevelAll];
    }];
    
    // [OPTLY - Doc] Initialize the Optimizely Manager and Optimizely Client (async)
    OPTLYManager *optlyManager = [OPTLYManager init:^(OPTLYManagerBuilder * _Nullable builder) {
        builder.projectId = projectId;
        builder.logger = [[OPTLYLoggerDefault alloc] initWithLogLevel:OptimizelyLogLevelAll];
        builder.userProfileService = userProfileService;
    }];
    
    NSString *initializationMode = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyInitMode"];
    if ([initializationMode isEqualToString:@"sync_no_datafile"]) {
        self.client = [optlyManager initialize];
    } else if ([initializationMode isEqualToString:@"sync_datafile"]) {
        NSString *datafile = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyDatafile"];
        NSData *data = [datafile dataUsingEncoding:NSUTF8StringEncoding];
        self.client = [optlyManager initializeWithDatafile:data];
        
    // --- Special initialization mode for the User Profile Service tests ----
    } else if ([initializationMode isEqualToString:@"sync_async_datafile"]) {
        // Activate synchronously with a given datafile
        // The user profile should persist the variation in the saved datafile (include_fake_text)
        OPTLYManager *optlyManagerForSavedDatafile = [OPTLYManager init:^(OPTLYManagerBuilder * _Nullable builder) {
            builder.projectId = projectId;
            builder.logger = [[OPTLYLoggerDefault alloc] initWithLogLevel:OptimizelyLogLevelAll];
            builder.userProfileService = userProfileService;
        }];
        
        NSString *datafile = [[NSUserDefaults standardUserDefaults] stringForKey:@"optlyDatafile"];
        NSData *data = [datafile dataUsingEncoding:NSUTF8StringEncoding];
        OPTLYClient *clientFromSavedDatafile = [optlyManagerForSavedDatafile initializeWithDatafile:data];
        OPTLYVariation *variationFromSavedDatafile = [clientFromSavedDatafile activate:self.experimentKey userId:self.userId];
        
        // Activate asynchronously with a CDN Datafile
        // Different datafile should not change the bucketed value
        OPTLYManager *optlyManagerForAsyncDatafile = [OPTLYManager init:^(OPTLYManagerBuilder * _Nullable builder) {
            builder.projectId = projectId;
            builder.logger = [[OPTLYLoggerDefault alloc] initWithLogLevel:OptimizelyLogLevelAll];
            builder.userProfileService = userProfileService;
        }];
        
        [optlyManagerForAsyncDatafile initializeWithCallback:^(NSError * _Nullable error, OPTLYClient * _Nullable client) {
            self.client = client;
            OPTLYVariation *variation = [self.client activate:self.experimentKey userId:self.userId];
        }];
    } else {
        [optlyManager initializeWithCallback:^(NSError * _Nullable error, OPTLYClient * _Nullable client) {
            self.client = client;
        }];
    }
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:CheckoutCallbackNotification object:nil userInfo:@{@"url": url}];
    
    NSMutableDictionary *queryStrings = [[NSMutableDictionary alloc] init];
    for (NSString *qs in [url.query componentsSeparatedByString:@"&"]) {
        // Get the parameter name
        NSString *key = [[qs componentsSeparatedByString:@"="] objectAtIndex:0];
        // Get the parameter value
        NSString *value = [[qs componentsSeparatedByString:@"="] objectAtIndex:1];
        value = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        queryStrings[key] = value;
    }
    for (id key in queryStrings) {
        NSLog(@"key: %@, value: %@ \n", key, [queryStrings objectForKey:key]);
    }
    NSString *url_str = url.absoluteString;
    NSRange r1 = [url_str rangeOfString:@"//"];
    NSRange r2 = [url_str rangeOfString:@"?"];
    NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
    NSString *sub = [url_str substringWithRange:rSub];
    
    self.userId = queryStrings[@"user_id"];
    self.experimentKey = queryStrings[@"experiment_key"];
    self.route = sub;
    
    /*OPTLYManager *optlyManager = [OPTLYManager init:^(OPTLYManagerBuilder * _Nullable builder) {
        builder.projectId = projectId;
        builder.logger = [[OPTLYLoggerDefault alloc] initWithLogLevel:OptimizelyLogLevelAll];
        builder.userProfileService = userProfileService;
    }];
    
    NSString *string1 = @"activate";
    if ([self.route compare:string1] == NSOrderedSame) {
        [optlyManagerForAsyncDatafile initializeWithCallback:^(NSError * _Nullable error, OPTLYClient * _Nullable client) {
            self.client = client;
            OPTLYVariation *variation = [self.client activate:self.experimentKey userId:self.userId];
        }];
    }*/
    
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    UIViewController *rootViewController = self.window.rootViewController;
    [rootViewController.childViewControllers.firstObject restoreUserActivityState:userActivity];
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

@end
