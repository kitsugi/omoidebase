//
//  Profile.h
//  Omoidebase


#import <CouchbaseLite/CouchbaseLite.h>
#import "Master.h"

#define USER_VIEW  @"profiles"
#define USER_TYPE @"profile"

@interface Profile : Master

/**
 * 場所
 */
@property (copy) NSArray *places;

+ (Profile *)find:(NSString *)code error:(NSError **)outError;

@end
