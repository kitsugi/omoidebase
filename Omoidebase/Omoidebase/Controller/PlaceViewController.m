//
//  MasterViewController.m
//  Omoidebase
//


#import "PlaceViewController.h"
#import "DetailViewController.h"
#import "PlaceCell.h"

@implementation PlaceViewController

- (void)awakeFromNib
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
      self.clearsSelectionOnViewWillAppear = NO;
      self.preferredContentSize = CGSizeMake(320.0, 600.0);
  }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
  barButton.title = @"Back";
  self.navigationItem.backBarButtonItem = barButton;

  
  NSError *error = nil;
  CBLQuery *query = [Place findAll:&error];

  if (_dataSource) {
    _dataSource.query = query.asLiveQuery;
    _dataSource.query.descending = NO;
    _dataSource.tableView = self.tableView;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  CBLQueryRow *row = [self.dataSource rowAtIndex:indexPath.row];
  Place *place = [Place modelForDocument: row.document];

  CommentViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"comment"];
  ctrl.place = place;
  
  // 画面遷移
  [self.navigationController pushViewController:ctrl animated:YES];
}

/*
 * QRコードメニュー
 */
- (IBAction)actionTappedQR:(id)sender
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

- (IBAction)actionTappedSettings:(id)sender
{
  SettingsViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"settings"];
  ctrl.delegate = self;
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ctrl];
  [self presentViewController:navi animated:YES completion: nil];
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
  if (buttonIndex == 0) {
    // カメラ起動
    QRCaptureViewController *ctrl = [self.storyboard instantiateViewControllerWithIdentifier:@"qrcapture"];
    ctrl.delegete = self;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:ctrl];
    [self presentViewController:navi animated:YES completion: nil];
  } else if (buttonIndex == 1) {
    // ライブラリ
    UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
    ctrl.allowsEditing = NO;
    ctrl.delegate = self;
    ctrl.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ctrl  animated:YES completion: nil];
  }
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
  
  NSString *qrcode = @"2C139CE5-9B5D-4836-97A3-B25AEC49D6FB";
  [self setQRcode:qrcode];
  
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

- (BOOL)auth:(NSString *)qrcode
{
  qrcode = @"a0261b89-3344-4626-b6c9-8232f916d969";

  // TODO
  if (!(qrcode == Nil || qrcode.length <= 0)) {
    if (qrcode.length == 36) {
      return YES;
    }
  }
  
  return NO;
}

- (void)setQRcode:(NSString *)qrcode
{
  NSError *error = nil;

  if (!(qrcode == Nil || qrcode.length <= 0)) {
    
    
    self.qrcode = qrcode;
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *uid = [userDefaults stringForKey:@"uid"];
    if (uid == Nil || uid.length <= 0) {
      return;
    }
    
    Profile *user = [Profile find:uid error:&error];
    if (user) {
      NSMutableArray *items = [NSMutableArray arrayWithArray:user.places];
      [items addObject:qrcode];
      user.places = items;
      [user save:&error];

    }
    
    
  } else {
    self.qrcode = @"";
  }
}

-(void)change
{
  [self.tableView reloadData];

  NSError *error = nil;
  DBManager *mgr = [DBManager sharedManager];
  [mgr stop];
  [mgr clean];
  [mgr start:&error];
  
  CBLQuery *query = [Place findAll:&error];
  
  if (_dataSource) {
    _dataSource.query = query.asLiveQuery;
    _dataSource.query.descending = NO;
    _dataSource.tableView = self.tableView;
  }
}

- (void)couchTableSource:(CBLUITableSource*)source
         updateFromQuery:(CBLLiveQuery*)query
            previousRows:(NSArray *)previousRows
{
  [self.tableView reloadData];
}

- (UITableViewCell *) couchTableSource:(CBLUITableSource *)source
                 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  PlaceCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  CBLQueryRow *queryRow =  [source rowAtIndex:indexPath.row];
  Place *area = [Place modelForDocument:queryRow.document];
  
  cell.name.text = area.name;
  cell.remark.text = area.remark;
  
  NSData *data = [[NSData alloc] initWithBase64EncodedString:area.image options:NSDataBase64DecodingIgnoreUnknownCharacters];
  if (data) {
    UIImage *img = [[UIImage alloc] initWithData:data];
    [cell.image setImage:img];
  }
  
  return cell;
  
}
@end
