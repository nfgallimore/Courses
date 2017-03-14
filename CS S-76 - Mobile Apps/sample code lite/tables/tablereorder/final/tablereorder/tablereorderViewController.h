//
//  tablereorderViewController.h
//  tablereorder
//
//  Created by Shawn Arney on 9/26/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tablereorderViewController : UITableViewController

@property (nonatomic, retain)  NSMutableArray *fruit;
- (IBAction)editButtonSelected:(id)sender;

@end
