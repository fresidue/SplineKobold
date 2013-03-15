//
//  FloatMatrix.m
//  UIKitty_2
//
//  Created by Fredrik Carlsson on 3/5/13.
//  Copyright (c) 2013 Malmö Yrkeshögskola. All rights reserved.
//

#import "FloatMatrix.h"
#import "FloatArray.h"

@implementation FloatMatrix 

+(id)FloatMatrixWithDimension:(int)n {
    return [[FloatMatrix alloc] initWithDimension:n];
}

+(id)FloatMatrixWithFlattenedFloatArray:(FloatArray*)matrix1D  withDim:(int)matDim{
    
    return [[FloatMatrix alloc] initWithFlattenedFloatArray:matrix1D withDim:matDim];
}

-(id)initWithFlattenedFloatArray:(FloatArray*)matrix1D withDim:(int)matDim{

    if ( matrix1D.count != matDim*matDim ) {
        return nil;
    }
    
    if ( self=[super init] ) {
        dim = matDim;
        mat = [NSMutableArray arrayWithCapacity:dim];
        for (int i=0; i<dim; i++) {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:dim];
            for (int j=0; j<dim; j++) {
                [row addObject:[NSNumber numberWithFloat:[matrix1D valueAtIndex:(i*dim+j)]]];
            }
            [mat addObject:row];
        }
    }
    return self;
}


+(id)FloatMatrixWithFloatMatrix:(FloatMatrix*)matrix {
    return [[FloatMatrix alloc] initWithFloatMatrix:matrix];
}

-(id)initWithFloatMatrix:(FloatMatrix*)matrix {
    if ( self = [super init] ) {
        dim = [matrix dimension];
        mat = [NSMutableArray arrayWithCapacity:dim];
        for (int i=0; i<dim; i++) {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:dim];
            for (int j=0; j<dim; j++) {
                [row addObject:[NSNumber numberWithFloat:[matrix valueInRow:i column:j]]];
            }
            [mat addObject:row];
        }
    }
    return self;
}

+(id)IdentityMatrixForDimension:(int)n {
    
    FloatMatrix* idMat = [[FloatMatrix alloc] initWithDimension:n];
    for (int i=0; i<n; i++) {
        [idMat replaceValue:1 row:i column:i];
    }
    return idMat;
}


-(id)initWithDimension:(int)n {
    if ( self = [super init] ) {
        dim = n;
        mat = [NSMutableArray arrayWithCapacity:dim];
        for (int i=0; i<dim; i++) {
            NSMutableArray* row = [NSMutableArray arrayWithCapacity:dim];
            for (int j=0; j<dim; j++) {
                [row addObject:[NSNumber numberWithFloat:0]];
            }
            [mat addObject:row];
        }
    }
    return self;
}

-(id)init {
    if ( self = [super init] ) {
        dim = 0;
        mat = [NSMutableArray array];
    }
    return self;
}

-(float)valueInRow:(int)row column:(int)col {
    return [[[mat objectAtIndex:row] objectAtIndex:col] floatValue];
}

-(void)replaceValue:(float)val row:(int)row column:(int)col {
    
    NSMutableArray* rowArr = [mat objectAtIndex:row];
    [rowArr replaceObjectAtIndex:col withObject:[NSNumber numberWithFloat:val]];
}

-(int)dimension {
    return dim;
}

-(FloatArray*)flatCopy {
    int len = dim*dim;
    FloatArray* rv = [FloatArray floatArrayWithCapacity:len];
    for (int i=0; i<dim; i++) {
        for (int j=0; j<dim; j++) {
            float currVal = [self valueInRow:i column:j];
            [rv addValue:currVal];//[self valueInRow:i column:j]];
        }
    }
    return rv;
}

@end
