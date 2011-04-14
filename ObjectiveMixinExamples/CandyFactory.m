//
//  CandyFactory.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "CandyFactory.h"
#import "Mixin.h"

@implementation CandyFactory

+ (void) initialize {
	// Get singleton functionality for free
	[Mixin from:[Singleton class] into:self];
}

- (NSString*) createCandy {
	return [NSString stringWithFormat:@"Candy with description: %@", [self description]];
}

@end
