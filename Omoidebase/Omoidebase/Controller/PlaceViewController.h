//
//  MasterViewController.h
//  Omoidebase
//


#import <UIKit/UIKit.h>
#import <CouchbaseLite/CouchbaseLite.h>
#import <Couchbaselite/CBLUITableSource.h>
#import "SettingsDelegate.h"

@class CommentViewController;

@interface PlaceViewController : UITableViewController
  <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QRAuthDelegate, CBLUITableDelegate, SettingsDelegate>

- (IBAction)actionTappedQR:(id)sender;
- (IBAction)actionTappedSettings:(id)sender;

@property (strong, nonatomic) CommentViewController *commentViewController;
@property NSString *qrcode;
@property (nonatomic) IBOutlet CBLUITableSource* dataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
