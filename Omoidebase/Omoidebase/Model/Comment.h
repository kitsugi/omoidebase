//
//  Comment.h
//  Omoidebase
//
//  Created by 木次 恭一 on 2014/10/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import "Document.h"

#define COMMENT_VIEW  @"comments"
#define COMMENT_TYPE @"comment"

@interface Comment : Document

/**
 * 場所
 */
@property NSString *place;

/**
 * 作成日時
 */
@property NSDate *created_at;

/**
 * 名称
 */
@property NSString *contents;

/**
 * 画像
 */
@property NSString* image;

- (id)init:(NSString *)place;
+ (CBLQuery *)findByPlace:(NSString *)code error:(NSError **)outError;
@end
