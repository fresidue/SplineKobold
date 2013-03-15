//
//  PointList.h
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PointList : NSObject {
    NSMutableArray* xs;
    NSMutableArray* ys;
}

+(id)pointList;
+(id)pointListWithCapacity:(int)capacity;
-(id)initWithCapacity:(int)capacity;
-(void)addPoint:(CGPoint)point;
-(CGPoint)pointAtIndex:(int)index;
-(int)numPoints;
@end
