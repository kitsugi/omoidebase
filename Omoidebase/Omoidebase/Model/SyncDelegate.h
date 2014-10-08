
#import <Foundation/Foundation.h>

@protocol SyncDelegate <NSObject>

@required

-(void)callback:(NSError *)error;

@end
