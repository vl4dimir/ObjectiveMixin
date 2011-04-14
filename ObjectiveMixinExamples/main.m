//
//  main.m
//  ObjectiveMixinExamples
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CandyFactory.h"
#import "MountainBike.h"

int main (int argc, const char * argv[]) {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	// Test the Singleton mixin. This should print out a different object address
	// for each loop iteration, since we're destroying the instance at the end of
	// the iteration.
	for (int i = 0; i < 2; i++) {
		CandyFactory* candyFactory1 = [CandyFactory instance];
		CandyFactory* candyFactory2 = [CandyFactory instance];
		NSLog(@"%@", [candyFactory1 createCandy]);
		NSLog(@"%@", [candyFactory2 createCandy]);
		[CandyFactory destroyInstance];
	}
	
	// Test the serializable mixin. We create a MountainBike instance, serialize it
	// to disk, and then populate another instance by deserializing from that file.
	MountainBike* bike = [[[MountainBike alloc] init] autorelease];
	bike.make = @"Scott";
	bike.model = @"Scale 30";
	
	NSString* path = @"bike.txt";
	[bike serializeToFile:path];
	
	MountainBike* anotherBike = [[[MountainBike alloc] init] autorelease];
	[anotherBike deserializeFromFile:path];
	NSLog(@"Original bike:     %@ %@", bike.make, bike.model);
	NSLog(@"Deserialized bike: %@ %@", anotherBike.make, anotherBike.model);
	
	[pool drain];
	return 0;
}

