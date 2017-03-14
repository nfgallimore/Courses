//
//  FoundationAppDelegate.h
//  Foundation
//
//  Created by Shawn Arney on 9/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FoundationViewController;

@interface FoundationAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet FoundationViewController *viewController;

@end
