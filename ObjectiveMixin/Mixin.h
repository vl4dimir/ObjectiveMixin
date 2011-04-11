//
//  Mixin.h
//  ObjectiveMixin
//
//  Created by Vladimir Mitrovic on 24/02/2011.
//  Copyright 2011 Vladimir Mitrovic. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Mixin : NSObject {
@private
    
}

+ (void) from:(Class)sourceClass into:(Class)destinationClass;

@end
