//
//  tablereorderAppDelegate.h
//  tablereorder
//
//  Created by Shawn Arney on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class tablereorderViewController;

@interface tablereorderAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet tablereorderViewController *viewController;

@end
