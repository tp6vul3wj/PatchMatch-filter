#include "math.h"
#include "mex.h"
#include <iostream>
#include <limits>
#define VAR(x)  #x " = " << x

using namespace std;


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
    //parameters - image
    //             patchsize
    //             codebook
    // output - texton map
    
    // process input data
    const mxArray *inImage=prhs[0];
    const int S=(int)mxGetScalar(prhs[1]);
    const mxArray *inCodebook=prhs[2];
    
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
    
    double *codebook=mxGetPr(inCodebook);
    int numberWords=mxGetN(inCodebook);
    int dimensionCodewords=mxGetM(inCodebook);
    
    mexPrintf("Codebook: numberWords=%i, dimension=%i\n",numberWords, dimensionCodewords);
    mexPrintf("S=%i S2=%i SS22=%i\n",S, S2,SS22);
    mexPrintf("H=%i W=%i Z=%i\n",H,W,Z);

    int Dim=Z*SS22;
    mexPrintf("Dim=%i\n", Dim);
    
    if (Dim != dimensionCodewords) {
        mexErrMsgTxt("Codebook and settings don't match");
    }
    
    // prepare output data
    plhs[0]=mxCreateNumericMatrix(H, W,mxUINT32_CLASS,mxREAL);
    unsigned int *textonMap=(unsigned int *)mxGetPr(plhs[0]);

    mxArray *mxPatch=mxCreateDoubleMatrix(1,Z*SS22,mxREAL);
    double *patch=mxGetPr(mxPatch);
    
    for(int x=0;x<W;++x) {
        for(int y=0;y<H;++y) {
            int n=y*W+x;
            
            //mexPrintf("x=%i/%i y=%i/%i n=%i\n",x,W,y,H,n);
            
            //mexPrintf("%i\n",n);
            for(int xx=-S;xx<=S;++xx) {
                for(int yy=-S;yy<=S;++yy) {
                    if (x+xx>=0 && x+xx<W && y+yy>=0 && y+yy<H) {
                        for(int z=0;z<Z;++z) {
                            patch[z*SS22  +   (yy+S) + (xx+S)*S2]=inPixels[z*(H*W)+(y+yy)+(x+xx)*H];
                        }
                    } else {
                        for(int z=0;z<Z;++z) {
                            patch[z*SS22  +   (yy+S) + (xx+S)*S2]=0.0;
                        }
                    }
                }
            }
            
   
            double bestDist=std::numeric_limits<double>::max();
            int bestW=-1;
            for(int w=0;w<numberWords;++w) {
//                
//                for (int d=0;d<Dim;++d) {
//                    mexPrintf("%f ", codebook[d+w*dimensionCodewords]);
//                }
//                mexPrintf("\n");
//                mexErrMsgTxt("exit on purpose");
                
                
                double dist=0, tmp;
                for(int d=0;d<Dim;++d) {
                    tmp=patch[d]-codebook[d+w*dimensionCodewords];
                    dist+=tmp*tmp;
                }
                
                if(dist<bestDist) {
                    bestDist=dist;
                    bestW=w;
                }
            }
            textonMap[x*H+y]=(unsigned int)bestW;
        }
    }
    
    mexPrintf("done\n");
    mxDestroyArray(mxPatch);
    
    
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
