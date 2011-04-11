//
//  SourceClass.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 11/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SourceClass : NSObject {
    NSString* jazzatazz;
}

@property (nonatomic, retain) NSString* jazzatazz;

- (void) helloWorld;
- (void) methodWithAnArgument:(NSObject*)arg;
- (void) methodUsingAnInstanceVariable;

@end
