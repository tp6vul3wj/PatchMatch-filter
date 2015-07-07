#include "td_ssEss.hh"
#include <iostream>

void getDescriptor(int W, int H, const double *SSH, int x1, int y1, int x2, int y2, int DS1, int DS2, double *descriptor) 
{
        int bbwidth=x2-x1;
        int bbheight=y2-y1;
        
        for(uint a=0;a<DS1;++a) {
                int il=int(x1+a*bbwidth/DS1)-1;
                int iu=int((x1)+(a+1)*bbwidth/DS1);
                
                for(uint b=0;b<DS1;++b) {
                        int jl=int(y1+b*bbheight/DS1)-1;
                        int ju=int((y1)+(b+1)*bbheight/DS1);
                        
                        for(uint c=0;c<DS2;++c) {
                                int xl=int(x1+c*bbwidth/DS2)-1;
                                int xu=int((x1)+(c+1)*bbwidth/DS2);
                                
                                for(uint d=0;d<DS2;++d) {
                                        int yl=int(y1+d*bbheight/DS2)-1;
                                        int yu=int((y1)+(d+1)*bbheight/DS2);

                                        
                                        DBG(10) <<  VAR(il) << " - " << VAR(iu) <<" "
                                               <<  VAR(jl) << " - " << VAR(ju) <<" "
                                               <<  VAR(xl) << " - " << VAR(xu) <<" "
                                               <<  VAR(yl) << " - " << VAR(yu) << std::endl;
                                        
                                                
                                        descriptor[b+a*DS1+d*DS1*DS1+c*DS1*DS1*DS2]
                                                = MATRIX(SSH, ju , iu , yu , xu , H, W, H, W)
                                                
                                                - MATRIX(SSH, jl, iu, yu, xu, H, W, H, W) 
                                                - MATRIX(SSH, ju, il, yu, xu, H, W, H, W) 
                                                - MATRIX(SSH, ju, iu, yl, xu, H, W, H, W) 
                                                - MATRIX(SSH, ju, iu, yu, xl, H, W, H, W) 
                                                
                                                + MATRIX(SSH, jl, il, yu, xu, H, W, H, W) 
                                                + MATRIX(SSH, jl, iu, yl, xu, H, W, H, W) 
                                                + MATRIX(SSH, jl, iu, yu, xl, H, W, H, W) 
                                                + MATRIX(SSH, ju, il, yl, xu, H, W, H, W) 
                                                + MATRIX(SSH, ju, il, yu, xl, H, W, H, W) 
                                                + MATRIX(SSH, ju, iu, yl, xl, H, W, H, W) 
                                                
                                                - MATRIX(SSH, ju, il, yl, xl, H, W, H, W) 
                                                - MATRIX(SSH, jl, iu, yl, xl, H, W, H, W) 
                                                - MATRIX(SSH, jl, il, yu, xl, H, W, H, W) 
                                                - MATRIX(SSH, jl, il, yl, xu, H, W, H, W) 

                                                + MATRIX(SSH , jl, il, yl, xl, H, W, H, W);


                                        DBG(10) << "[" << a << " " << b << " " << c << " " << d <<"]:"
                                                << xl << "-" << xu << " "
                                                << yl << "-" << yu << " " 
                                                << il << "-" << iu << " " 
                                                << jl << "-" << ju << " " 
                                                << " V=" << MATRIX(descriptor, b,a,d,c, DS1,DS1,DS2,DS2)
                                                << std::endl;
                                        
                                        //DBG(10) << VAR(b)<< " " <<VAR(a) << " " <<VAR(d) << " " << VAR(c) << " "<< VAR(MATRIX(descriptor, b,a,d,c, DS1,DS1,DS2,DS2)) << std::endl; 
                                }
                        }
                }
        }
}
