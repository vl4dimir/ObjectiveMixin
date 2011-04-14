//
//  main.m
//  ObjectiveMixinExamples
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CandyFactory.h"

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
	
	[pool drain];
	return 0;
}

