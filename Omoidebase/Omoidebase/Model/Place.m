//
//  Place.m
//  Omoidebase
//


#import "Place.h"

@implementation Place

@dynamic remark;
@dynamic image;

#pragma mark -
#pragma mark Class Methods
/**
 * 場所一覧を取得します。
 *
 * @param outError  エラー情報
 * @return  場所一覧
 */
+ (CBLQuery *)findAll:(NSError **)outError
{
  NSParameterAssert(self.database);
  
  return [[self getView] createQuery];
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
  CBLView *view = [self.database viewNamed:AREA_VIEW];
  if (view && view.mapBlock) {
    return view;
  }
  
  [view setMapBlock: MAPBLOCK({
    if ([AREA_TYPE isEqualToString:doc[@"type"]]) {
      emit(doc[@"code"], doc);
    }
  }) version: @"1.0"];
  
  return view;
}
@end
