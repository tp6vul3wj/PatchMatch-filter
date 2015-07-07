#include "math.h"
#include "mex.h"
#include <iostream>
#define VAR(x)  #x " = " << x

using namespace std;


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    //parameters - image
    //             patchsize
    // output - all patches
    
    // process input data
    const mxArray *inImage=prhs[0];
    const int S=(int)mxGetScalar(prhs[1]);
    const int S2=2*S+1;
    const int SS22=S2*S2;
    double *inPixels=mxGetPr(inImage);
    
    int D=mxGetNumberOfDimensions(inImage);
    const mwSize *imgSize=mxGetDimensions(inImage);
    
    mexPrintf("D=%i: ",D);
    for(int d=0;d<D;++d) {mexPrintf("%i ", imgSize[d]);} mexPrintf("\n");
    
    int H=mxGetM(inImage);
    int W=imgSize[1];
    int Z=1;
    if(D==3) {Z=imgSize[2];}
    
    // prepare output data
    plhs[0]=mxCreateDoubleMatrix(SS22*Z, H*W, mxREAL);
    double *patches=mxGetPr(plhs[0]);
    
    for(int x=0;x<W;++x) {
        for(int y=0;y<H;++y) {
            int n=y*W+x;
            
            //mexPrintf("%i\n",n);
            for(int xx=-S;xx<=S;++xx) {
                for(int yy=-S;yy<=S;++yy) {
                    if ( x+xx>=0 && x+xx<W && y+yy>=0 && y+yy<H) {
                        for(int z=0;z<Z;++z) {
                            patches[n*Z*SS22 +  z*SS22  +   (yy+S) + (xx+S)*S2   ]=inPixels[z*(H*W)+(y+yy)+(x+xx)*H];
                        }
                    }
                }
            }
        }
    }
    
//
//    for(int z=0;z<Z;++z){
//        for(int x=0;x<W;++x) {
//            for(int y=0;y<H;++y) {
//                mexPrintf("%2.1f ",inPixels[z*H*W+y*W+x]);
//            }
//            mexPrintf("\n");
//        }
//        mexPrintf("---\n");
//    }
}
