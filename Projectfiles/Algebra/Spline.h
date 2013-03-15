//
//  Spline.h
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
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
