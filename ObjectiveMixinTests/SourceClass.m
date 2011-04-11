//
//  SourceClass.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 11/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "SourceClass.h"


@implementation SourceClass
@synthesize jazzatazz;

- (void) helloWorld {
	NSLog(@"Hello everyone!");
}

- (void) methodWithAnArgument:(NSObject*)arg {
	NSLog(@"Hi there! You have passed the following argument: %@. KTHXBYE.", arg);
}

- (void) methodUsingAnInstanceVariable {
	jazzatazz = [[[self class] description] retain];
	NSLog(@"This method uses an instance variable which has the following value: %@", jazzatazz);
	[jazzatazz release];
}

- (void) dealloc {
    self.jazzatazz = nil;
    [super dealloc];
}

@end
