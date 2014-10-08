//
//  MasterViewController.h
//  Omoidebase
//


#import <UIKit/UIKit.h>
#import <Couchbaselite/CBLUITableSource.h>

@class CommentViewController;

@interface PlaceViewController : UITableViewController
  <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, QRAuthDelegate, CBLUITableDelegate>

- (IBAction)actionTappedQR:(id)sender;

@property (strong, nonatomic) CommentViewController *commentViewController;
@property NSString *qrcode;
@property (nonatomic) IBOutlet CBLUITableSource* dataSource;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
