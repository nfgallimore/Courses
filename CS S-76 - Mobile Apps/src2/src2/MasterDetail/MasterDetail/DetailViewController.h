//
//  DetailViewController.h
//  MasterDetail
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Master-Detail Application.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) id detailItem;

@end
