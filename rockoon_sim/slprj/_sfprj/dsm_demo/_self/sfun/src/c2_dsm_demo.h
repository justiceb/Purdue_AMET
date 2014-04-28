#ifndef __c2_dsm_demo_h__
#define __c2_dsm_demo_h__

/* Include files */
#include "sfc_sf.h"
#include "sfc_mex.h"
#include "rtwtypes.h"

/* Type Definitions */
#ifndef typedef_SFc2_dsm_demoInstanceStruct
#define typedef_SFc2_dsm_demoInstanceStruct

typedef struct {
  SimStruct *S;
  ChartInfoStruct chartInfo;
  uint32_T chartNumber;
  uint32_T instanceNumber;
  int32_T c2_sfEvent;
  boolean_T c2_isStable;
  boolean_T c2_doneDoubleBufferReInit;
  uint8_T c2_is_active_c2_dsm_demo;
  real_T *c2_A_address;
  int32_T c2_A_index;
} SFc2_dsm_demoInstanceStruct;

#endif                                 /*typedef_SFc2_dsm_demoInstanceStruct*/

/* Named Constants */

/* Variable Declarations */

/* Variable Definitions */

/* Function Declarations */
extern const mxArray *sf_c2_dsm_demo_get_eml_resolved_functions_info(void);

/* Function Definitions */
extern void sf_c2_dsm_demo_get_check_sum(mxArray *plhs[]);
extern void c2_dsm_demo_method_dispatcher(SimStruct *S, int_T method, void *data);

#endif
