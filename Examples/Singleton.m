//
//  Singleton.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "Singleton.h"


@implementation Singleton

// This dictionary holds mapping of Class values to their respective instances.
// Since the Singleton class can be "mixed in" into different classes in runtime,
// a static variable holding a reference to an instance is not sufficient, since
// it would be shared among all classes that mix in Singleton. Thus, we track all
// singleton instances in a dictionary.
static NSMutableDictionary* instances = nil;

+ (id) instance {
	if (!instances) instances = [[NSMutableDictionary alloc] init];
	
	id instance = [instances objectForKey:self];
	if (!instance) {
		instance = [[[self alloc] init] autorelease];
		[instances setObject:instance forKey:self];
	}
	
	return instance;
}

+ (void) destroyInstance {
	[instances removeObjectForKey:self];
}

@end
