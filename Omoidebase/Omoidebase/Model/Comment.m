//
//  Comment.m
//  Omoidebase
//
//  Created by 木次 恭一 on 2014/10/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import "Comment.h"

@implementation Comment

@dynamic place;
@dynamic created_at;
@dynamic contents;
@dynamic image;

#pragma mark -
#pragma mark init
/**
 * イニシャライザ。
 *
 * @return  初期化済みのインスタンス
 */
- (id)init:(NSString *)place
{
  self = [super init];

  if (self) {
    self.type = COMMENT_TYPE;
    self.place = place;
  }

  return self;
}

#pragma mark -
#pragma mark Class Methods
/**
 * 場所一覧を取得します。
 *
 * @param outError  エラー情報
 * @return  場所一覧
 */
+ (CBLQuery *)findByPlace:(NSString *)code error:(NSError **)outError
{
  NSParameterAssert(self.database);
  
  CBLQuery *query = [[self getView] createQuery];
  query.startKey = @[code];
  query.endKey = @[code, @{}];

  return query;
}

/**
 * ビューを取得します。
 *
 * @return ビュー
 */
+ (CBLView *)getView
{
  CBLView *view = [self.database viewNamed:COMMENT_VIEW];
  //  if (view && view.mapBlock) {
  //    return view;
  //  }
  
  [view setMapBlock: MAPBLOCK({
    if ([COMMENT_TYPE isEqualToString:doc[@"type"]]) {
      emit(@[doc[@"place"], doc[@"created_at"]], doc);
    }
  }) version: @"1.0"];

  return view;
}
@end
