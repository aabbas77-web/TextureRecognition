#include "mex.h"

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    double *x, *px;
    double *y, *py;
    double *R;
    int M, ri, u;
    double x1, x2, y1, y2, y0, T, r0;
    const mxArray *x_ptr;
    const mxArray *y_ptr;
    const mxArray *R_ptr;
    const mxArray *T_ptr;
    
    y0 = mxGetScalar(prhs[0]);
    
    x_ptr = mexGetVariablePtr("caller", "x");
    if (x_ptr == NULL){
        mexErrMsgTxt("Could not get variable [x].\n");
    }
    x = mxGetPr(x_ptr);
    M = mxGetM(x_ptr)*mxGetN(x_ptr);
    
    y_ptr = mexGetVariablePtr("caller", "y");
    if (y_ptr == NULL){
        mexErrMsgTxt("Could not get variable [y].\n");
    }
    y = mxGetPr(y_ptr);
    
    R_ptr = mexGetVariablePtr("caller", "R");
    if (R_ptr == NULL){
        mexErrMsgTxt("Could not get variable [R].\n");
    }
    R = mxGetPr(R_ptr);

    T_ptr = mexGetVariablePtr("base", "T");
    if (T_ptr == NULL){
        mexErrMsgTxt("Could not get variable [T].\n");
    }
    T = mxGetPr(T_ptr)[0];

    px = x;
    py = y;
    for(ri=0;ri<M-1;ri++) {
        x1 = *px;
        x2 = *(px+1);
        y1 = *py;
        y2 = *(py+1);
        if((y1 == y2) && (y0 == y1)) {
            r0 = x1;
            for(u=max(1, r0-T);u<min(360, r0+T);u++)    R[u-1]++;
            r0 = x2;
            for(u=max(1, r0-T);u<min(360, r0+T);u++)    R[u-1]++;
        }
        else if(((y0 >= y1) && (y0 <= y2)) || ((y0 >= y2) && (y0 <= y1))) {
            r0 = x1+(x2-x1)*(y0-y1)/(y2-y1);
            for(u=max(1, r0-T);u<min(360, r0+T);u++)    R[u-1]++;
        }
        px++;
        py++;
    }
}
