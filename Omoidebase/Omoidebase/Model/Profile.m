//
//  Profile.m
//  Omoidebase
//


#import "Profile.h"

@implementation Profile

@dynamic places;

/**
 * コードを指定してユーザー情報を取得します。
 *
 * @param code  コード
 * @param outError  エラー情報
 * @return  ユーザー情報
 */
+ (Profile *)find:(NSString *)code error:(NSError **)outError
{
  NSParameterAssert(self.database);
  
  CBLQuery *query = [[self getView] createQuery];
  query.keys = @[code];
  CBLQueryEnumerator *rows = [query run:outError];
  if (*outError) {
    return nil;
  }
  if (rows.count > 0) {
    CBLQueryRow *row = [rows rowAtIndex:0];
    return [Profile modelForDocument:row.document];
  }
  
  return nil;
}

#pragma mark -
#pragma mark Private Methods
/**
 * ビューを取得します。
 *
 * @return ビュー
 */
+ (CBLView *)getView
{
  CBLView *view = [self.database viewNamed:USER_VIEW];
  if (view && view.mapBlock) {
    return view;
  }
  
  [view setMapBlock: MAPBLOCK({
    if ([USER_TYPE isEqualToString:doc[@"type"]]) {
      emit(doc[@"name"], doc);
    }
  }) version: @"1.0"];
  
  return view;
}
@end
