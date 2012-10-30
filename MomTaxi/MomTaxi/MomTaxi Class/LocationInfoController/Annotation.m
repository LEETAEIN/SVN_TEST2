//
//  Annotation.m
//  MomTaxi
//
//  Created by  on 11. 12. 1..
//  Copyright (c) 2011년 __MyCompanyName__. All rights reserved.
//

#import "Annotation.h"


@implementation Annotation
@synthesize coordinate;
@synthesize subtitle;
@synthesize title;
@synthesize ID;
@synthesize tag;


- (id)initWithCoordinate:(CLLocationCoordinate2D)location
{
	coordinate = location;
	return self;
}

@end
