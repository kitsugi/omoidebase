//
//  CommentViewController.m
//  Omoidebase
//
//  Created by Couchmemories on 2014/09/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController ()

@end

@implementation CommentViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = self.place.name;

  NSError *error = nil;
  CBLQuery *query = [Comment findByPlace:self.place.code error:&error];

  if (_dataSource) {
    _dataSource.query = query.asLiveQuery;
    _dataSource.query.descending = NO;
    _dataSource.tableView = self.tableView;
  }
}


#pragma mark - Table view data source
- (void)couchTableSource:(CBLUITableSource*)source
         updateFromQuery:(CBLLiveQuery*)query
            previousRows:(NSArray *)previousRows
{
  [self.tableView reloadData];
}

- (UITableViewCell *) couchTableSource:(CBLUITableSource *)source
                 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CommentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
  
  CBLQueryRow *queryRow =  [source rowAtIndex:indexPath.row];
  Comment *comment = [Comment modelForDocument:queryRow.document];

  NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"MMM dd, yyyy HH:mm"];
  formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
  cell.created_at.text = [formatter stringFromDate:comment.created_at];
  
  cell.contents.text = comment.contents;

  if (comment.image) {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:comment.image options:NSDataBase64DecodingIgnoreUnknownCharacters];
    if (data) {
      UIImage *img = [[UIImage alloc] initWithData:data];
      [cell.image setImage:img];
    }
  }

  return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if ([[segue identifier] isEqualToString:@"entry"]) {
    UINavigationController *navi = [segue destinationViewController];
    EntryViewController *ctrl = [navi.viewControllers objectAtIndex:0];
    ctrl.place = self.place;
  }
}
@end
