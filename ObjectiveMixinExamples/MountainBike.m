//
//  MountainBike.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "MountainBike.h"
#import "Mixin.h"

@implementation MountainBike
@synthesize make;
@synthesize model;

+ (void) initialize {
	if ([self class] == [MountainBike class])
		[Mixin from:[Serializable class] into:self];
}

- (NSString*) serializedRepresentation {
	return [NSString stringWithFormat:@"%@,%@", self.make, self.model];
}

- (void) deserialize:(NSString*)serialized {
	NSArray* components = [serialized componentsSeparatedByString:@","];
	self.make = [components objectAtIndex:0];
	self.model = [components objectAtIndex:1];
}

@end
