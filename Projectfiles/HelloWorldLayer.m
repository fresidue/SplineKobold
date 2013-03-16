//  HelloWorldLayer.m
//  SplineKobold
//
//  Created by Fredrik Carlsson
//  Released under MIT License.
//

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
        
 		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Basic Spline" fontName:@"Marker Felt" fontSize:30];
		label.position = CGPointMake(0,0);
		label.color = ccGREEN;
        CCMenuItemLabel* labItem1 = [CCMenuItemLabel itemWithLabel:label target:self selector:@selector(menuItemPressed:)];
        labItem1.position = CGPointMake(0.5*winsize.width, winsize.height-100);
        labItem1.tag = 1;
        CCMenu* menu = [CCMenu menuWithItems:labItem1, nil];
        menu.position = CGPointZero;
        [self addChild:menu];
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


@end