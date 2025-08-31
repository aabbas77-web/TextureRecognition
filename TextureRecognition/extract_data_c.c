#include "mex.h"

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    double *src, *psrc;
    int h, w, s, dim, D;
    double *f, *pf;
    unsigned char *mask, *pmask;
    double si;
    int y, x, i, j;
    double m, m0, n0, f1, th1, th2;
    const mxArray *f_ptr;
    const mxArray *mask_ptr;
    const mxArray *dim_ptr;
    
    src = mxGetPr(prhs[0]);
    h = mxGetM(prhs[0]);
    w = mxGetN(prhs[0]);
    s = h*w;
    
    mask_ptr = mexGetVariablePtr("caller", "mask");
    if (mask_ptr == NULL){
        mexErrMsgTxt("Could not get variable [mask].\n");
    }
    mask = (unsigned char *)mxGetData(mask_ptr);
    
    f_ptr = mexGetVariablePtr("caller", "f");
    if (f_ptr == NULL){
        mexErrMsgTxt("Could not get variable [f].\n");
    }
    f = mxGetPr(f_ptr);
    si = mxGetM(f_ptr)*mxGetN(f_ptr);
    
    dim_ptr = mexGetVariablePtr("caller", "dim");
    if (dim_ptr == NULL){
        mexErrMsgTxt("Could not get variable [dim].\n");
    }
    dim = (int)mxGetPr(dim_ptr)[0];
    
    pf = f;
    pmask = mask;
    m = 0.0;
    for(y=0;y<h;y++) {
        for(x=0;x<w;x++) {
//            if(*(pmask++) > 0) {
            if(mask[x*h+y] > 0) {
                m0 = 0.0;
                n0 = 0.0;
                for(j=-dim;j<=dim;j++) {
                    for(i=-dim;i<=dim;i++) {
                        if((x+i >= 0) && (x+i < w) && (y+j >= 0) && (y+j < h)) {
                            m0 += src[(x+i)*h+(y+j)];
                            n0++;
                        }
                    }
                }
                m0 /= n0;
                *(pf++) = m0;
                m += m0;
            };
        };
    };
    m /= si;
    
/*
    pf = f;
    pmask = mask;
    psrc = src;
    m = 0.0;
    for(i=0;i<s;i++)  {
        if(*(pmask++) > 0) {
            m += *psrc;
            *(pf++) = *psrc;
        };
        psrc++;
    }
    m /= si;
*/
    
    th1 = 0.25;
    th2 = 0.75;
    pf = f;
    for(i=0;i<si;i++) {
        f1 = *pf - m + 0.5;
        if(f1 < th1)    *pf = th1;
        else if(f1 > th2)   *pf = th2;
        else    *pf = f1;
        pf++;
    }
}
