//
//  DestinationClass.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 11/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "DestinationClass.h"


@implementation DestinationClass

- (int) methodToBeOverridden
{
	NSLog(@"This method is the destination class version");
	return 2;
}

@end
