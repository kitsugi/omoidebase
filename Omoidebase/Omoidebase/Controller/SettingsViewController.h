//
//  SettingsViewController.h
//  Omoidebase
//
//  Created by Couchmemories on 2014/09/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController
  <UITextFieldDelegate>
- (IBAction)actionTappedDone:(id)sender;
- (IBAction)actionTappedCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *user;
@property (weak, nonatomic) IBOutlet UITextField *password;

@end
