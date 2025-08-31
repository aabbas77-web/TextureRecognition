#include "mex.h"
#define round(x)    (((x)-(int)(x) >= 0.5)?(int)(x)+1:(int)(x))

/* The gateway function */
void mexFunction( int nlhs, mxArray *plhs[],
        int nrhs, const mxArray *prhs[]) {
    int h, w, hm, wm;
    int y, x, i, j, k, x0, y0, kp, target_s;
    double *src;
    double *f;
    double *X;
    double *Y;
    double *m_target;
    double *e_target1;
    double *e_target2;
    double *mask;
    double *Msk;
    double si;
    double X0, Y0, Z0;
    double m, f1, th1, th2;
    mxArray *f_ptr;
    mxArray *m_target_ptr;
    mxArray *e_target1_ptr;
    mxArray *e_target2_ptr;
    mxArray *src_ptr;
    mxArray *mask_ptr;
    mxArray *Msk_ptr;
    mxArray *target_s_ptr;
    mxArray *d_ptr;
    mxArray *Xc_ptr;
    mxArray *Yc_ptr;
    mxArray *X_ptr;
    mxArray *Y_ptr;
    mxArray *sc_ptr;
    mxArray *dm_ptr;
    mxArray *sh_ptr;
    double *dst;
    double d, Xc, Yc, sc, dm, sh;
    double *K;
    
    src_ptr = mexGetVariablePtr("caller", "src");
    if (src_ptr == NULL){
        mexErrMsgTxt("Could not get variable [src].\n");
    }
    src = mxGetPr(src_ptr);
    h = mxGetM(src_ptr);
    w = mxGetN(src_ptr);
    
    mask_ptr = mexGetVariablePtr("caller", "mask");
    if (mask_ptr == NULL){
        mexErrMsgTxt("Could not get variable [mask].\n");
    }
    mask = mxGetPr(mask_ptr);
    
    Msk_ptr = mexGetVariablePtr("caller", "Msk");
    if (Msk_ptr == NULL){
        mexErrMsgTxt("Could not get variable [Msk].\n");
    }
    Msk = mxGetPr(Msk_ptr);
    hm = mxGetM(Msk_ptr);
    wm = mxGetN(Msk_ptr);
    
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
    
    Xc_ptr = mexGetVariablePtr("caller", "Xc");
    if (Xc_ptr == NULL){
        mexErrMsgTxt("Could not get variable [Xc].\n");
    }
    Xc = mxGetPr(Xc_ptr)[0];
    
    Yc_ptr = mexGetVariablePtr("caller", "Yc");
    if (Yc_ptr == NULL){
        mexErrMsgTxt("Could not get variable [Yc].\n");
    }
    Yc = mxGetPr(Yc_ptr)[0];
    
    sc_ptr = mexGetVariablePtr("caller", "sc");
    if (sc_ptr == NULL){
        mexErrMsgTxt("Could not get variable [sc].\n");
    }
    sc = mxGetPr(sc_ptr)[0];
    
    dm_ptr = mexGetVariablePtr("caller", "dm");
    if (dm_ptr == NULL){
        mexErrMsgTxt("Could not get variable [dm].\n");
    }
    dm = mxGetPr(dm_ptr)[0];
    
    sh_ptr = mexGetVariablePtr("caller", "sh");
    if (sh_ptr == NULL){
        mexErrMsgTxt("Could not get variable [sh].\n");
    }
    sh = mxGetPr(sh_ptr)[0];
    
    f_ptr = mexGetVariablePtr("caller", "f");
    if (f_ptr == NULL){
        mexErrMsgTxt("Could not get variable [f].\n");
    }
    f = mxGetPr(f_ptr);
    si = mxGetM(f_ptr);
    
    X_ptr = mexGetVariablePtr("caller", "X");
    if (X_ptr == NULL){
        mexErrMsgTxt("Could not get variable [X].\n");
    }
    X = mxGetPr(X_ptr);
    
    Y_ptr = mexGetVariablePtr("caller", "Y");
    if (Y_ptr == NULL){
        mexErrMsgTxt("Could not get variable [Y].\n");
    }
    Y = mxGetPr(Y_ptr);
    
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
    
    plhs[0] = mxCreateDoubleMatrix(1, 1, mxREAL);
    K = mxGetPr(plhs[0]);
    
    k = 0;
    kp = 0;
    for(y0=0;y0<h-target_s+1;y0++) {
        for(x0=0;x0<w-target_s+1;x0++) {
            m = 0.0;
            i = 0;
            for(y=0;y<target_s;y++) {
                for(x=0;x<target_s;x++) {
                    if(mask[x*target_s+y] > 0) {
                        f[i] = src[(x+x0)*h+(y+y0)];
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
                if(f1 < th1)    f[i] = th1;
                else if(f1 > th2)   f[i] = th2;
                else    f[i] = f1;
                
                Z0 = f[i] - m_target[i];
                X0 += Z0*e_target1[i];
                Y0 += Z0*e_target2[i];
            }
            
            x = round(sc*(Xc+X0)+sh+1);
            y = round(sc*(Yc+Y0)+sh+1);
            if((x >= 1) && (x <= wm) && (y >= 1) && (y <= hm)) {
                if(Msk[(x-1)*hm+(y-1)] > 0)   {
                    X[kp] = x0+1;
                    Y[kp] = y0+1;
                    kp++;
                }
            }
        }
    }
    K[0] = kp;
}
