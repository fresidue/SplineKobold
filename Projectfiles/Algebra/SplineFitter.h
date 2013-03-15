//
//  SplineFitter.h
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

@class Spline;
@class PointList;

typedef enum{
    bc_endpointsSlope0,  // The spline has first derivative (dx) = 0 at both endpoints
    bc_endpointsCurve0,  // The spline has second derivative (ddx) = 0 at both endpoints
    bc_endpointsSlopeCurveHarmonic, // The spline has dx1=dx2 and ddx1=ddx2 for the endpoints
    bc_endsegmentsQuadratic // The spline segments that include the endpoints are quadratic (as opposed to cubic)
} BoundaryConditionType;

#import <Foundation/Foundation.h>

@interface SplineFitter : NSObject

+(Spline*)splineForPoints:(PointList*)points andBoundaryConditions:(BoundaryConditionType)bcType;

@end
