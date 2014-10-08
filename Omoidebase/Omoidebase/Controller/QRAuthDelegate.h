//
//  QRAuthDelegate.h
//  Omoidebase
//
//  Created by Couchmemories on 2014/09/07.
//  Copyright (c) 2014年 Ajinosashimi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol QRAuthDelegate <NSObject>

- (BOOL)auth:(NSString *)qrcode;
- (void)setQRcode:(NSString *)qrcode;

@end
