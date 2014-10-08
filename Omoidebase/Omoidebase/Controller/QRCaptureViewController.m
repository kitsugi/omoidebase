//
//  QRViewController.m
//  Omoidebase
//
//  Created by Couchmemories on 2014/09/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import "QRCaptureViewController.h"

@interface QRCaptureViewController ()

@end

@implementation QRCaptureViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

  self.session = [[AVCaptureSession alloc] init];
  
  NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  AVCaptureDevice *device = nil;
  AVCaptureDevicePosition camera = AVCaptureDevicePositionBack; // Back or Front
  for (AVCaptureDevice *d in devices) {
    device = d;
    if (d.position == camera) {
      break;
    }
  }
  
  NSError *error = nil;
  AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device
                                                                      error:&error];
  [self.session addInput:input];
  
  AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
  [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
  [self.session addOutput:output];
  
  // QR コードのみ
  //output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
  
  // 全部認識させたい場合
  // (
  // face,
  // "org.gs1.UPC-E",
  // "org.iso.Code39",
  // "org.iso.Code39Mod43",
  // "org.gs1.EAN-13",
  // "org.gs1.EAN-8",
  // "com.intermec.Code93",
  // "org.iso.Code128",
  // "org.iso.PDF417",
  // "org.iso.QRCode",
  // "org.iso.Aztec"
  // )
  output.metadataObjectTypes = output.availableMetadataObjectTypes;
  
  NSLog(@"%@", output.availableMetadataObjectTypes);
  NSLog(@"%@", output.metadataObjectTypes);
  
  [self.session startRunning];
  
  AVCaptureVideoPreviewLayer *preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
  preview.frame = self.view.bounds;
  preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
  [self.view.layer addSublayer:preview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
  NSLog(@"----");
  for (AVMetadataObject *metadata in metadataObjects) {
    if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {
      // 複数の QR があっても1度で読み取れている
      NSString *qrcode = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
      NSLog(@"%@", qrcode);
      if (self.delegete) {
        if ([self.delegete auth:qrcode]) {
          [self stopReading];
          [self.delegete setQRcode:qrcode];
          [self dismissViewControllerAnimated:YES completion:nil];
        }
      }
      
      
    }
    else if ([metadata.type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
      NSString *ean13 = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
      NSLog(@"%@", ean13);
    }
  }
}

-(void)stopReading{
  [self.session stopRunning];
  self.session = nil;
  
  //[_videoPreviewLayer removeFromSuperlayer];
}

- (IBAction)actionTappedClose:(id)sender
{
  if (self.delegete) {
    [self.delegete setQRcode:@""];
  }
  [self stopReading];
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
