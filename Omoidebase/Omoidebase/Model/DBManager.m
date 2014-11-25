

#import "DBManager.h"
#import "Document.h"
#import <CouchbaseLite/CouchbaseLite.h>

//###########################################################################
/// データベース管理クラス
//###########################################################################
@implementation DBManager

__strong static DBManager* sharedInstance = nil;

#pragma mark -
#pragma mark Class Methods
+ (DBManager *)sharedManager
{
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    sharedInstance = [[DBManager alloc] initSharedInstance];
  });

  return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone
{
  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{
    sharedInstance = [super allocWithZone:zone];
  });

  return sharedInstance;
}

#pragma mark -
#pragma mark Instance Methods
- (id)copyWithZone:(NSZone *)zone
{
  return self;
}

- (id)initSharedInstance
{
  self = [super init];
  if (self) {
    self.database = nil;
    //self.user = nil;
  }

  return self;
}

/**
 * ローカルデータベースに接続します。
 *
 * @param cab  キャビネット情報
 * @param outError  エラー情報
 * @return  成功した場合はYESを、それ以外はNO
 */
-(BOOL)start:(NSError **)outError
{
  // ログアウト
  [self stop];

  // データベースアタッチ
  CBLManager *mgr = [CBLManager sharedInstance];
  self.database = [mgr databaseNamed:@"omoide" error:outError];
  if (*outError) {
    return NO;
  }
  [Document setDatabase:self.database];
  
  [self startSync:YES];

  return YES;
}

/**
 * ログアウトします。
 *
 * @return  成功したらYESをそれ以外はNO
 */
-(void)stop
{
  self.database = nil;
  [Document setDatabase:nil];
  [self stopSync];
}

-(void)clean
{
  NSError *error = nil;
  CBLManager *mgr = [CBLManager sharedInstance];
  self.database = [mgr databaseNamed:@"omoide" error:&error];
  [self.database deleteDatabase:&error];
}

/**
 * 同期を開始します。
 */
- (void)startSync:(BOOL)continuous
{
  CBLDatabase *db = self.database;
  
  NSString *path = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];
  NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
  NSString *url = [dict valueForKeyPath:@"url"];

  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  NSString *uid = [userDefaults stringForKey:@"uid"];
  NSString *pwd = [userDefaults stringForKey:@"pwd"];
  
  if (uid == Nil || uid.length <= 0) {
    return;
  }
  if (pwd == Nil || pwd.length <= 0) {
    return;
  }
  
  url = [NSString stringWithFormat:url, uid, pwd];

  NSLog(@"URL=%@", url);
  
  NSURL *couch = [NSURL URLWithString:url];
  
  self.pull = [db createPullReplication:couch];
  self.push = [db createPushReplication:couch];
  self.pull.continuous = continuous;
  self.push.continuous = continuous;

  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self
         selector:@selector(syncProgress:)
             name:kCBLReplicationChangeNotification
           object:self.pull];
  [nc addObserver:self
         selector:@selector(syncProgress:)
             name:kCBLReplicationChangeNotification
           object:self.push];

  [self.pull stop];
  [self.push stop];
  [self.pull start];
  [self.push start];
}

/**
 * 同期を停止します。
 */
- (void)stopSync
{
  if (self.pull) {
    [self.pull stop];
    self.pull = nil;
  }
  if (self.push) {
    [self.push stop];
    self.push = nil;
  }
}





#pragma mark -
#pragma mark Private Methods



/**
 *
 */
- (void)syncProgress:(NSNotification *)nc
{
  bool active = false;
  unsigned int completed = 0;
  unsigned int total = 0;
  CBLReplicationStatus status = kCBLReplicationStopped;
  NSError *error = nil;

  for (CBLReplication* repl in @[self.pull, self.push]) {
    status = MAX(status, repl.status);
    
    if (!error) {
      error = repl.lastError;
    }
    if (repl.status == kCBLReplicationActive) {
      active = true;
      completed += repl.completedChangesCount;
      total += repl.changesCount;
    }
  }
  
  if (active != _active
      || completed != _completed
      || total != _total
      || status != _status
      || error != _error) {
    _active = active;
    _completed = completed;
    _total = total;
    _progress = (completed / (float)MAX(total, 1u));
    _status = status;
    _error = error;
    NSLog(@"SYNCMGR: active=%d; status=%d; %u/%u; %@",
          active, status, completed, total, error.localizedDescription);
    
    if (status == kCBLReplicationStopped) {
      if (self.sync) {
        [self.sync callback:error];
      }
    }
  }
}


@end
