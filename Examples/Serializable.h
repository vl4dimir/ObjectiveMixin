//
//  Serializable.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Serializable : NSObject {}
- (void) serializeToFile:(NSString*)path;
- (void) deserializeFromFile:(NSString*)path;
@end


@protocol SerializableMixin <NSObject>
@required
- (NSString*) serializedRepresentation;
- (void) deserialize:(NSString*)serialized;

@optional
- (void) serializeToFile:(NSString*)path;
- (void) deserializeFromFile:(NSString*)path;
@end