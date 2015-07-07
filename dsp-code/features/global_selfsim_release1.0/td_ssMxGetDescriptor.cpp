#include "math.h"
#include "mex.h"
#include <iostream>

#include "td_ssEss.hh"
#include "td_ssGetDescriptor.hh"

/*
   mex interface to create SSH features

*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
        // parameters:
        // 1 a 4D array being an SSH hypercube (in integral format)
        // 2 DS1 - the size of the descriptor
        // 3 DS2 - the size of the descriptor
        // 4 a bounding box (4 dim row vector)

        if(nrhs !=4) {
                mexErrMsgTxt("Need 4: intSSH, DS1, DS2, [left top right bottom]");
        }


// get the integral structure
        const mxArray* mxSSH=prhs[0];
        if(mxGetNumberOfDimensions(mxSSH) != 4) {
                mexErrMsgTxt("SSH needs to be 4D");
        }
        const mwSize* dim=mxGetDimensions(mxSSH);
        const int H=dim[0];
        const int W=dim[1];
        if(dim[2]!=H) { mexErrMsgTxt("dim[0] and dim[2] must be identical"); }
        if(dim[3]!=W) { mexErrMsgTxt("dim[1] and dim[3] must be identical"); }

        
        const double* SSH=mxGetPr(mxSSH);

        // get the size of the descritor for which we are working
        int DS1=(int)mxGetScalar(prhs[1]);
        int DS2=(int)mxGetScalar(prhs[2]);


        // get the bounding box
        const mxArray* mxBB=prhs[3];
        if(mxGetN(mxBB)!=4 || mxGetM(mxBB)!=1) {
                mexErrMsgTxt("bb needs to be 1x4 array");
        }
        double *bb=mxGetPr(mxBB);
        int left=(int)bb[0]-1;
        int top=(int)bb[1]-1;
        int right=(int)bb[2]-1;
        int bottom=(int)bb[3]-1;

        if(left<0 || left >= W) {
            DBG(0) << VAR(left) << " " << VAR(W) << std::endl;
            mexErrMsgTxt("left out of bounds");
        }
        if(top<0 || top >= H) {
            DBG(0) << VAR(top) << " " << VAR(H) << std::endl;
            mexErrMsgTxt("top out of bounds");
        }
        if(right<0 || right >= W) {
            DBG(0) << VAR(right) << " " << VAR(W) << std::endl;
            mexErrMsgTxt("right out of bounds");
        }
        if(bottom<0 || bottom >= H) {
            DBG(0) << VAR(bottom) << " " << VAR(H) << std::endl;
            mexErrMsgTxt("bottom out of bounds");
        }
        
        DBG(10) << VAR(DS1)<<" " << VAR(DS2)<<std::endl;
        DBG(10) << VAR(H) << " " << VAR(W) << std::endl;
        DBG(10) << VAR(left) << " " << VAR(top) << " " << VAR(right) << " " << VAR(bottom) << std::endl;

        int dims[]={DS1,DS1,DS2,DS2};
        
        plhs[0]=mxCreateNumericArray(4,dims,mxDOUBLE_CLASS,mxREAL);
        double*descriptor=mxGetPr(plhs[0]);
        
        
        getDescriptor(W,H,SSH,left,top,right,bottom,DS1,DS2,descriptor);

}

