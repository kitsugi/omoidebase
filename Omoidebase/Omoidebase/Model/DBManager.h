

#import <Foundation/Foundation.h>
#import <CouchbaseLite/CouchbaseLite.h>

@protocol SyncDelegate;


//###########################################################################
/// データベース管理クラス
//###########################################################################
@interface DBManager : NSObject

// Class Methods
+ (DBManager *)sharedManager;

// Properties
@property (strong, nonatomic) CBLDatabase *database;
@property (nonatomic, strong) CBLReplication *pull;
@property (nonatomic, strong) CBLReplication *push;

/**
 * 完了
 */
@property (nonatomic, readonly) unsigned int completed;

/**
 * 合計
 */
@property (nonatomic, readonly) unsigned int total;

/**
 * 進捗率
 */
@property (nonatomic, readonly) float progress;

/**
 * 同期中
 */
@property (nonatomic, readonly) bool active;

/**
 * 同期ステータス
 */
@property (nonatomic, readonly) CBLReplicationStatus status;

/**
 * 同期エラー
 */
@property (nonatomic, readonly) NSError* error;

@property id<SyncDelegate> sync;


// Instance Methods
-(BOOL)start:(NSError **)outError;
-(void)stop;
-(void)clean;

- (void)startSync:(BOOL)continuous;
- (void)stopSync;


@end
