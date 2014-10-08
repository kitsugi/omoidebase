//
//  QRViewController.h
//  Omoidebase
//
//  Created by Couchmemories on 2014/09/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "QRAuthDelegate.h"

@interface QRCaptureViewController : UIViewController
  <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *session;
@property id<QRAuthDelegate> delegete;
- (IBAction)actionTappedClose:(id)sender;

@end
