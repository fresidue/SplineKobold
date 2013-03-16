//
//  MatrixManipulator.m
//  SplineKobold
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Released under MIT License.
//

#import "MatrixManipulator.h"
#import "FloatMatrix.h"
#import "FloatArray.h"
#include <Accelerate/Accelerate.h>



//int matrix_invert(int N, double *matrix) {
//    int error=0;
//    int *pivot = malloc(N*N*sizeof(int));
//    double *workspace = malloc(N*sizeof(double));
//    
//    dgetrf_(&N, &N, matrix, &N, pivot, &error);
//    
//    if (error != 0) {
//        NSLog(@"Error 1");
//        return error;
//    }
//    
//    dgetri_(&N, matrix, &N, pivot, workspace, &N, &error);
//    
//    if (error != 0) {
//        NSLog(@"Error 2");
//        return error;
//    }
//    
//    free(pivot);
//    free(workspace);
//    return error;
//}


@implementation MatrixManipulator

+(FloatArray*)invertMatrixNxN:(FloatArray*)matrix1D withDim:(int)dim {
    
    if ( !matrix1D ) {
        return nil;
    }
    
    int len = matrix1D.count;
    if ( dim*dim != len ) {
        return nil;
    }
    
    __CLPK_doublereal drMat[len];
    for (int i=0; i<len; i++) {
        float currVal = [matrix1D valueAtIndex:i];
        drMat[i] = (__CLPK_doublereal)currVal;
    }
    
    ///////////////////////////////////////////////////////
    // Invert beginning
    ///////////////////////////////////////////////////////
    
    __CLPK_integer N = (__CLPK_integer)dim;
    
    __CLPK_integer error = (__CLPK_integer)0;
    __CLPK_integer *pivot = malloc(dim*dim*sizeof(__CLPK_integer));
    __CLPK_doublereal *workspace = malloc(dim*sizeof(__CLPK_doublereal));
    
    dgetrf_(&N, &N, drMat, &N, pivot, &error);
    
    if (error != 0) {
        NSLog(@"MatrixManiuplator:Inversion - Error 1");
        return nil;
    }
    
    dgetri_(&N, drMat, &N, pivot, workspace, &N, &error);
    
    if (error != 0) {
        NSLog(@"MatrixManiuplator:Inversion - Error 2");
        return nil;
    }
    
    free(pivot);
    free(workspace);
    
    ///////////////////////////////////////////////////////
    // Invert end
    ///////////////////////////////////////////////////////
    
    
    FloatArray* rv = [FloatArray floatArrayWithCapacity:len];
    for (int i=0; i<len; i++) {
        __CLPK_doublereal currVal = drMat[i];
        [rv addValue:(float)currVal];
    }
    return rv;
}

+(FloatMatrix*)invertFloatMatrix:(FloatMatrix*)matrix {
    
    FloatArray* flatRV = [MatrixManipulator invertMatrixNxN:[matrix flatCopy] withDim:[matrix dimension]];
    return [FloatMatrix FloatMatrixWithFlattenedFloatArray:flatRV withDim:[matrix dimension]];
}


+(FloatArray*)multiplyArray:(FloatArray*)arr withMatrix:(FloatMatrix*)mat {
    
    int dim = [arr count];

    // the two must have a common dimension
    if ( [arr count] != [mat dimension] ) {
        return nil;
    }
    
    FloatArray* rv = [FloatArray floatArrayWithCapacity:dim];
    for (int i=0; i<dim; i++) {
        float sum = 0;
        for (int j=0; j<dim; j++) {
            sum += [mat valueInRow:i column:j] * [arr valueAtIndex:j];
        }
        [rv addValue:sum];
    }
    
    return rv;
}

@end
