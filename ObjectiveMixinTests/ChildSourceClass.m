//
//  ChildSourceClass.m
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 11/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import "ChildSourceClass.h"

@implementation ChildSourceClass

- (void) childMethodCallingParentMethod {
	[self helloWorld];
}

@end
