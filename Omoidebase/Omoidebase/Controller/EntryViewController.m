//
//  EntryViewController.m
//  Omoidebase
//
//  Created by 木次 恭一 on 2014/10/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import "EntryViewController.h"

@interface EntryViewController ()

@end

@implementation EntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)actionTappedDone:(id)sender
{
  NSError *error = nil;
  Comment *doc = [[Comment alloc] init:self.place.code];

  doc.created_at = [NSDate date];
  doc.contents = self.contents.text;

  if (self.imageView.image) {
    UIImage *image = self.imageView.image;
    CGSize newSize = CGSizeMake(320, 320);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* jpgData = [[NSData alloc] initWithData:UIImageJPEGRepresentation(newImage, 1.0f)];
    NSString* jpg64Str = [jpgData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    doc.image = jpg64Str;
  }

  [doc save:&error];
  
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionTappedCancel:(id)sender
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)actionTappedAddPhoto:(id)sender
{
  UIActionSheet *sheet = [[UIActionSheet alloc] init];
  sheet.tag = 1;
  sheet.delegate = self;
  sheet.cancelButtonIndex = 2;
  
  [sheet addButtonWithTitle:@"Take Photo"];
  [sheet addButtonWithTitle:@"Choose Photo"];
  [sheet addButtonWithTitle:@"Cancel"];
  
  [sheet showInView:self.view];
}

/**
 * アクションシートのボタンがタップされた時のデリゲートメソッドです。
 *
 * @param actionSheet アクションシート
 * @param buttonIndex ボタン番号
 */
- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex
{
  UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
  ctrl.allowsEditing = YES;
  ctrl.delegate = self;

  if (buttonIndex == 0) {
    // カメラ起動

  } else if (buttonIndex == 1) {
    // ライブラリ
    ctrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
  }

  [self presentViewController:ctrl  animated:YES completion: nil];
}

/**
 * 選択
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
  UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
  if (!image) {
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
  }
  UIGraphicsBeginImageContext(image.size);
  [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
  image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  self.imageView.image = image;

  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:NULL];
}

/**
 * 閉じる
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
  // モーダルビューを閉じる
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
