//
//  MasterViewController.h
//  MasterDetail
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Master-Detail Application.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
