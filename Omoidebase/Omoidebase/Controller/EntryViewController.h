//
//  EntryViewController.h
//  Omoidebase
//
//  Created by 木次 恭一 on 2014/10/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EntryViewController : UIViewController
  <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic) Place *place;
@property (weak, nonatomic) IBOutlet UITextView *contents;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)actionTappedDone:(id)sender;
- (IBAction)actionTappedCancel:(id)sender;
- (IBAction)actionTappedAddPhoto:(id)sender;

@end
