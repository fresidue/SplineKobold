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

-(void)deletePointAtIndex:(int)index {
    [xs removeObjectAtIndex:index];
    [ys removeObjectAtIndex:index];
}

-(void)replacePointAtIndex:(int)index withPoint:(CGPoint)pt {
    [xs replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:pt.x]];
    [ys replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:pt.y]];
}
-(void)insertPointAtIndex:(int)index withPoint:(CGPoint)pt  {
    [xs insertObject:[NSNumber numberWithFloat:pt.x] atIndex:index];
    [ys insertObject:[NSNumber numberWithFloat:pt.y] atIndex:index];
}

-(int)numPoints {
    return xs.count;
}

-(PointList*)createCopy {
    
    int numP = xs.count;
    PointList* copy = [PointList pointListWithCapacity:numP];
    for (int i=0; i<numP; i++) {
        [(copy->xs) addObject:[xs objectAtIndex:i]];
        [(copy->ys) addObject:[ys objectAtIndex:i]];
    }
    return copy;
}

-(PointList*)orderedPoints {
    
    PointList* copy = [self createCopy];
    PointList* rv = [PointList pointListWithCapacity:[copy numPoints]];
    while ( [copy numPoints] > 0 ) {
        int index = 0;
        float x = [[copy->xs objectAtIndex:0] floatValue];
        for (int i=1; i<[copy numPoints]; i++) {
            float tempX = [[copy->xs objectAtIndex:i] floatValue];
            if ( tempX < x ) {
                x = tempX;
                index = i;
            }
        }
        [rv addPoint:[copy pointAtIndex:index]];
        [copy deletePointAtIndex:index];
    }
    return rv;
}



@end
