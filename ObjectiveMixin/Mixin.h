//
//  Mixin.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 24/02/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mixin : NSObject

+ (void) from:(Class)sourceClass into:(Class)destinationClass;
+ (void) from:(Class)sourceClass into:(Class)destinationClass followInheritance:(BOOL)followInheritance force:(BOOL)force;

@end


// A category on NSObject, for convenience. It uses the Mixin class internally.
@interface NSObject (Mixin)

+ (void) mixinFrom:(Class)sourceClass;
+ (void) mixinFrom:(Class)sourceClass followInheritance:(BOOL)followInheritance force:(BOOL)force;

- (void) mixinFrom:(Class)sourceClass;
- (void) mixinFrom:(Class)sourceClass followInheritance:(BOOL)followInheritance force:(BOOL)force;


+ (id) allocWithSuperclass:(Class)superClass;
+ (Class) classWithSuperclass:(Class)superClass;

@end
