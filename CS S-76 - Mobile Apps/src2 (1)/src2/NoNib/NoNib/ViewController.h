//
//  ViewController.h
//  NoNib
//
//  David J. Malan
//  Harvard University
//  malan@harvard.edu
//
//  Demonstrates a Single View Application with a view implemented without a nib (or storyboard).
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic, readwrite, strong) UITextField *textField;

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)go:(id)sender;

@end
