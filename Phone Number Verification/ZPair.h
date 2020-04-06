//
//  ZPair.h
//  neww
//
//  Created by fmohamed on 4/2/20.
//  Copyright © 2020 practice. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZPair : NSObject {
@public
    id obj1;
    id obj2;
}
- (id)initWithObjects:(id)object, ...;
@end


NS_ASSUME_NONNULL_END
