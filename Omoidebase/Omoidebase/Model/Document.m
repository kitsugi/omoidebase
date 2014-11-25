//
//  Document.m
//  Omoidebase
//


#import "Document.h"
#import "CBLModel+DB.h"

@implementation Document

//@dynamic type;

#pragma mark -
#pragma mark init
/**
 * イニシャライザ。
 *
 * @return  初期化済みのインスタンス
 */
- (id)init
{
  self = [super initWithNewDocumentInDatabase:self.dbMgr.database];
  
  if (self) {
    self.type = @"";
  }

  return self;
}

@end
