

#import "CBLModel+DB.h"

static CBLDatabase *g_database;

@implementation CBLModel (DB)

- (DBManager *)dbMgr
{
  return [DBManager sharedManager];
}

- (CBLDatabase *)database
{
  return g_database;
}

+ (void)setDatabase:(CBLDatabase *)database
{
  g_database = database;
}

+ (CBLDatabase *)database
{
  return g_database;
}

@end
