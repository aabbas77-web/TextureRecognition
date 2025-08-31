#include "mex.h"
#define round(x)    (((x)-(int)(x) >= 0.5)?(int)(x)+1:(int)(x))

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    double *src;
    int h, w, H, W, S;
    double *f;
    double *m_target;
    double *e_target1;
    double *e_target2;
    double *mask;
    int si;
    int y, x, i, k, ind0, ind1, x0, y0;
    double X0, Y0, Z0;
    double m, t, f1, th1, th2, a , b;
    mxArray *f_ptr;
    mxArray *m_target_ptr;
    mxArray *e_target1_ptr;
    mxArray *e_target2_ptr;
    mxArray *mask_ptr;
    mxArray *target_s_ptr;
    mxArray *d_ptr;
    double *dst;
    double *X;
    double *Y;
    double target_s, d, x1, y1;
    
    src = mxGetPr(prhs[0]);
    h = mxGetM(prhs[0]);
    w = mxGetN(prhs[0]);
    
    mask_ptr = mexGetVariablePtr("caller", "mask");
    if (mask_ptr == NULL){
        mexErrMsgTxt("Could not get variable [mask].\n");
    }
    mask = mxGetPr(mask_ptr);
    
    target_s_ptr = mexGetVariablePtr("caller", "target_s");
    if (target_s_ptr == NULL){
        mexErrMsgTxt("Could not get variable [target_s].\n");
    }
    target_s = mxGetPr(target_s_ptr)[0];
    
    d_ptr = mexGetVariablePtr("caller", "d");
    if (d_ptr == NULL){
        mexErrMsgTxt("Could not get variable [d].\n");
    }
    d = mxGetPr(d_ptr)[0];
    
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
    
    H = h-target_s+1;
    W = w-target_s+1;
    S = W*H;
    
    // Create a matrix for the return argument
    plhs[0] = mxCreateDoubleMatrix(1, S, mxREAL);
    X = mxGetPr(plhs[0]);
    plhs[1] = mxCreateDoubleMatrix(1, S, mxREAL);
    Y = mxGetPr(plhs[1]);
    
    k = 0;
    for(y1=0;y1<H;y1+=d) {
        y0 = round(y1);
        for(x1=0;x1<W;x1+=d) {
            x0 = round(x1);
            
            m = 0.0;
            i = 0;
            for(y=0;y<target_s;y++) {
                for(x=0;x<target_s;x++) {
                    ind0 = x*target_s+y;
                    ind1 = (x+x0)*h+(y+y0);
                    if(mask[ind0] > 0) {
                        f[i] = src[ind1];
                        m = m + f[i];
                        i++;
                    };
                };
            };
            m = m/si;
            
            th1 = 0.25;
            th2 = 0.75;
            X0 = 0.0;
            Y0 = 0.0;
            for(i=0;i<si;i++) {
                f1 = f[i] - m + 0.5;
                if(f1 < th1)
                    f[i] = th1;
                else
                    if(f1 > th2)
                        f[i] = th2;
                    else
                        f[i] = f1;
                
                Z0 = f[i] - m_target[i];
                X0 = X0 + Z0*e_target1[i];
                Y0 = Y0 + Z0*e_target2[i];
            }
            // mexPrintf("\nThere are %f, %f right-hand-side argument(s).", x0, y0);
            
            X[k] = X0;
            Y[k] = Y0;
            k++;
        }
    }
}
