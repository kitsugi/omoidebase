//
//  Place.h
//  Omoidebase


#import <CouchbaseLite/CouchbaseLite.h>
#import "Master.h"

#define AREA_VIEW  @"areas"
#define AREA_TYPE @"place"

@interface Place : Master

/**
 * 補足
 */
@property NSString *remark;

/**
 * 画像
 */
@property NSString *image;

/**
 * 場所一覧を取得します。
 *
 * @param outError  エラー情報
 * @return  場所一覧
 */
+ (CBLQuery *)findAll:(NSError **)outError;

@end
