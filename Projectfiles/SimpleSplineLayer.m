//
//  SimpleSplineLayer.m
//  SplineKobold
//
//  Created by Fredrik Carlsson
//  Released under MIT License.
//

#import "SimpleSplineLayer.h"


#define test_commit

#define INSET_L 5
#define INSET_R 5
#define INSET_T 52
#define INSET_B 5

#define NUM_POINTS_RENDERED 100

#define CLICK_DURATION 0.3
#define DOUBLE_CLICK_DELAY 0.3
#define LONG_HOLD_DURATION 0.6
#define TOUCH_RADIUS  15
#define STATIONARY_RADIUS 5

#define IM_WHITE_PIXEL  @"whitePixel.png"
#define IM_DOT @"white_dot.png"
#define IM_ADD  @"top-button-add.png"
#define IM_DEL @"top-button-cancel.png"
#define IM_PRINT @"top-button-print.png"
#define IM_ARROW @"arrow.png"
#define TOP_BUTTON_H 40
#define TOP_BUTTON_W 47

#define GRAY_C3          ccc3(200,200,200)
#define YELLOW_C3        ccc3(200,200,0)
#define YELLOW_DARK_C3   ccc3(100,100,0)
#define BLUE_C3          ccc3(0,0,200)
#define BLUE_DARK_C3     ccc3(0,0,100);

#define LAB_Y_OFFSET  -20
#define BC_BUTT_SCALE 0.8

CGPoint screenPtFromCurvePoint(CGPoint crvPt, CGPoint minCrv, CGPoint maxCrv, CGSize scrSz)
{	
    float xVal = (crvPt.x-minCrv.x)/(maxCrv.x-minCrv.x);
    float yVal = (crvPt.y-minCrv.y)/(maxCrv.y-minCrv.y);
    xVal = INSET_L + xVal*scrSz.width;
    yVal = INSET_B + yVal*scrSz.height;

	return ccp(xVal,yVal);
}
CGPoint curvePtFromScreenPoint(CGPoint scrPt, CGPoint minCrv, CGPoint maxCrv, CGSize scrSz)
{	
    float xVal = (scrPt.x-INSET_L)/scrSz.width;
    float yVal = (scrPt.y-INSET_R)/scrSz.height;
    xVal = xVal * (maxCrv.x-minCrv.x) + minCrv.x;
    yVal = yVal * (maxCrv.y-minCrv.y) + minCrv.y;
    
	return ccp(xVal,yVal);
}


@interface SimpleSplineLayer ()
{
    CGSize winsize;
    CGSize effectiveSize;
}
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
        effectiveSize = CGSizeMake(winsize.width-INSET_L-INSET_R, winsize.height-INSET_B-INSET_T);
        
        // add a dark red background
        CCSprite* redBack = [CCSprite spriteWithFile:IM_WHITE_PIXEL];
        CGSize redBackCS = redBack.contentSize;
        redBack.scaleX = effectiveSize.width / redBackCS.width;
        redBack.scaleY = effectiveSize.height / redBackCS.height;
        redBack.position = ccp(0.5*effectiveSize.width+INSET_L,0.5*effectiveSize.height+INSET_B);
        redBack.color = ccc3(100, 0, 0);
        [self addChild:redBack];

        // add the top buttons
        CCSprite* prtSpriteNor = [CCSprite spriteWithFile:IM_PRINT];
        CCSprite* prtSpriteSel = [CCSprite spriteWithFile:IM_PRINT];
        prtSpriteSel.color = GRAY_C3;
        printButton = [CCMenuItemSprite itemWithNormalSprite:prtSpriteNor selectedSprite:prtSpriteSel target:self selector:@selector(topButtonPressed:)];        
        CCSprite* addSpriteNor = [CCSprite spriteWithFile:IM_ADD];
        CCSprite* addSpriteSel = [CCSprite spriteWithFile:IM_ADD];
        addSpriteSel.color = GRAY_C3;
        addButton = [CCMenuItemSprite itemWithNormalSprite:addSpriteNor selectedSprite:addSpriteSel target:self selector:@selector(topButtonPressed:)];
        CCSprite* delSpriteNor = [CCSprite spriteWithFile:IM_DEL];
        CCSprite* delSpriteSel = [CCSprite spriteWithFile:IM_DEL];
        delSpriteSel.color = GRAY_C3;
        CCSprite* delSpriteDA = [CCSprite spriteWithFile:IM_DEL];
        delSpriteDA.opacity = 90;
        delButton = [CCMenuItemSprite itemWithNormalSprite:delSpriteNor selectedSprite:delSpriteSel disabledSprite:delSpriteDA target:self selector:@selector(topButtonPressed:)];
        delButton.isEnabled = NO;
        
        printButton.scaleX = TOP_BUTTON_W / printButton.contentSize.width;
        printButton.scaleY = TOP_BUTTON_H / printButton.contentSize.height;
        addButton.scaleX = TOP_BUTTON_W / addButton.contentSize.width;
        addButton.scaleY = TOP_BUTTON_H / addButton.contentSize.height;
        delButton.scaleX = TOP_BUTTON_W / delButton.contentSize.width;
        delButton.scaleY = TOP_BUTTON_H / delButton.contentSize.height;
        
        float offSetY = -0.5*TOP_BUTTON_H - 3;
        float offSetX = -2.5*TOP_BUTTON_W - 5;
        printButton.position = ccp(winsize.width + offSetX, winsize.height + offSetY);
        offSetX += TOP_BUTTON_W;
        addButton.position = ccp(winsize.width + offSetX, winsize.height + offSetY);
        offSetX += TOP_BUTTON_W;
        delButton.position = ccp(winsize.width + offSetX, winsize.height + offSetY);
        
        CCMenu* topButtons = [CCMenu menuWithItems:printButton,addButton,delButton,nil];
        topButtons.position = ccp(0,0);
        [self addChild:topButtons];
        
        
        // Add the bc-type stuff
        CCSprite* arrNorR = [CCSprite spriteWithFile:IM_ARROW];
        CCSprite* arrSelR = [CCSprite spriteWithFile:IM_ARROW];
        arrSelR.color = GRAY_C3;
        bcTypeNext = [CCMenuItemSprite itemWithNormalSprite:arrNorR selectedSprite:arrSelR target:self selector:@selector(topButtonPressed:)];
        bcTypeNext.anchorPoint = ccp(0.5,0.5);
        bcTypeNext.position = ccp(300,winsize.height-25);
        bcTypeNext.scale = BC_BUTT_SCALE;
        [topButtons addChild:bcTypeNext];
        CCSprite* arrNorL = [CCSprite spriteWithFile:IM_ARROW];
        CCSprite* arrSelL = [CCSprite spriteWithFile:IM_ARROW];
        arrSelL.color = GRAY_C3;
        bcTypePrev = [CCMenuItemSprite itemWithNormalSprite:arrNorL selectedSprite:arrSelL target:self selector:@selector(topButtonPressed:)];
        bcTypePrev.anchorPoint = ccp(0.5,0.5);
        bcTypePrev.position = ccp(160,winsize.height-25);
        bcTypePrev.rotation = 180;
        bcTypePrev.scale = BC_BUTT_SCALE;
        [topButtons addChild:bcTypePrev];
        
        numControlSpritesChanged = YES;
        controlPoints = [PointList pointListWithCapacity:5];
        [controlPoints addPoint:ccp(0,0)];
        [controlPoints addPoint:ccp(.2,.1)];
        [controlPoints addPoint:ccp(.5,.5)];
        [controlPoints addPoint:ccp(.8,.9)];
        [controlPoints addPoint:ccp(1,1)];
        bcType = bc_endpointsSlope0;
        
        [self updateLabelBC];
        
        minPt = ccp(0,-1);
        maxPt = ccp(1,1);
        [self updatePoints];
        
        
        [self scheduleUpdate];
    }
    return self;
}


-(void)updateCoordLabel {
    
    if ( coordLabel ) {
        [self removeChild:coordLabel cleanup:YES];
        coordLabel = nil;
    }
    
    if ( currentControlSprite ) {
        CGPoint pt = [controlPoints pointAtIndex:currentControlSprite.tag];
        NSString* coords = [NSString stringWithFormat:@"(%f,%f)",pt.x,pt.y];
        coordLabel = [CCLabelTTF labelWithString:coords fontName:@"Marker Felt" fontSize:13];
        coordLabel.anchorPoint = ccp(0,1);
        coordLabel.position = CGPointMake(5,winsize.height+LAB_Y_OFFSET);
        coordLabel.color = ccWHITE;
        [self addChild:coordLabel];
    }
}


-(void)onEnter {
    
    [super onEnter];
}

-(void)topButtonPressed:(id)sender {
    
    if ( sender == addButton ) {
        
        int count = 0;
        BOOL foundValidPt;
        CGPoint newCP;
        while ( !foundValidPt && count<15 ) {
            float newXVal = minPt.x + CCRANDOM_0_1()*(maxPt.x-minPt.x);
            float newYVal = [spline yForXVal:newXVal];
            newCP = ccp(newXVal,newYVal);
            if ( minPt.x < newXVal < maxPt.x && minPt.y < newYVal < maxPt.y ) {
                foundValidPt = YES;
            }
            count += 1;
        }
        
        newCP.x = MAX(minPt.x,MIN(maxPt.x,newCP.x));
        newCP.y = MAX(minPt.y,MIN(maxPt.y,newCP.y));
        // Insert the new point, but do not let it become one of the endpoints
        [controlPoints insertPointAtIndex:([controlPoints numPoints]-1) withPoint:newCP];
        numControlSpritesChanged = YES;
        [self updatePoints];
    }
    
    if ( currentControlSprite  &&  sender == delButton ) {
        [controlPoints deletePointAtIndex:currentControlSprite.tag];
        numControlSpritesChanged = YES;
        delButton.isEnabled = NO;
        [self updatePoints];
    }
    
    if ( sender == printButton ) {
        
        PointList* orderedPts = [controlPoints orderedPoints];
        int numP = [orderedPts numPoints];
        
        CCLOG(@"  ");
        CCLOG(@"  ");
        for (int i=0; i<numP; i++) {
            CGPoint pt = [orderedPts pointAtIndex:i];
            CCLOG(@"Pt%d = { %f , %f }",i,pt.x,pt.y);
        }
        CCLOG(@"  ");
        CCLOG(@"  ");
    }
    
    if ( sender == bcTypePrev || sender == bcTypeNext ) {
        int diff = ( sender == bcTypePrev ? bc_num_types-1 : 1 );
        bcType = ( bcType + diff ) % bc_num_types;
        [self updateLabelBC];
        [self updatePoints];
    }
}

-(void)updateLabelBC {
    
    if ( bcTypeLabel ) {
        [self removeChild:bcTypeLabel cleanup:YES];
        bcTypeLabel = nil;
    }
    
    NSString* bcStr;
    if ( bcType == bc_endpointsCurve0 ) {
        bcStr = @"BC: curve 0";
    }
    else if ( bcType == bc_endpointsSlope0 ) {
        bcStr = @"BC: slope 0";
    }
    else if ( bcType == bc_leftSlope0rightCurve0 ) {
        bcStr = @"BC: slp(L)=0 crv(R)=0";
    }
    else if ( bcType == bc_leftCurve0leftSlope0 ) {
        bcStr = @"BC: crv(L)=0 slp(R)=0";
    }
    else if ( bcType == bc_endpointsSlopeCurveHarmonic ) {
        bcStr = @"BC: harmonic";
    }
    else if ( bcType == bc_endsegmentsQuadratic ) {
        bcStr = @"BC: quadratic";
    }
    else {
        bcStr = @"BC: invalid";
    }
    
    bcTypeLabel = [CCLabelTTF labelWithString:bcStr fontName:@"Marker Felt" fontSize:12];
    bcTypeLabel.anchorPoint = ccp(0.5,1);
    bcTypeLabel.position = ccp(0.5*(bcTypePrev.position.x+bcTypeNext.position.x),winsize.height + LAB_Y_OFFSET);
    bcTypeLabel.color = ccWHITE;
    [self addChild:bcTypeLabel];
}


-(void)updatePoints {
    
    PointList* orderedPoints = [controlPoints orderedPoints];
    Spline* newSpline = [SplineFitter splineForPoints:orderedPoints andBoundaryConditions:bcType];
    if ( newSpline ) { // the new spline will be nil if any x-Coords in orderedPoints are the same. Degeenerate matrix.
        spline = newSpline;
    }
    
    if ( !pointSprites ) {
        pointSprites = [NSMutableArray arrayWithCapacity:NUM_POINTS_RENDERED+1];
        for (int i=0; i<NUM_POINTS_RENDERED+1; i++) {
            CCSprite* sprite = [CCSprite spriteWithFile:IM_WHITE_PIXEL];
            sprite.color = ccc3(1, 199, 1);
            sprite.scale = 2.5;
            [self addChild:sprite];
            [pointSprites addObject:sprite];
        }
    }
    
    if ( numControlSpritesChanged ) {
        numControlSpritesChanged = NO;
        currentControlSprite = nil;
        if ( controlPointsNode ) {
            [controlPointsNode removeAllChildrenWithCleanup:YES];
        }
        else {
            controlPointsNode = [CCNode node];
            controlPointsNode.position = CGPointZero;
            [self addChild:controlPointsNode];
        }
        
        int numCP = [controlPoints numPoints];
        for (int i=0; i<numCP; i++) {
            CCSprite* sp = [CCSprite spriteWithFile:IM_DOT];
            sp.color = BLUE_C3;
            [controlPointsNode addChild:sp];
            sp.tag = i;
        }
    }
    [self updateCoordLabel];
        
    for (int i=0; i<NUM_POINTS_RENDERED+1; i++) {
        
        float xVal = minPt.x + (float)i*(maxPt.x-minPt.x) / (float)NUM_POINTS_RENDERED;
        float yVal = [spline yForXVal:xVal];
        
        CGPoint pt = screenPtFromCurvePoint(ccp(xVal,yVal),minPt,maxPt,effectiveSize);
        
        CCSprite* sprite = [pointSprites objectAtIndex:i];
        sprite.position = pt;
    }
    
    // and the control points
    for (CCSprite* child in controlPointsNode.children) {
        CGPoint pt = [controlPoints pointAtIndex:child.tag];
        pt = screenPtFromCurvePoint(pt, minPt, maxPt, effectiveSize);
        child.position = pt;
    }
}

-(void)update:(ccTime)delta {
    
    KKInput* input = [KKInput sharedInput];
    if ( [input touchesAvailable] ) {
        
        KKTouch* touch = [input.touches objectAtIndex:0];
        CGPoint touchPt = [touch location];
                
        if (touch.phase == KKTouchPhaseBegan) {
            
            // reset any possible chosen point
            if ( currentControlSprite ) {
                currentControlSprite.color = BLUE_C3;
                currentControlSprite = nil;
                delButton.isEnabled = NO;
            }

            for (CCSprite* child in controlPointsNode.children) {
                
                if ([child containsPoint:touchPt]) {
                    currentControlSprite = child;
                    currentControlSprite.color = YELLOW_C3;
                    
                    BOOL enableDelButton = ( [controlPoints numPoints] > 3 );
                    enableDelButton &= ( currentControlSprite.tag != 0 && currentControlSprite.tag != ([controlPoints numPoints]-1) );
                    delButton.isEnabled = enableDelButton;
                    break;
                }
            }
            [self updateCoordLabel];
        }
        
        if (touch.phase == KKTouchPhaseMoved || touch.phase == KKTouchPhaseStationary) {
            
            if ( currentControlSprite ) {
                CGPoint curvePt = curvePtFromScreenPoint(touchPt, minPt, maxPt, effectiveSize);
                curvePt.x = max(curvePt.x, minPt.x);
                curvePt.x = min(curvePt.x, maxPt.x);
                curvePt.y = max(curvePt.y, minPt.y);
                curvePt.y = min(curvePt.y, maxPt.y);
                if ( currentControlSprite.tag == 0 ) {
                    curvePt.x = minPt.x;
                }
                if ( currentControlSprite.tag == ([controlPoints numPoints]-1) ) {
                    curvePt.x = maxPt.x;
                }
                [controlPoints replacePointAtIndex:currentControlSprite.tag withPoint:curvePt];
                
                [self updatePoints];
            }
        }
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





















