
#import <CouchbaseLite/CouchbaseLite.h>

@class DBManager;

@interface CBLModel (DB)

// Properties
@property (readonly, strong, nonatomic) DBManager *dbMgr;
@property (readonly, strong, nonatomic) CBLDatabase *database;

+ (void)setDatabase:(CBLDatabase *)database;
+ (CBLDatabase *)database;

@end
