//
//  ZPair.m
//  neww
//
//  Created by fmohamed on 4/2/20.
//  Copyright © 2020 practice. All rights reserved.
//

#import "ZPair.h"

@interface ZPair : NSObject {

@end

@implementation ZPair
- (id)initWithObjects:(id)object, ... {
    if ((self = [super init])) {
        va_list args;
        va_start(args, object);
        
        obj1 = [object retain];
        obj2 = [va_arg(args, id) retain];
        va_end(args);
    }
    
    return self;
}

- (void)dealloc {
    [obj1 release];
    [obj2 release];
    
    [super dealloc];
}
@end

/* A simple Obj-C pair!
 Initialization: Pair *x = [[Pair alloc] initWithObjects:obj1, obj2];
 Member Getting: x->obj1; x->obj2;
 Member setting: x->obj1 = [obj1 retain]; x->obj2 = [obj2 retain];
 Releasing: [x release]; */
