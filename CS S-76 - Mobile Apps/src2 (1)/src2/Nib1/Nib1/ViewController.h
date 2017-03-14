//
//  ViewController.h
//  Nib1
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Single View Application implemented with a nib, plus IBAction and IBOutlet.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *textField;

- (IBAction)go:(id)sender;

@end
