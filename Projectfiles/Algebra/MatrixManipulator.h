//
//  MatrixManipulator.h
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

#import <Foundation/Foundation.h>
@class FloatMatrix;
@class FloatArray;


@interface MatrixManipulator : NSObject


+(FloatArray*)invertMatrixNxN:(FloatArray*)matrix1D withDim:(int)dim;
+(FloatMatrix*)invertFloatMatrix:(FloatMatrix*)matrix;

+(FloatArray*)multiplyArray:(FloatArray*)arr withMatrix:(FloatMatrix*)mat;

@end
