//
//  EncodeFromLocationInfo.m
//  MomTaxi
//
//  Created by RCSoftASTaeinLee on 12. 4. 30..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "EncodeFromLocationInfo.h"


@implementation EncodeFromLocationInfo


#define kHeadLength 10
#define kBodyLength 20
#define ARRAY_ENCRYPT [NSArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil]


- (NSString*)encryptInfo:(double)location
{   
    // 좌표의 뒷자리를 6자리로 맞추고, 점을 기준으로 배열화 한다.
    NSString *convertString = [NSString stringWithFormat:@"%.6f", location];
    NSArray *temp = [convertString componentsSeparatedByString:@"."];
    
    NSString *head = [NSString stringWithFormat:@"%d", [[temp objectAtIndex:0x00] integerValue]];
    NSMutableString *dummy1 = nil;

    // 암호화를 위해 난수를 발생시켜 자리수를 채운다.
    dummy1 = [[NSMutableString alloc] init];
    for(NSInteger i = 0; i < kHeadLength - [head length] - 1; i++) 
    {
        NSInteger dummy1Index = [self randInteger];
        NSString *dummy1Encrypt = [ARRAY_ENCRYPT objectAtIndex:dummy1Index];
        [dummy1 appendFormat:@"%@", dummy1Encrypt];
    }
    
    NSMutableString *frontString = [[NSMutableString alloc] init];
    frontString = [NSString stringWithFormat:@"%d%@%@", [head length], dummy1, head];

    NSString *body = [NSString stringWithFormat:@"%@", [temp objectAtIndex:0x01]];   
    NSMutableString *dummy2 = [[NSMutableString alloc] init];
    for(NSInteger i = 0; i < (20 - 2) - [body length]; i++) 
    {
        NSInteger dummy2Index = [self randInteger];
        NSString *dummy2Encrypt = [ARRAY_ENCRYPT objectAtIndex:dummy2Index];
        [dummy2 appendFormat:@"%@", dummy2Encrypt];
    }

    NSMutableString *bodyString = [[NSMutableString alloc] init];
    [bodyString appendFormat:@"%02d", [body length]];
    [bodyString appendFormat:@"%@", dummy2];
    [bodyString appendFormat:@"%@", body];

    NSLog(@"encryptInfo return = %@", [NSString stringWithFormat:@"%@%@", frontString, bodyString]);

    return [NSString stringWithFormat:@"%@%@", frontString, bodyString];
}


- (NSInteger)randInteger
{
    int a = 0;
    int b = [ARRAY_ENCRYPT count] - 1;
    int result = (rand() % (b - a + 1)) + a;
    return result;
}
     

- (double)decryptInfo:(NSString*)location type:(BOOL)isX
{
    NSString *headOrg = [location substringToIndex:10]; 
    NSInteger headLength = [[location substringToIndex:1] integerValue];

    NSRange rangeHead;
    rangeHead.location = [headOrg length] - headLength;
    rangeHead.length = headLength;
    NSString *head = [headOrg substringWithRange:rangeHead];

    NSRange rangeBodyOrg;
    rangeBodyOrg.location = 10;
    rangeBodyOrg.length = 20;
    NSString *bodyOrg = [location substringWithRange:rangeBodyOrg];

    NSRange rangeBodyPos;
    rangeBodyPos.location = 0;
    rangeBodyPos.length = 2;
    
    NSString *bodyLength = [bodyOrg substringWithRange:rangeBodyPos];
    
    NSRange rangeBody;
    rangeBody.location = [bodyOrg length] - [bodyLength integerValue];
    rangeBody.length = [bodyLength integerValue];
    
    NSString *body = [bodyOrg substringWithRange:rangeBody];
    
    NSLog(@"decryptInfo 8 - %f", [[NSString stringWithFormat:@"%@.%@", head, body] doubleValue]);

    NSString *result = [NSString stringWithFormat:@"%@.%@", head, body];
    return [result doubleValue];
}

@end
