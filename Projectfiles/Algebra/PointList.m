//
//  PointList.m
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import "PointList.h"

@implementation PointList

+(id)pointList {
    
    return [[PointList alloc] init];
}

+(id)pointListWithCapacity:(int)capacity {
    
    return [[PointList alloc] initWithCapacity:capacity];
}

-(id)initWithCapacity:(int)capacity {
    
    if ( self=[super init] ) {
        xs = [NSMutableArray array];
        ys = [NSMutableArray array];
    }
    return self;
    
}

-(id)init {
    
    if ( self=[super init] ) {
        xs = [NSMutableArray array];
        ys = [NSMutableArray array];
    }
    return self;
}

-(void)addPoint:(CGPoint)point {
    
    [xs addObject:[NSNumber numberWithFloat:point.x]];
    [ys addObject:[NSNumber numberWithFloat:point.y]];
}

-(CGPoint)pointAtIndex:(int)index {
    
    float x = [[xs objectAtIndex:index] floatValue];
    float y = [[ys objectAtIndex:index] floatValue];
    return CGPointMake(x, y);
//    return CGPointMake([[xs objectAtIndex:index] floatValue], [[ys objectAtIndex] floatValue]);
}

-(int)numPoints {
    return xs.count;
}

@end
