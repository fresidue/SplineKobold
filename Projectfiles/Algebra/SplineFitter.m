//
//  SplineFitter.m
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import "SplineFitter.h"
#import "Spline.h"
#import "PointList.h"
#import "FloatMatrix.h"
#import "FloatArray.h"
#import "MatrixManipulator.h"

@implementation SplineFitter

+(Spline*)splineForPoints:(PointList*)points andBoundaryConditions:(BoundaryConditionType)bcType {
    
    int numPoints = [points numPoints];
    
    // for all practical purposes, there MUST be at least three points
    if ( numPoints < 3 ) {
        return nil;
    }

    
    // create some temporary matrices for the values we'll be needing
    float xs[numPoints];
    float x2[numPoints];
    float x3[numPoints];
    float ys[numPoints];
    float x,xx,xxx;
    for (int i=0; i<numPoints; i++) {
        CGPoint pt = [points pointAtIndex:i];
        x = pt.x;
        xx = x*x;
        xxx = x*xx;
        xs[i] = x;
        x2[i] = xx;
        x3[i] = xxx;
        ys[i] = pt.y;
    }

    // There are (numPoints-1) spline segments
    // Each segment is (potentially) cubic Axˆ3 + Bxˆ2 + Cx + D = yVal
    // So dimensionality of splinefitter is 4*(numPoints-1)
    int numSegs = numPoints-1;
    int matDim = 4 * numSegs;
    FloatMatrix* splineMatrix = [FloatMatrix FloatMatrixWithDimension:matDim];
    
    // Let us set up the result vector as well
    FloatArray* splineResultant = [FloatArray floatArrayWithCapacity:matDim];
    for (int i=0; i<matDim; i++) {
        [splineResultant addValue:0];  // init to 0 since most values will be zero
    }
    
    
    
    // first condition - function at endpoints is equal to the y-Value (as per equation above)
    // we know these since we have the yvalues for each point
    // This takes care of 2*numSegs constraints (half of all necessary)
    for (int i=0; i<numSegs; i++) {
        int rowOffset = 2*i;
        int colOffset = 4*i;
        [splineMatrix replaceValue:x3[i] row:rowOffset column:colOffset];
        [splineMatrix replaceValue:x2[i] row:rowOffset column:colOffset+1];
        [splineMatrix replaceValue:xs[i] row:rowOffset column:colOffset+2];
        [splineMatrix replaceValue:1 row:rowOffset column:colOffset+3];
        [splineMatrix replaceValue:x3[i+1] row:rowOffset+1 column:colOffset];
        [splineMatrix replaceValue:x2[i+1] row:rowOffset+1 column:colOffset+1];
        [splineMatrix replaceValue:xs[i+1] row:rowOffset+1 column:colOffset+2];
        [splineMatrix replaceValue:1 row:rowOffset+1 column:colOffset+3];
        
        // for these guys (and only these guys) we have non-zero results
        [splineResultant replaceValue:ys[i] atIndex:rowOffset];
        [splineResultant replaceValue:ys[i+1] atIndex:rowOffset+1];
    }
    
    
    
    // second condition - the first derivatives are continuous
    // For each non-endpoint 3*A1*xˆ2 + 2*B1*x + C1 - 3*A2*xˆ2 - 2*B2 - c2 = 0
    // This takes care of (numSegs-1) constraints - which leaves (numSegs+1) constraints unaccounted
    for (int i=1; i<numSegs; i++) {
        int rowOffset = 2*numSegs+(i-1); //
        int colOffset = 4*(i-1);        // we start with i=1 .. cause whatever ..
        [splineMatrix replaceValue:3*x2[i] row:rowOffset column:colOffset];
        [splineMatrix replaceValue:2*xs[i] row:rowOffset column:colOffset+1];
        [splineMatrix replaceValue:1 row:rowOffset column:colOffset+2];
        [splineMatrix replaceValue:-3*x2[i] row:rowOffset column:colOffset+4];
        [splineMatrix replaceValue:-2*xs[i] row:rowOffset column:colOffset+5];
        [splineMatrix replaceValue:-1 row:rowOffset column:colOffset+6];
    }
    
    // third condition - the second derivatives are continuous
    // For each non-endpoint 6*A1*x + 2*B1 - 6*A2*x - 2*B2 = 0
    // This takes care of (numSegs-1) constraints - which leaves 2 (two) constraints unaccounted (the boundary conditions)
    for (int i=1; i<numSegs; i++) {
        int rowOffset = 3*numSegs+(i-1)-1;   // the -1 since the previous set only took care of (numSegs-1) constraints
        int colOffset = 4*(i-1);        //
        [splineMatrix replaceValue:6*xs[i] row:rowOffset column:colOffset];
        [splineMatrix replaceValue:2 row:rowOffset column:colOffset+1];
        [splineMatrix replaceValue:-6*xs[i] row:rowOffset column:colOffset+4];
        [splineMatrix replaceValue:-2 row:rowOffset column:colOffset+5];
    }
    
    
    
    
    // and finally the 2 boundary conditions (B.C.)
    switch (bcType) {
        case bc_endpointsSlope0:
            // For endpoints 3*A*xˆ2 + 2*B*x + C = 0
            [splineMatrix replaceValue:3*x2[0] row:matDim-2 column:0];
            [splineMatrix replaceValue:2*xs[0] row:matDim-2 column:1];
            [splineMatrix replaceValue:1 row:matDim-2 column:2];
            [splineMatrix replaceValue:3*x2[numSegs] row:matDim-1 column:matDim-4];
            [splineMatrix replaceValue:2*xs[numSegs] row:matDim-1 column:matDim-3];
            [splineMatrix replaceValue:1 row:matDim-1 column:matDim-2];
            break;
            
        case bc_endpointsCurve0:
            // For endpoints 6*A*x + 2*B = 0
            [splineMatrix replaceValue:6*xs[0] row:matDim-2 column:0];
            [splineMatrix replaceValue:2 row:matDim-2 column:1];
            [splineMatrix replaceValue:6*xs[numSegs] row:matDim-1 column:matDim-4];
            [splineMatrix replaceValue:2 row:matDim-1 column:matDim-3];
            break;
            
        case bc_endpointsSlopeCurveHarmonic:
            // 0 = first, 9=last
            
            // the first derivative is the same at the endpoints
            // 3*A0*x0ˆ2 + 2*B0*x0 - C0 - 3*A9*x10ˆ2 - 2*B9*x10 - C9 = 0
            [splineMatrix replaceValue:3*x2[0] row:matDim-2 column:0];
            [splineMatrix replaceValue:2*xs[0] row:matDim-2 column:1];
            [splineMatrix replaceValue:1 row:matDim-2 column:2];
            [splineMatrix replaceValue:-3*x2[numSegs] row:matDim-2 column:matDim-4];
            [splineMatrix replaceValue:-2*xs[numSegs] row:matDim-2 column:matDim-3];
            [splineMatrix replaceValue:-1 row:matDim-2 column:matDim-2];
            
            // the second derivative is the same at the endpoints
            //  6*A0*x0 + 2*B0 - 6*A9*x10 - 2*B9 = 0
            [splineMatrix replaceValue:6*xs[0] row:matDim-1 column:0];
            [splineMatrix replaceValue:2 row:matDim-1 column:1];
            [splineMatrix replaceValue:-6*xs[numSegs] row:matDim-1 column:matDim-4];
            [splineMatrix replaceValue:-2 row:matDim-1 column:matDim-3];
            break;
            
        default:
            // We'll make quadratic end segments the default
            // A0 = 0  and A9 = 0      Simple
            [splineMatrix replaceValue:1 row:matDim-2 column:0];
            [splineMatrix replaceValue:1 row:matDim-1 column:matDim-4];
            break;
    }
    
//    for (int i=0; i<matDim; i++) {
//        
//        NSString* str = ( i==0 ? @"[  " : @"   " );
//        for (int j=0; j<matDim; j++) {
//            float val = [splineMatrix valueInRow:i column:j];
//            float sign = (val<0?-1:1);
//            int int1 = (int)(val*sign);
//            int int2 = (int)(100*val) - 100*int1*(int)sign;
//            int2 *= (int)sign;
//            str = [str stringByAppendingFormat:@"  %@ %@%d.%d %@",(j==0 ? @"[" : @" "), ( val<0 ? @"-" : @" " )  ,int1,int2,(j==matDim-1? @"  ]" : @",")];
//        }
//        str = [str stringByAppendingFormat:( i==matDim-1 ? @"   ]" : @"" )];
//        NSLog(@"%@",str);
//    }
    
    
    // Now that we have the matrix all set up we need to get its inverse
    FloatMatrix* inverse = [MatrixManipulator invertFloatMatrix:splineMatrix];
    if ( !inverse ) {
        NSLog(@"SplineFitter: We were unable to create an inverse matrix");
        return nil;
    }
    
    // By multiplying the inverse matrix with the splineResult vector we get the values 
    // for the constants in the splines cubic equations
    FloatArray* splineSolution = [MatrixManipulator multiplyArray:splineResultant withMatrix:inverse];
    
    // and return a brand-spanking new spline
    return [Spline SplineWithPoints:points andSplineSolution:splineSolution];
}

@end
