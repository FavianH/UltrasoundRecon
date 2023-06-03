#include "types.h"
#include "backproject_3d.h"
#include "mex.h"

void mexFunction(int nlhs, mxArray* plhs[], int nrhs, mxArray const* prhs[]) {

    // 检查输入参数数量
    if (nrhs != 4) {
        mexErrMsgIdAndTxt("Backproject3D: InvalidInput", "Wrong number of inputs provided .");
    }

    //////////////////// Fist input : Source positions
    //mxArray const* const source_mat = prhs[0];
    double* source_mat = (double*)mxGetData(prhs[0]);
    const mwSize* sourceDims = mxGetDimensions(prhs[0]);
    Point_3D* source = (Point_3D*)malloc(sourceDims[1] * sourceDims[2] * sizeof(Point_3D));
    for (size_t i = 0; i < sourceDims[1] * sourceDims[2]; i++)
    {
        source[i] = Point_3D((float)source_mat[3 * i], (float)source_mat[3 * i + 1], (float)source_mat[3 * i + 2]);
    }

    //////////////////// 2rd input  : Reciecer positions
    //Point_3D* reciecer;
    //mxArray const* const reciecer_mat = prhs[1];
    double* reciecer_mat = (double*)mxGetData(prhs[1]);
    const mwSize* reciecerDims = mxGetDimensions(prhs[1]);
    Point_3D* reciecer = (Point_3D*)malloc(reciecerDims[1] * reciecerDims[2] * sizeof(Point_3D));
    for (size_t i = 0; i < reciecerDims[1] * reciecerDims[2]; i++)
    {
        reciecer[i] = Point_3D((float)reciecer_mat[3 * i], (float)reciecer_mat[3 * i + 1], (float)reciecer_mat[3 * i + 2]);
    }

    //////////////////// 3rd input  : Projection data

    // Matlab矩阵数据 转为 C数据类型(float).
    float* projection = static_cast<float*>(mxGetData(prhs[2]));

    //////////////////// 4th input  : Geometry structure
    mxArray* geometryMex = (mxArray*)prhs[3];
    const char* fieldnames[15];
    fieldnames[0]   = "nx";
    fieldnames[1]   = "ny";
    fieldnames[2]   = "nz";
    fieldnames[3]   = "sx";
    fieldnames[4]   = "sy";
    fieldnames[5]   = "sz";
    fieldnames[6]   = "dx";
    fieldnames[7]   = "dy";
    fieldnames[8]   = "dz";
    fieldnames[9]   = "num_channels_x";
    fieldnames[10]  = "num_channels_y";
    fieldnames[11]  = "num_channels";
    fieldnames[12]  = "num_views";
    fieldnames[13]  = "num_panel";
    fieldnames[14]  = "interp";

    // Now we know that all the input struct is good! Parse it from mxArrays to
    // C structures that MEX can understand.
    int* nx, * ny, * nz, * num_channels_x, * num_channels_y, * num_channels, * num_views, * num_panel, * interp;
    double* sx, * sy, * sz;
    double* dx, * dy, * dz;
    mxArray* tmp;
    Geometry geo;
    // geo.unitX=1;geo.unitY=1;geo.unitZ=1;
    // bool coneBeam=true;

    for (int ifield = 0; ifield < 15; ifield++) {
        tmp = mxGetField(geometryMex, 0, fieldnames[ifield]);
        if (tmp == NULL) {
            continue;
        }
        switch (ifield) {
        case 0:
            nx = (int*)mxGetData(tmp);
            geo.nx = (int)nx[0];
            break;
        case 1:
            ny = (int*)mxGetData(tmp);
            geo.ny = (int)ny[0];
            break;
        case 2:
            nz = (int*)mxGetData(tmp);
            geo.nz = (int)nz[0];
            break;
        case 3:
            sx = (double*)mxGetData(tmp);
            geo.sx = (double)sx[0];
            break;
        case 4:
            sy = (double*)mxGetData(tmp);
            geo.sy = (double)sy[0];
            break;
        case 5:
            sz = (double*)mxGetData(tmp);
            geo.sz = (double)sz[0];
            break;
        case 6:
            dx = (double*)mxGetData(tmp);
            geo.dx = (double)dx[0];
            break;
        case 7:
            dy = (double*)mxGetData(tmp);
            geo.dy = (double)dy[0];
            break;
        case 8:
            dz = (double*)mxGetData(tmp);
            geo.dz = (double)dz[0];
            break;
        case 9:
            num_channels_x = (int*)mxGetData(tmp);
            geo.num_channels_x = (int)num_channels_x[0];
            break;
        case 10:
            num_channels_y = (int*)mxGetData(tmp);
            geo.num_channels_y = (int)num_channels_y[0];
            break;
        case 11:
            num_channels = (int*)mxGetData(tmp);
            geo.num_channels = (int)num_channels[0];
            break;
        case 12:
            num_views = (int*)mxGetData(tmp);
            geo.num_views = (int)num_views[0];
            break;
        case 13:
            num_panel = (int*)mxGetData(tmp);
            geo.num_panel = (int)num_panel[0];
            break;
        case 14:
            interp = (int*)mxGetData(tmp);
            geo.interp = (int)interp[0];
            break;
        default:
            mexErrMsgIdAndTxt("Backproject3D : unknown", " This should not happen .");
            break;
        }
    }

    // 定义输出矩阵
    mwSize outsize[3];
    outsize[0] = geo.nx;
    outsize[1] = geo.ny;
    outsize[2] = geo.nz;
    plhs[0] = mxCreateNumericArray(3, outsize, mxSINGLE_CLASS, mxREAL);
    // float *projection = (float*)mxGetPr(plhs[0]);

    // Get the pointer to the memory where you should store the data
    float* data = static_cast<float*>(mxGetData(plhs[0]));

    Backproject3D(source, reciecer, projection, data, geo);

    free(source);
    free(reciecer);
}