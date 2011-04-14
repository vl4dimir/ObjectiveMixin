//
//  CandyFactory.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"

@interface CandyFactory : NSObject <SingletonMixin> {}

- (NSString*) createCandy;

@end
