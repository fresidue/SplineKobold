//
//  Spline.m
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import "Spline.h"
#import "PointList.h"
#import "FloatArray.h"

@implementation Spline


+(id)SplineWithPoints:(PointList*)pts andSplineSolution:(FloatArray*)splineSol {
    return [[Spline alloc] initWithPoints:pts andSplineSolution:splineSol];
}

-(id)initWithPoints:(PointList*)pts andSplineSolution:(FloatArray*)splineSol {
    
    if ( self = [super init] ) {
        points = pts;
        splineSolution = splineSol;
    }
    return self;
}


-(id)init {
    // I do not want init used for this one
    return nil;
}

-(float)firstXVal {
    return [points pointAtIndex:0].x;
}

-(float)lastXVal {
    return [points pointAtIndex:([points numPoints]-1)].x;
}

-(float)yForXVal:(float)xVal {
    
    // I'm kind of assuming smart usage. The spline is intended to be a proper function
    // i.e. the x-values really ought to be in ascending order
    // Sure not going to do any checks on it though. Just make it approximately failsafe
    
    int numPoints = [points numPoints];
    int numSegs = numPoints-1;
    
    int equationIndex;
    if ( xVal < [self firstXVal] ) {
        // use the first equation
        equationIndex = 0;
    }
    else if ( xVal >= [self lastXVal] ) {
        // use the last equation
        equationIndex = numSegs-1;
    }
    else {
        for (int i=1; i<numPoints; i++) {
            
            if ( xVal < [points pointAtIndex:i].x ) {
                equationIndex = i-1;
                break;
            }
        }
    }
    
    float x2 = xVal*xVal;
    float x3 = x2*xVal;
    float a = [splineSolution valueAtIndex:(4*equationIndex)];
    float b = [splineSolution valueAtIndex:(4*equationIndex+1)];
    float c = [splineSolution valueAtIndex:(4*equationIndex+2)];
    float d = [splineSolution valueAtIndex:(4*equationIndex+3)];
    
    return ( a*x3 + b*x2 + c*xVal + d );
}

-(float)determineXfromYValue:(float)yVal withThresholdFactor:(float)threshFactor maxIterations:(int)maxIterations {
    
    // a couple of things need to be noted about this function
    // 1 - Don't be stupid (just putting it out there)
    // Basically, if we have a monotonic function, we might want to get the inverse
    // Note: this ASSUMES a monotonic function ..
    
    float minX = [self firstXVal];
    float maxX = [self lastXVal];
    float minY = [self yForXVal:minX];
    float maxY = [self yForXVal:maxX];
    
    if ( minY > maxY ) {
        float temp = minX;
        minX = maxX;
        maxX = temp;
        temp = minY;
        minY = maxY;
        maxY = minY;
    }
    
    if ( yVal<minY ) {
        return minX;
    }
    if ( yVal>maxY ) {
        return maxX;
    }
    
    // determine the absolute threshold value
    float thresh = threshFactor * (maxY-minY);
    // and let's make sure we have a positive value for the limit
    maxIterations *= ( maxIterations<0 ? -1 : 1 );
    for (int i=0; i<maxIterations; i++) {
        float newX = minX + 0.5*(maxX-minX);
        float newY = [self yForXVal:newX];
        
        // return something if we can
        if ( fabsf(newY-yVal) < thresh ) {
            return newX;
        }
        
        // otherwise amend the limits
        if ( newY < yVal ) {
            minX = newX;
        }
        else {
            maxX = newX;
        }
    }
    
    // we ran out of chances. This is really very unlikely to happen.
    // I think it converges really quicklike. 3-4 iterations normally.
    // Suppose it's possible if you put some ridiculous effort into it....
    return minX;
}


@end
