//
//  Spline.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

#import <Foundation/Foundation.h>

@class PointList;
@class FloatArray;

@interface Spline : NSObject
{
    PointList* points;
    FloatArray* splineSolution;
}

+(id)SplineWithPoints:(PointList*)pts andSplineSolution:(FloatArray*)splineSol;
-(id)initWithPoints:(PointList*)pts andSplineSolution:(FloatArray*)splineSol;

-(float)firstXVal;
-(float)lastXVal;
  
-(float)yForXVal:(float)xVal;

@end
