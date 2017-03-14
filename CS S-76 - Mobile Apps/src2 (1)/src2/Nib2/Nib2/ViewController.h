//
//  ViewController.h
//  Nib2
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Single View Application with a UIAlertViewDelegate. 
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *textField;

- (IBAction)go:(id)sender;

@end
