SplineKobold
============

Cubic spline fit between a set of given points.

Requires Accelerate framework.

Am providing a sample project created with Kobold2d v2.0.4. All the spline functionality is in the Algebra folder (or xCode group),
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
How to
======

There isn't much kobold-specific stuff used, but I don't really care to rewrite it using only Cocos2d stuff either. Oh well.
Kobold2d can be downloaded from 

http://www.kobold2d.com/display/KKSITE/Kobold2D+Download?atl_token=e1444555d5a7b60b2012d23dfdbe852c2721ad75

This project was built with Kobold v2.0.4. Just download & install. Create an empty folder for the repo in the same folder as
the Kobold2D.xcworkspace. Add the SplineKobold to the workspace by dragging the project file to the left pane (above Kobold2D-Libraries)
