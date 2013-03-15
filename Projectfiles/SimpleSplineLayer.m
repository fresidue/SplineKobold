//
//  SimpleSplineLayer.m
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/14/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import "SimpleSplineLayer.h"


#define test_commit

#define INSET 5
#define NUM_POINTS_RENDERED 100

@interface SimpleSplineLayer ()
{
    CGSize winsize;
    CGSize effectiveSize;
}
-(void)updateSpline;
@end


@implementation SimpleSplineLayer

+(CCScene*)scene {
    
    CCScene* scene = [CCScene new];
    [scene addChild:[SimpleSplineLayer new]];
    return scene;
}

-(id)init {
    
    if ( self=[super init] ) {
        
        winsize = [[CCDirector sharedDirector] winSize];
        effectiveSize = CGSizeMake(winsize.width-2*INSET, winsize.height-2*INSET);
        
        // add a dark red background
        CCSprite* redBack = [CCSprite spriteWithFile:@"whitePixel.png"];
        CGSize redBackCS = redBack.contentSize;
        redBack.scaleX = effectiveSize.width / redBackCS.width;
        redBack.scaleY = effectiveSize.height / redBackCS.height;
        redBack.position = ccp(0.5*winsize.width,0.5*winsize.height);
        redBack.color = ccc3(100, 0, 0);
        [self addChild:redBack];
        
        numControlSpritesChanged = YES;
        controlPoints = [PointList pointListWithCapacity:3];
        [controlPoints addPoint:ccp(0,0)];
        [controlPoints addPoint:ccp(.2,.1)];
        [controlPoints addPoint:ccp(.5,.5)];
        [controlPoints addPoint:ccp(.8,.9)];
        [controlPoints addPoint:ccp(1,1)];
        bcType = bc_endpointsSlope0;
        [self updateSpline];
        splineIsCurrent = YES;
        
        minPt = ccp(0,-1);
        maxPt = ccp(1,1);
        [self updatePoints];
        
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)updateSpline {
    
    spline = [SplineFitter splineForPoints:controlPoints andBoundaryConditions:bcType];
    splineIsCurrent = YES;
}

-(void)updatePoints {
    
    if ( !splineIsCurrent ) {
        [self updateSpline];
    }

    if ( !pointSprites ) {
        pointSprites = [NSMutableArray arrayWithCapacity:NUM_POINTS_RENDERED+1];
        for (int i=0; i<NUM_POINTS_RENDERED+1; i++) {
            CCSprite* sprite = [CCSprite spriteWithFile:@"whitePixel.png"];
            sprite.color = ccc3(1, 199, 1);
            sprite.scale = 2.5;
            [self addChild:sprite];
            [pointSprites addObject:sprite];
        }
    }
    
    if ( numControlSpritesChanged ) {
        if ( controlSprites ) {
            while ( controlSprites.count > 0 ) {
                CCSprite* sp = [controlSprites lastObject];
                [controlSprites removeLastObject];
                [self removeChild:sp cleanup:YES];
            }
        }
        else {
            controlSprites = [NSMutableArray arrayWithCapacity:[controlPoints numPoints]];
        }
        
        int numCP = [controlPoints numPoints];
        for (int i=0; i<numCP; i++) {
            CCSprite* sp = [CCSprite spriteWithFile:@"whitePixel.png"];
            sp.color = ccc3(2,2,180);
            sp.scale = 15;
            [self addChild:sp];
            [controlSprites addObject:sp];
        }
    }
    
    for (int i=0; i<NUM_POINTS_RENDERED+1; i++) {
        
        float xVal = minPt.x + (float)i*(maxPt.x-minPt.x) / (float)NUM_POINTS_RENDERED;
        float yVal = [spline yForXVal:xVal];
        
        xVal = ( xVal - minPt.x )/( maxPt.x - minPt.x );
        yVal = ( yVal - minPt.y )/( maxPt.y - minPt.y );
        
        xVal = INSET + xVal*effectiveSize.width;
        yVal = INSET + yVal*effectiveSize.height;
        
        CGPoint pt = ccp(xVal,yVal);
        CCSprite* sprite = [pointSprites objectAtIndex:i];
        sprite.position = pt;
    }
    
    // and the control points
    int numCP = [controlPoints numPoints];
    for (int i=0; i<numCP; i++) {
        
        CGPoint pt = [controlPoints pointAtIndex:i];
        float xVal = pt.x;
        float yVal = pt.y;

        xVal = ( xVal - minPt.x )/( maxPt.x - minPt.x );
        yVal = ( yVal - minPt.y )/( maxPt.y - minPt.y );
        
        xVal = INSET + xVal*effectiveSize.width;
        yVal = INSET + yVal*effectiveSize.height;
        
        pt = ccp(xVal,yVal);
        CCSprite* sprite = [controlSprites objectAtIndex:i];
        sprite.position = pt;
    }
}

-(void)update:(ccTime)delta {
    
    BOOL shouldRedraw;
    KKInput* input = [KKInput sharedInput];
    
    KKTouch* touch;
    CCARRAY_FOREACH(input.touches, touch)
    {
        if (touch.phase == KKTouchPhaseBegan)
        {
        }
    }
    
    if (input.isAnyMouseButtonDownThisFrame)
    {
    }


    if ( shouldRedraw ) {
    }
    
}

//static BOOL printPoints = YES;
//-(void)draw {
//    
//    [super draw];
//
//    if ( !splineIsCurrent ) {
//        [self updateSpline];
//    }
//    
//    ccPointSize(100);
//    ccDrawColor4F(0, 0, 0, .5);
//    ccDrawPoint(CGPointMake(300, 300));
//
//    ccPointSize(5.0f);
//    ccDrawColor4B(100, 100, 100, 100);
//    ccDrawColor4B(0.0f, 0.7f, 0.0f, 1.0f);
//    CGPoint* drawPoints = calloc((NUM_POINTS_RENDERED+1), sizeof(CGPoint));
//    for (int i=0; i<NUM_POINTS_RENDERED+1; i++) {
// 
//        float xVal = minPt.x + (float)i*(maxPt.x-minPt.x) / (float)NUM_POINTS_RENDERED;
//        float yVal = [spline yForXVal:xVal];
//        
//        xVal = ( xVal - minPt.x )/( maxPt.x - minPt.x );
//        xVal = ( yVal - minPt.y )/( maxPt.y - minPt.y );
//        
//        xVal = INSET + xVal*effectiveSize.width;
//        yVal = INSET + yVal*effectiveSize.height;
//        
//        CGPoint pt = ccp(xVal,yVal);
//        ccDrawPoint(pt);
//        drawPoints[i] = CGPointMake(xVal, yVal);
//        if ( printPoints ) {
//            NSLog(@"Point[%d] = ( %f , %f )",i,drawPoints[i].x,drawPoints[i].y);
//        }
//    }
//    printPoints = NO;
//    ccDrawPoints(drawPoints, NUM_POINTS_RENDERED+1);
//    free(drawPoints);
//}

@end





















