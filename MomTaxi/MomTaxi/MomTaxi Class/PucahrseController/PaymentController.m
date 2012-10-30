//
//  PaymentController.m
//  MomTaxi
//
//  Created by  on 11. 11. 30..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "PaymentController.h"
#import "AppDelegate.h"


@implementation PaymentController
@synthesize mArray;
@synthesize mIndex;


#define kMyBackGroundColor [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f]
#define ARRAY_MONEY [NSArray arrayWithObjects:@"0.99", @"1.99", @"2.99", @"3.99", @"4.99", @"5.99", @"9.99", nil]
#define ARRAY_POINT [NSArray arrayWithObjects:@"1000", @"2000", @"3000", @"4000", @"5000", @"6000", @"10000", nil]


- (id)init
{
    if (self = [super init]) {
            self.mArray = [NSArray arrayWithObjects:@"com.momtaxi.coupon000", @"com.momtaxi.coupon001", @"com.momtaxi.coupon002", @"com.momtaxi.coupon003", @"com.momtaxi.coupon004", @"com.momtaxi.coupon005", @"com.momtaxi.coupon006", @"com.momtaxi.coupon007", nil];
    }
    return self;
}


- (void)buyCoupon:(NSInteger)index
{   
    self.mIndex = index;
    
    if([SKPaymentQueue canMakePayments] == NO) 
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"포인트 구매" message:@"포인트 구매가 가능하지 않습니다.\n잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
    }
    else
    {
        SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:[NSString stringWithFormat:@"com.momtaxi.coupon%03d", index]]];
        request.delegate = self;
        [request start];
    }
}


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
	if([response.products count] == 0)
    {
        UIAlertView *alertView = 
        [[UIAlertView alloc] initWithTitle:@"포인트 구매" message:@"포인트 구매가 가능하지 않습니다.\n잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
        [alertView show];
		return;
	}

    for (SKProduct *product in response.products)
    {
        NSLog(@"Title : %@", product.localizedTitle);
        NSLog(@"Description : %@", product.localizedDescription);
        NSLog(@"Price : %@", product.price);
    }
    
    for(SKProduct * myProduct in response.products)
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        SKPayment *payment = [SKPayment paymentWithProduct:myProduct];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    UIAlertView *alertView = nil;
	for(SKPaymentTransaction *transaction in transactions)
	{
		switch(transaction.transactionState)
		{
			case SKPaymentTransactionStatePurchasing:
			{
				break;
			}
			case SKPaymentTransactionStatePurchased:
			{
				[self completeTransaction:transaction];
                
                NSString *money = [ARRAY_MONEY objectAtIndex:self.mIndex];
                NSString *point = [ARRAY_POINT objectAtIndex:self.mIndex];
                
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [delegate.gClassRequest BuyCoupon:gDefineDataType[valueJson] taxi:[[NSUserDefaults standardUserDefaults] objectForKey:@"KeyOfNumber"] buy:point money:money];
                
                alertView = 
                [[UIAlertView alloc] initWithTitle:@"포인트 구매" message:@"포인트 구매가 완료 되었습니다." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alertView show];
                
				break;
			}
			case SKPaymentTransactionStateFailed:
			{
                [self failedTransaction:transaction];
                
                alertView = 
                [[UIAlertView alloc] initWithTitle:@"포인트 구매" message:@"포인트 구매를 실패하였습니다.\n잠시 후 다시 시도해 주세요." delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alertView show];

				break;
			}
			case SKPaymentTransactionStateRestored:
			{
				[self restoreTransaction:transaction];
				break;
			}
			default:
			{
				break;
			}
		}
	}
}


- (void)completeTransaction: (SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue]finishTransaction:transaction];
}


- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}


- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
	[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
	[self onRestore];
}


- (void)onRestore
{
	SKPaymentQueue* queue = [SKPaymentQueue defaultQueue];
	[queue restoreCompletedTransactions];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}


- (void)requestDidFinish:(SKRequest *)request
{
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
}

@end
