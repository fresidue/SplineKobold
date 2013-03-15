SplineKobold
============

Cubic spline fit between a set of given points.

Requires Accelerate framework.

Providing a sample project created with Kobold2d v2.0.4. All the spline functionality is in the Algebra folder (or xCode group),
and is not Kobold dependent.

Given a list of CGPoints (assumes ordered x-values, but unordered will not cause crash, just apparent discontinuities) wrapped in
a PointList object, creates a cubic spline interpolation between the points. The solution is guaranteed continuous to the 
second derivative.

Creation of a spline requires a minimum of three (3) CGPoints, and the boundary condition type needs to be specified (allowed
types defined in SplineFitter).

Example Usage
=============
```
CGPoint pt1 = CGPointMake(1,2);
CGPoint pt2 = CGPointMake(3,5);
CGPoint pt3 = CGPointMake(6,-3);
PointList* pl = [PointList pointListWithCapacity:3];
[pl addPoint:pt1];
[pl addPoint:pt2];
[pl addPoint:pt3];
Spline* spline = [SplineFitter splineForPoints:pl andBoundaryConditions:bc_endpointsSlope0];

float interpY = [spline yForXVal:4.5];
```
