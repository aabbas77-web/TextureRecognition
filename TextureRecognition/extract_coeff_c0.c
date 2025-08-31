#include "mex.h"

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    double *src;
    int h, w;
    double *f;
    double *m_target;
    double *e_target1;
    double *e_target2;
    double *mask;
    int si;
    int y, x, i, ind;
    double x0, y0, z0;
    double m, t, f1, th1, th2, a , b;
    mxArray *f_ptr;
    mxArray *m_target_ptr;
    mxArray *e_target1_ptr;
    mxArray *e_target2_ptr;
    mxArray *mask_ptr;
    double *dst;
    double *P;
    
    src = mxGetPr(prhs[0]);
    h = mxGetM(prhs[0]);
    w = mxGetN(prhs[0]);
    
    // Create a matrix for the return argument
    plhs[0] = mxCreateDoubleMatrix(1, 2, mxREAL);
    // Assign pointers to the various parameters
    P = mxGetPr(plhs[0]);
    
    mask_ptr = mexGetVariablePtr("caller", "mask");
    if (mask_ptr == NULL){
        mexErrMsgTxt("Could not get variable [mask].\n");
    }
    mask = mxGetPr(mask_ptr);
    
    f_ptr = mexGetVariablePtr("caller", "f");
    if (f_ptr == NULL){
        mexErrMsgTxt("Could not get variable [f].\n");
    }
    f = mxGetPr(f_ptr);
    si = mxGetM(f_ptr);
    
    m_target_ptr = mexGetVariablePtr("caller", "m_target");
    if (m_target_ptr == NULL){
        mexErrMsgTxt("Could not get variable [m_target].\n");
    }
    m_target = mxGetPr(m_target_ptr);
    
    e_target1_ptr = mexGetVariablePtr("caller", "e_target1");
    if (e_target1_ptr == NULL){
        mexErrMsgTxt("Could not get variable [e_target1].\n");
    }
    e_target1 = mxGetPr(e_target1_ptr);
    
    e_target2_ptr = mexGetVariablePtr("caller", "e_target2");
    if (e_target2_ptr == NULL){
        mexErrMsgTxt("Could not get variable [e_target2].\n");
    }
    e_target2 = mxGetPr(e_target2_ptr);
    
    m = 0.0;
    i = 0;
    for(y=0;y<h;y++) {
        for(x=0;x<w;x++) {
            ind = x*h+y;
            if(mask[ind] > 0) {
                f[i] = src[ind];
                m = m + f[i];
                i++;
            };
        };
    };
    m = m/si;
    
    th1 = 0.25;
    th2 = 0.75;
    x0 = 0.0;
    y0 = 0.0;
    for(i=0;i<si;i++) {
        f1 = f[i] - m + 0.5;
        if(f1 < th1)
            f[i] = th1;
        else
            if(f1 > th2)
                f[i] = th2;
            else
                f[i] = f1;
        
        z0 = f[i] - m_target[i];
        x0 = x0 + z0*e_target1[i];
        y0 = y0 + z0*e_target2[i];
    }
    // mexPrintf("\nThere are %f, %f right-hand-side argument(s).", x0, y0);
    
    P[0] = x0;
    P[1] = y0;
}
