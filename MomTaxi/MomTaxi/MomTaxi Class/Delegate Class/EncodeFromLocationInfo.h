//
//  EncodeFromLocationInfo.h
//  MomTaxi
//
//  Created by RCSoftASTaeinLee on 12. 4. 30..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface EncodeFromLocationInfo : NSObject
- (NSString*)encryptInfo:(double)location;
- (NSInteger)randInteger;
- (double)decryptInfo:(NSString*)location type:(BOOL)isX;
@end
