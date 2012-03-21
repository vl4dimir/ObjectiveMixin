//
//  Mixin.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 24/02/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "Mixin.h"
#import <objc/runtime.h>


@implementation Mixin

+ (void) from:(Class)sourceClass into:(Class)destinationClass
{
	// Mixin all instance methods from the source class (ignoring superclasses)
	unsigned int methodCount = 0;
	Method* instanceMethods = class_copyMethodList(sourceClass, &methodCount);
	for (int i = 0; i < methodCount; i++) {
		Method m = instanceMethods[i];
		class_replaceMethod(destinationClass, method_getName(m), method_getImplementation(m), method_getTypeEncoding(m));
	}
	
	// Mixin all class methods from the source class (ignoring cuperclasses)
	Method* classMethods = class_copyMethodList(object_getClass(sourceClass), &methodCount);
	for (int i = 0; i < methodCount; i++) {
		Method m = classMethods[i];
		class_replaceMethod(object_getClass(destinationClass), method_getName(m), method_getImplementation(m), method_getTypeEncoding(m));
	}
}

+ (void) from:(Class)sourceClass into:(Class)destinationClass followInheritance:(BOOL)followInheritance {
	if (followInheritance) {
		// Mixin from all ancestor classes recursively, up to the common ancestor
		Class sourceParent = class_getSuperclass(sourceClass);
		if (sourceParent != nil) {
			// Find a common ancestor for sourceClass and destinationClass
			Class destinationParent = destinationClass;
			while ((destinationParent = class_getSuperclass(destinationParent)) != nil && destinationParent != sourceParent);
			
			// Only mixin from sourceParent if it's not an ancestor of destinationClass
			if (destinationParent == nil) {
				[self from:sourceParent into:destinationClass followInheritance:YES];
			}
		}
	}
	
	[self from:sourceClass into:destinationClass];
}

@end


@implementation NSObject (Mixin)

- (void) mixinFrom:(Class)sourceClass {
	[Mixin from:sourceClass into:[self class]];
}

- (void) mixinFrom:(Class)sourceClass followInheritance:(BOOL)followInheritance {
	[Mixin from:sourceClass into:[self class] followInheritance:followInheritance];
}


+ (Class) classWithSuperclass:(Class)superClass 
{
    Protocol *protocol = nil;
    
    NSString *myClassName = NSStringFromClass(self);
    if([myClassName hasSuffix:@"Mixin"]) {
        protocol = NSProtocolFromString([myClassName substringToIndex:myClassName.length - 5]);
    }
    
    Class fromClass = self;
    NSString *dynamicClassName = [NSString stringWithFormat:@"%@_WithSuperclass_%@", NSStringFromClass(fromClass), NSStringFromClass(superClass)];
    if(protocol) {
        dynamicClassName = [NSString stringWithFormat:@"%@_ConformingToProtocol_%@", dynamicClassName, NSStringFromProtocol(protocol)];
    }
    
    Class dynamicClass = NSClassFromString(dynamicClassName);
    
    if(!dynamicClass) {
        dynamicClass = objc_allocateClassPair(fromClass, [dynamicClassName UTF8String], 0);
        
        [Mixin from:fromClass into:dynamicClass];
        
        if(protocol) {
            class_addProtocol(dynamicClass, protocol);
        }
        
        objc_registerClassPair(dynamicClass);
    }
    
    return dynamicClass;
}


+ (id) allocWithSuperclass:(Class)superClass
{
    return [[self classWithSuperclass:superClass] alloc];
}

@end