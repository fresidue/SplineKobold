//
//  FloatArray.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

#import <Foundation/Foundation.h>

@interface FloatArray : NSObject
{
    NSMutableArray* fVals;
}

+(id)floatArray;
+(id)floatArrayWithCapacity:(int)capacity;
-(id)initWithCapacity:(int)capacity;
-(int)count;
-(void)addValue:(float)val;
-(void)insertValue:(float)val atIndex:(int)index;
-(void)replaceValue:(float)val atIndex:(int)index;
-(void)removeValueAtIndex:(int)index;
-(void)insertValueAt0:(float)val;
-(float)valueAtIndex:(int)index;

@end
