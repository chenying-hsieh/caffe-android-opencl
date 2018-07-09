#ifndef _H_DSPMATH_
#define _H_DSPMATH_

#ifdef __cplusplus
extern "C" {
#endif

int hexagon_init(void);
int hexagon_deinit(void);
void *dspmem_alloc(void *p, uint32_t flags, size_t size, int align);
void dspmem_free(void *p);

/* The following macro are just for compile independent of Hexagon SDK */
#ifndef  __QAIC_HEADER_EXPORT
#define __QAIC_HEADER_EXPORT
#define AEEResult int
#define __QAIC_HEADER(_func_) _func_
#define __QAIC_HEADER_ATTRIBUTE
#endif

//#ifndef min
//#define min(a, b) (a > b ? (b) : (a))
//#endif
//#ifndef max
//#define max(a, b) (a > b ? (a) : (b))
//#endif

#define DSP_VERIFY(func_call, _ret_) \
 ({ \
     int ret; \
     ret = func_call; \
     if (ret) { \
         printf("### FAILED ### "#func_call "\n"); \
     } \
     if (_ret_) \
         *(int *)(_ret_) = ret; \
 })
#define uint32 uint32_t
#define int32  int32_t
#define uint8  uint8_t
#define int8  int8_t

__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_TimeTest)(void) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_TimeTestFloat)(void) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_SanityTest)(int32* pivot) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_repeat)(void) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_im2col_caffe)(const uint8* data_im, int data_imLen, int32 channels, int32 height, int32 width, int32 input_offset, int32 kernel_h, int32 kernel_w, int32 pad_h, int32 pad_w, int32 stride_h, int32 stride_w, int32 dilation_h, int32 dilation_w, uint8* data_col, int data_colLen, int32* shape, int shapeLen) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_im2col_caffe_cpu)(const uint8* data_im, int data_imLen, int32 channels, int32 height, int32 width, int32 input_offset, int32 kernel_h, int32 kernel_w, int32 pad_h, int32 pad_w, int32 stride_h, int32 stride_w, int32 dilation_h, int32 dilation_w, uint8* data_col, int data_colLen, int32* shape, int shapeLen) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_vmemcpy_asm_wrap)(const uint8* y, int yLen, uint8* z, int zLen, int32 size) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int __QAIC_HEADER(dspBLAS_gemmlowp_nchw)(const uint8* x, int xLen, int32 x_offset, const uint8* yopt, int yoptLen, int32 y_offset, int32* z, int zLen, uint8* scratch, int scratchLen, int32 N, int32 M, int32 K, int32 NSTEP, int32 MSTEP, int32 KSTEP, float out_min, float out_max) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int __QAIC_HEADER(dspBLAS_gemmlowp)(const uint8* x, int xLen, int32 x_offset, const uint8* yopt, int yoptLen, int32 y_offset, int32* z, int zLen, uint8* scratch, int scratchLen, int32 N, int32 M, int32 K) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_gemmlowp_cpu)(const uint8* x, int xLen, int32 x_offset, const uint8* yopt, int yoptLen, int32 y_offset, int32* z, int zLen, uint8_t *scratch, int size_scratch, int32 N, int32 M, int32 K) __QAIC_HEADER_ATTRIBUTE;
int dspBLAS_pad2d_cpu( const uint8_t* input_data, int input_height, int input_width, uint8_t* output_data, int output_height, int output_width, int pad_value);
int dspBLAS_gemmlowp_dequantize(int z_offset, float scale, int32 *z,  int len);
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_conv2d)(int32 M, int32 N, int32 K, const uint8* input, int inputLen, const uint8* filt, int filtLen, uint8* output, int outputLen, uint8* scratch, int scratchLen, int32 in_batches, int32 in_depth, int32 in_width, int32 in_height, int32 filt_batches, int32 filt_width, int32 filt_height, int32 filt_depth, int32 stride_width, int32 stride_height, int32 padding_width, int32 padding_height, float in_min_float, float in_max_float, float filt_min_float, float filt_max_float) __QAIC_HEADER_ATTRIBUTE;
int dspBLAS_SGEMMf32(uint32 order, uint32 transA, uint32 transB,
	     uint32 M, uint32 N, uint32 K,
	     float alpha,
	     const float *A, int lenA, uint32 offA, uint32 lda,
	     const float *B, int lenB, uint32 offB, uint32 ldb,
	     float beta,
	     const float *Cin, int lenCin,
	     float *C, int lenC, uint32 offC, uint32 ldc);
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_SGEMMs8s32)(
	uint32 order, uint32 TransA, uint32 TransB,
	uint32 M, uint32 N, uint32 K,
	const uint8* A, int ALen, uint32 offA, uint32 lda,
	const uint8* B, int BLen, uint32 offB, uint32 ldb,
	int32* C, int CLen, uint32 offC, uint32 ldc,
	int32 multiplier, int32 shift, int32 offset) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_MatrixMultiplys8s32)(const int8_t* src1, int src1Len, uint32 src1Width, uint32 src1Height, uint32 src1Stride, const int8_t* src2, int src2Len, uint32 src2Width, uint32 src2Stride, int8_t* dst, int dstLen, uint32 dstStride) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_MatrixMultiply)(const float* src1, int src1Len, uint32 src1Width, uint32 src1Height, uint32 src1Stride, const float* src2, int src2Len, uint32 src2Width, uint32 src2Stride, float* dst, int dstLen, uint32 dstStride) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_Transposef32)(const float* src, int srcLen, uint32 width, uint32 height, uint32 srcStride, float* dst, int dstLen, uint32 dstStride) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_Addf32)(const float* src1, int src1Len, uint32 width, uint32 height, uint32 src1Stride, const float* src2, int src2Len, uint32 src2Stride, float* dst, int dstLen, uint32 dstStride) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT AEEResult __QAIC_HEADER(dspBLAS_MultiplyScalarf32)(const float* src1, int src1Len, uint32 width, uint32 height, uint32 src1Stride, float scalar, float* dst, int dstLen, uint32 dstStride) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_PoolingMaxS1)(const float* src, int srcLen, uint32 batch, uint32 channels, uint32 width, uint32 height, uint32 kernel_w, uint32 kernel_h, uint32 stride_w, uint32 stride_h, uint32 pad_w, uint32 pad_h, uint32 pooled_width, uint32 pooled_height, float* dst, int dstLen, int32* mask, int maskLen) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_PoolingMaxS)(const float* src, int srcLen, uint32 batch, uint32 channels, uint32 width, uint32 height, uint32 kernel_w, uint32 kernel_h, uint32 stride_w, uint32 stride_h, uint32 pad_w, uint32 pad_h, uint32 pooled_width, uint32 pooled_height, float* dst, int dstLen, int32* mask, int maskLen) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_PoolingAvgS1)(const float* src, int srcLen, uint32 batch, uint32 channels, uint32 width, uint32 height, uint32 kernel_w, uint32 kernel_h, uint32 stride_w, uint32 stride_h, uint32 pad_w, uint32 pad_h, uint32 pooled_width, uint32 pooled_height, float* dst, int dstLen) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_PoolingAvgS)(const float* src, int srcLen, uint32 batch, uint32 channels, uint32 width, uint32 height, uint32 kernel_w, uint32 kernel_h, uint32 stride_w, uint32 stride_h, uint32 pad_w, uint32 pad_h, uint32 pooled_width, uint32 pooled_height, float* dst, int dstLen) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_ReluS)(const float* src, int srcLen, float* dst, int dstLen, float negative_slope) __QAIC_HEADER_ATTRIBUTE;
int dspBLAS_MemCreate(size_t size);
void dspBLAS_MemDestroy(int id);
void *dspBLAS_MemGetBase(int id);
int dspBLAS_MemGetDevMem(int id);
#if 0
struct node_conv2d {
#if 0
        /* Here we follow nnlib's conv2d for input/output tensors
           input[8]:
           0. input
           1. filter (weight)
           2. min_in
           3. max_in
           4. min_filt
           5. max_filt
           6. stride
           7. pad (caffe)
           8. dilation (caffe)

           output[3]:
           0: output
           1. out_min
           2. out_max
        */
        struct tensor input[9];
        struct tensor output[3];
#endif
        uint32_t in_dim[4];     /* batch, height, width, depth */
        uint32_t filt_dim[3];   /* height, width, depth */
        uint32_t out_dim[3];    /* height, width, depth */
        float in_params[4];     /* min, max, scale, zero_point */
        float filt_params[4];
        float out_params[4];
        uint32_t pad[2];
        uint32_t stride[2];
        uint32_t dilation[2];
};
#endif

struct dspnn_context {
   void *scratch;
   int size_scatch;
};

struct dspBLAS_node_conv2d {
   uint32 in_dim[4];
   uint32 filt_dim[3];
   uint32 out_dim[3];
   float in_params[4];
   float filt_params[4];
   float out_params[4];
   uint32 pad[2];
   uint32 stride[2];
   uint32 dilation[2];
   uint32 scratch;
};
__QAIC_HEADER_EXPORT int __QAIC_HEADER(dspBLAS_quantized_matmul)(const dspBLAS_node_conv2d* self, const float* input, int inputLen, int32 input_dim, const float* filt, int filtLen, float* output, int outputLen, int32 output_dim) __QAIC_HEADER_ATTRIBUTE;
int dspBLAS_quantized_conv2d_matmul(const struct dspBLAS_node_conv2d *self,
                             const float *input, int size_input, int input_dim,
                             const float *filt, int size_filt,
                             float *output, int size_output, int output_dim);
__QAIC_HEADER_EXPORT int __QAIC_HEADER(dspBLAS_quantized_conv2d)(const dspBLAS_node_conv2d* self, const float* input, int inputLen, int32 input_dim, const float* filt, int filtLen, float* col_buff, int col_buffLen, float* output, int outputLen, int32 output_dim) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int __QAIC_HEADER(dspBLAS_quantized_conv2d_cpu)(const dspBLAS_node_conv2d* self, const float* input, int inputLen, int32 input_dim, const float* filt, int filtLen, float* col_buff, int col_buffLen, float* output, int outputLen, int32 output_dim) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_malloc)(int32 size) __QAIC_HEADER_ATTRIBUTE;
__QAIC_HEADER_EXPORT int32 __QAIC_HEADER(dspBLAS_free)(int32 id) __QAIC_HEADER_ATTRIBUTE;

#undef uint32
#undef int32

#ifdef __cplusplus
}
#endif

#endif // _H_DSPMATH
