//
//  Serializable.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "Serializable.h"


@implementation Serializable

- (void) serializeToFile:(NSString*)path {
	NSString* serialized = [(id)self serializedRepresentation];
	[serialized writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void) deserializeFromFile:(NSString*)path {
	NSString* serialized = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
	[(id)self deserialize:serialized];
}

@end
