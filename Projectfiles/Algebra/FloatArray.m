//
//  FloatArray.m
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

#import "FloatArray.h"

@implementation FloatArray

+(id)floatArray {
    return [[FloatArray alloc] init];
}

+(id)floatArrayWithCapacity:(int)capacity {
    return [[FloatArray alloc] initWithCapacity:capacity];
}

-(id)initWithCapacity:(int)capacity {
    
    if ( self=[super init] ) {
        fVals = [NSMutableArray arrayWithCapacity:capacity];
    }
    return self;
}

-(id)init {
    
    if ( self=[super init] ) {
        fVals = [NSMutableArray array];
    }
    return self;
}

-(int)count {
    return fVals.count;
}

-(void)addValue:(float)val {
    [fVals addObject:[NSNumber numberWithFloat:val]];
}

-(void)insertValue:(float)val atIndex:(int)index {
    [fVals insertObject:[NSNumber numberWithFloat:val] atIndex:index];
}
     
-(void)replaceValue:(float)val atIndex:(int)index {
    [fVals replaceObjectAtIndex:index withObject:[NSNumber numberWithFloat:val]];
}

-(void)removeValueAtIndex:(int)index {
    [fVals removeObjectAtIndex:index];
}

-(void)insertValueAt0:(float)val {
    [fVals insertObject:[NSNumber numberWithFloat:val] atIndex:0];
}

-(float)valueAtIndex:(int)index {
    return [[fVals objectAtIndex:index] floatValue];
}


@end
