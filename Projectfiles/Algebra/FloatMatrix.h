//
//  FloatMatrix.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

#import <Foundation/Foundation.h>
@class FloatArray;

@interface FloatMatrix : NSObject
{
    int dim;
    NSMutableArray* mat;
}

+(id)IdentityMatrixForDimension:(int)n;
+(id)FloatMatrixWithDimension:(int)n;
-(id)initWithDimension:(int)n;
+(id)FloatMatrixWithFloatMatrix:(FloatMatrix*)matrix;
-(id)initWithFloatMatrix:(FloatMatrix*)matrix;
+(id)FloatMatrixWithFlattenedFloatArray:(FloatArray*)matrix1D withDim:(int)matDim;
-(id)initWithFlattenedFloatArray:(FloatArray*)matrix1D withDim:(int)matDim;

-(float)valueInRow:(int)row column:(int)col;
-(void)replaceValue:(float)val row:(int)row column:(int)col;
-(int)dimension;

-(FloatArray*)flatCopy;

@end
