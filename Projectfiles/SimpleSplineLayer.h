//
//  SimpleSplineLayer.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/14/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import "kobold2d.h"
#import "spline_algebra.h"

@interface SimpleSplineLayer : CCLayer
{
    PointList* controlPoints;
    BoundaryConditionType bcType;
    NSMutableArray* controlSprites;
    BOOL numControlSpritesChanged;
    
    Spline* spline;
    CGPoint minPt;
    CGPoint maxPt;
    BOOL splineIsCurrent;
    
    NSMutableArray* pointSprites;
}

+(CCScene*)scene;

@end
