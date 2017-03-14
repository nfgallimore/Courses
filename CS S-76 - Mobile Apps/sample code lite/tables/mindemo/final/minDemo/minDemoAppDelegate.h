//
//  minDemoAppDelegate.h
//  minDemo
//
//  Created by Shawn Arney on 9/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class minDemoViewController;

@interface minDemoAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet minDemoViewController *viewController;

@end
