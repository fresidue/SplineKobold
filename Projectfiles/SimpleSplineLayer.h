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
    CCMenuItemSprite* addButton;
    CCMenuItemSprite* delButton;
    CCMenuItemSprite* printButton;
    
//    NSMutableArray* controlSprites;
    
    // keep track of control point touching
//    CCMenu* controlMenu;
    CCNode* controlPointsNode;
    PointList* controlPoints;
    CCSprite* currentControlSprite;
//    CCMenuItemSprite* currentControlPoint;
    BOOL numControlSpritesChanged;
//    int touchedIndex;
//    BOOL touchedIndexBeingTouched;
//    BOOL touchedIndexMoved;
//    BOOL touchedIndexBeingLongTouched;
//    CGPoint touchStartPoint;
//    NSDate* touchStartDate;
//    int clickedIndex;
//    NSDate* clickedDate;
    
    Spline* spline;
    BoundaryConditionType bcType;
    CGPoint minPt;
    CGPoint maxPt;
    
    NSMutableArray* pointSprites;
}

+(CCScene*)scene;

@end
