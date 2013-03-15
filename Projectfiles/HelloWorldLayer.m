/*
 * Kobold2D™ --- http://www.kobold2d.org
 *
 * Copyright (c) 2010-2011 Steffen Itterheim. 
 * Released under MIT License in Germany (LICENSE-Kobold2D.txt).
 */

#import "HelloWorldLayer.h"
#import "SimpleSplineLayer.h"


@interface HelloWorldLayer ()
{
    CGSize winsize;
}
@end

@implementation HelloWorldLayer

-(id) init
{
	if ((self = [super init])) 
	{
        winsize = [[CCDirector sharedDirector] winSize];
        winsize = CGSizeMake(winsize.height, winsize.width);
        
 		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Basic Spline" fontName:@"Marker Felt" fontSize:16];
		label.position = CGPointMake(0,0);
		label.color = ccGREEN;
        
        CCMenuItemLabel* labItem1 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(menuItemPressed:)];
        labItem1.position = CGPointMake(0.5*winsize.width, winsize.height-50);
        labItem1.tag = 1;
        
//        [self addChild:labItem1];
        
        CCMenu* menu = [CCMenu menuWithItems:labItem1, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
        
//		[self addChild:label];
		
//		[self scheduleUpdate];
	}
	return self;
}

-(void)menuItemPressed:(id)sender {
    
    int tag = ((CCMenuItem*)sender).tag;
    if ( tag == 1 ) {
        NSLog(@"Pressed basic spline");
        [[CCDirector sharedDirector] replaceScene:[SimpleSplineLayer scene]];
    }
}



-(void) update:(ccTime)delta
{
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
}

@end