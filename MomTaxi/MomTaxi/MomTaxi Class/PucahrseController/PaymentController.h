//
//  PaymentController.h
//  MomTaxi
//
//  Created by  on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface PaymentController : NSObject <UIAlertViewDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>
{
    NSArray *mArray;
    NSInteger mIndex;
}
@property (nonatomic, strong) NSArray *mArray;
@property NSInteger mIndex;
- (void)buyCoupon:(NSInteger)index;
- (void)completeTransaction: (SKPaymentTransaction *)transaction;
- (void)failedTransaction:(SKPaymentTransaction *)transaction;
- (void)restoreTransaction:(SKPaymentTransaction *)transaction;
- (void)onRestore;
@end
