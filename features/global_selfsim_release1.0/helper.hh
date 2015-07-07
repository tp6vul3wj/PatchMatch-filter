#ifndef td_helper_hh
#define td_helper_hh

#include <iostream>


#ifndef DEBUG_LEVEL
#define DEBUG_LEVEL 0
#endif

#define DBG(level)                                                      \
 if(DEBUG_LEVEL>=level) ::std::cerr << "(" << ((int)(level)) << ") [" << __FILE__<<":"<<__LINE__<<":"<<__FUNCTION__<<"] "
#define BLINK(level) \
 if(DEBUG_LEVEL>=level) ::std::cerr 
#define VAR(x)  #x " = " << x 


typedef unsigned int uint;

// if you use these functions link with -lut
extern "C" {
        bool utSetInterruptEnabled(bool);
        bool utIsInterruptPending(void);
}

//#define MATRIX(X,a,b,c,d,A,B,C,D) ((a<0||b<0||c<0||d<0)?0.0:X[a+b*A+c*A*B+d*A*B*C])


inline double MATRIX(const double *X, int a, int b, int c, int d, int A, int B, int C, int D) 
{
        
        if (a<0||b<0||c<0||d<0) {
                DBG(30) << a << " " << b << " " << c << " " << d << " !!! 0.0"<< std::endl;
                return 0.0;
        } else {
                DBG(30) << a << " " << b << " " << c << " " << d << " " << X[a+b*A+c*A*B+d*A*B*C] << std::endl;
                return X[a+b*A+c*A*B+d*A*B*C];
        }
}



#endif
