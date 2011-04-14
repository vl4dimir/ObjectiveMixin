//
//  MountainBike.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Serializable.h"

@interface MountainBike : NSObject <SerializableMixin> {
	NSString* make;
	NSString* model;
}

@property (nonatomic, retain) NSString* make;
@property (nonatomic, retain) NSString* model;

- (NSString*) serializedRepresentation;
- (void) deserialize:(NSString*)serialized;

@end
