//
//  Singleton.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 14/04/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Singleton : NSObject {}
+ (id) instance;
+ (void) destroyInstance;
@end


@protocol SingletonMixin <NSObject>
@optional
+ (id) instance;
+ (void) destroyInstance;
@end