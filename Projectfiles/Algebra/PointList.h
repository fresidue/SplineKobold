//
//  PointList.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
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
-(void)deletePointAtIndex:(int)index;
-(void)replacePointAtIndex:(int)index withPoint:(CGPoint)pt;
-(void)insertPointAtIndex:(int)index withPoint:(CGPoint)pt;
-(int)numPoints;

-(PointList*)orderedPoints;
-(PointList*)createCopy;
@end
