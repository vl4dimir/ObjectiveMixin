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
	// Mixin all methods from the source class (ignoring superclasses)
	unsigned int methodCount = 0;
	Method* methodList = class_copyMethodList(sourceClass, &methodCount);
	
	for (int i = 0; i < methodCount; i++) {
		Method m = methodList[i];
		SEL name = method_getName(m);
		IMP imp = method_getImplementation(m);
		const char* types = method_getTypeEncoding(m);
		class_replaceMethod(destinationClass, name, imp, types);
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
