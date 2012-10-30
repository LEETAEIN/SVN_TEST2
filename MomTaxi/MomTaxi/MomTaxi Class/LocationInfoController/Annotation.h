//
//  Annotation.h
//  MomTaxi
//
//  Created by  on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface Annotation : NSObject <MKAnnotation>
{
	CLLocationCoordinate2D coordinate;
    NSString *subtitle;
	NSString *title;
    NSString *ID;
    NSInteger tag;
}
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *ID;
@property NSInteger tag;
- (id)initWithCoordinate:(CLLocationCoordinate2D)location;
@end
