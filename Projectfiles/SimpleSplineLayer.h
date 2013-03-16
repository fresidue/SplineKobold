//
//  SimpleSplineLayer.h
//  SplineKobold
//
//  Created by Fredrik Carlsson
//  Released under MIT License.
//

#import "kobold2d.h"
#import "spline_algebra.h"

@interface SimpleSplineLayer : CCLayer
{
    CCMenuItemSprite* addButton;
    CCMenuItemSprite* delButton;
    CCMenuItemSprite* printButton;
    
    CCLabelTTF* coordLabel;
    
    CCNode* controlPointsNode;
    PointList* controlPoints;
    CCSprite* currentControlSprite;
    BOOL numControlSpritesChanged;
    
    Spline* spline;
    BoundaryConditionType bcType;
    CGPoint minPt;
    CGPoint maxPt;
    
    NSMutableArray* pointSprites;
}

+(CCScene*)scene;

@end
