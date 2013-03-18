//
//  SplineFitter.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

@class Spline;
@class PointList;

typedef enum{
    bc_endpointsSlope0,  // The spline has first derivative (dx) = 0 at both endpoints
    bc_endpointsCurve0,  // The spline has second derivative (ddx) = 0 at both endpoints
    bc_leftSlope0rightCurve0, // Left side has slope=0, right side has curvature=0 at endpoints
    bc_leftCurve0leftSlope0, // Left side has curvature=0, right side has slope=0 at endpoints
    bc_endpointsSlopeCurveHarmonic, // The spline has dx1=dx2 and ddx1=ddx2 for the endpoints
    bc_endsegmentsQuadratic, // The spline segments that include the endpoints are quadratic (as opposed to cubic)
    bc_num_types
} BoundaryConditionType;

#import <Foundation/Foundation.h>

@interface SplineFitter : NSObject

+(Spline*)splineForPoints:(PointList*)points andBoundaryConditions:(BoundaryConditionType)bcType;

@end
