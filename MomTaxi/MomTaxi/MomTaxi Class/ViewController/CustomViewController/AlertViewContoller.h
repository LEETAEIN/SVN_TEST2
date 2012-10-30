//
//  ;
//  MomTaxi
//
//  Created by  on 11. 11. 22..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "DefineClass.h"


@interface AlertViewContoller : UIAlertView <UIAlertViewDelegate>
{
    UILabel * titleLabel;
    UILabel * contentLabel;
    UIImage * backgroundImage;
    UIButton * okButton;
    UIButton * cancelButton;
    UIButton * oneButton;
    NSInteger mTag;
}
@property (readwrite, strong) UIImage *backgroundImage;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property NSInteger mTag;
- (id)initWithImage:(UIImage *)backgroundImage title:(NSString *)text content:(NSString *)text submit:(NSString *)text modelnum:(NSString *)text;
- (id)initWithImagePush:(UIImage *)image title:(NSString *)title content:(NSString *)content submit:(NSString *)submit modelnum:(NSString *)modelnum;
- (void)okSelect:(UIButton*)sender;
- (void)cancelSelect:(UIButton*)sender;
- (void)yesSelect:(UIButton*)sender;
- (void)noSelect:(UIButton*)sender;
- (void)cancelTimer;
@end
