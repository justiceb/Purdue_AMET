/* Include files */

#include <stddef.h>
#include "blas.h"
#include "rockoon_2D_Launch_sfun.h"
#include "c2_rockoon_2D_Launch.h"
#define CHARTINSTANCE_CHARTNUMBER      (chartInstance->chartNumber)
#define CHARTINSTANCE_INSTANCENUMBER   (chartInstance->instanceNumber)
#include "rockoon_2D_Launch_sfun_debug_macros.h"
#define _SF_MEX_LISTEN_FOR_CTRL_C(S)   sf_mex_listen_for_ctrl_c(sfGlobalDebugInstanceStruct,S);

/* Type Definitions */

/* Named Constants */
#define CALL_EVENT                     (-1)

/* Variable Declarations */

/* Variable Definitions */
static const char * c2_debug_family_names[11] = { "nargin", "nargout", "theta",
  "sx", "vx", "sy", "vy", "t", "ax", "ay", "theta_dot_dot" };

/* Function Declarations */
static void initialize_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance);
static void initialize_params_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance);
static void enable_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance);
static void disable_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance);
static void c2_update_debugger_state_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance);
static const mxArray *get_sim_state_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance);
static void set_sim_state_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance, const mxArray *c2_st);
static void finalize_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance);
static void sf_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance);
static void initSimStructsc2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance);
static void registerMessagesc2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance);
static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber);
static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, void *c2_inData);
static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static real_T c2_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_ax, const char_T *c2_identifier);
static real_T c2_b_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData);
static int32_T c2_c_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData);
static uint8_T c2_d_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_rockoon_2D_Launch, const
  char_T *c2_identifier);
static uint8_T c2_e_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId);
static void init_dsm_address_info(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance);

/* Function Definitions */
static void initialize_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance)
{
  chartInstance->c2_sfEvent = CALL_EVENT;
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  chartInstance->c2_is_active_c2_rockoon_2D_Launch = 0U;
}

static void initialize_params_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance)
{
}

static void enable_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void disable_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance)
{
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
}

static void c2_update_debugger_state_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance)
{
}

static const mxArray *get_sim_state_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance)
{
  const mxArray *c2_st;
  const mxArray *c2_y = NULL;
  real_T c2_hoistedGlobal;
  real_T c2_u;
  const mxArray *c2_b_y = NULL;
  real_T c2_b_hoistedGlobal;
  real_T c2_b_u;
  const mxArray *c2_c_y = NULL;
  real_T c2_c_hoistedGlobal;
  real_T c2_c_u;
  const mxArray *c2_d_y = NULL;
  uint8_T c2_d_hoistedGlobal;
  uint8_T c2_d_u;
  const mxArray *c2_e_y = NULL;
  real_T *c2_ax;
  real_T *c2_ay;
  real_T *c2_theta_dot_dot;
  c2_theta_dot_dot = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
  c2_ay = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c2_ax = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c2_st = NULL;
  c2_st = NULL;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_createcellarray(4), FALSE);
  c2_hoistedGlobal = *c2_ax;
  c2_u = c2_hoistedGlobal;
  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", &c2_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 0, c2_b_y);
  c2_b_hoistedGlobal = *c2_ay;
  c2_b_u = c2_b_hoistedGlobal;
  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_b_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 1, c2_c_y);
  c2_c_hoistedGlobal = *c2_theta_dot_dot;
  c2_c_u = c2_c_hoistedGlobal;
  c2_d_y = NULL;
  sf_mex_assign(&c2_d_y, sf_mex_create("y", &c2_c_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 2, c2_d_y);
  c2_d_hoistedGlobal = chartInstance->c2_is_active_c2_rockoon_2D_Launch;
  c2_d_u = c2_d_hoistedGlobal;
  c2_e_y = NULL;
  sf_mex_assign(&c2_e_y, sf_mex_create("y", &c2_d_u, 3, 0U, 0U, 0U, 0), FALSE);
  sf_mex_setcell(c2_y, 3, c2_e_y);
  sf_mex_assign(&c2_st, c2_y, FALSE);
  return c2_st;
}

static void set_sim_state_c2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance, const mxArray *c2_st)
{
  const mxArray *c2_u;
  real_T *c2_ax;
  real_T *c2_ay;
  real_T *c2_theta_dot_dot;
  c2_theta_dot_dot = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
  c2_ay = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c2_ax = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  chartInstance->c2_doneDoubleBufferReInit = TRUE;
  c2_u = sf_mex_dup(c2_st);
  *c2_ax = c2_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 0)),
    "ax");
  *c2_ay = c2_emlrt_marshallIn(chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 1)),
    "ay");
  *c2_theta_dot_dot = c2_emlrt_marshallIn(chartInstance, sf_mex_dup
    (sf_mex_getcell(c2_u, 2)), "theta_dot_dot");
  chartInstance->c2_is_active_c2_rockoon_2D_Launch = c2_d_emlrt_marshallIn
    (chartInstance, sf_mex_dup(sf_mex_getcell(c2_u, 3)),
     "is_active_c2_rockoon_2D_Launch");
  sf_mex_destroy(&c2_u);
  c2_update_debugger_state_c2_rockoon_2D_Launch(chartInstance);
  sf_mex_destroy(&c2_st);
}

static void finalize_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance)
{
}

static void sf_c2_rockoon_2D_Launch(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance)
{
  real_T c2_hoistedGlobal;
  real_T c2_b_hoistedGlobal;
  real_T c2_c_hoistedGlobal;
  real_T c2_d_hoistedGlobal;
  real_T c2_e_hoistedGlobal;
  real_T c2_f_hoistedGlobal;
  real_T c2_theta;
  real_T c2_sx;
  real_T c2_vx;
  real_T c2_sy;
  real_T c2_vy;
  real_T c2_t;
  uint32_T c2_debug_family_var_map[11];
  real_T c2_nargin = 6.0;
  real_T c2_nargout = 3.0;
  real_T c2_ax;
  real_T c2_ay;
  real_T c2_theta_dot_dot;
  real_T c2_u;
  const mxArray *c2_y = NULL;
  real_T c2_b_u;
  const mxArray *c2_b_y = NULL;
  real_T c2_c_u;
  const mxArray *c2_c_y = NULL;
  real_T c2_d_u;
  const mxArray *c2_d_y = NULL;
  real_T c2_e_u;
  const mxArray *c2_e_y = NULL;
  real_T c2_f_u;
  const mxArray *c2_f_y = NULL;
  const mxArray *c2_b_theta_dot_dot = NULL;
  const mxArray *c2_b_ay = NULL;
  const mxArray *c2_b_ax = NULL;
  real_T *c2_b_theta;
  real_T *c2_c_ax;
  real_T *c2_c_ay;
  real_T *c2_b_sx;
  real_T *c2_b_vx;
  real_T *c2_c_theta_dot_dot;
  real_T *c2_b_sy;
  real_T *c2_b_vy;
  real_T *c2_b_t;
  c2_b_t = (real_T *)ssGetInputPortSignal(chartInstance->S, 5);
  c2_b_vy = (real_T *)ssGetInputPortSignal(chartInstance->S, 4);
  c2_b_sy = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
  c2_c_theta_dot_dot = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
  c2_b_vx = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
  c2_b_sx = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
  c2_c_ay = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
  c2_c_ax = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
  c2_b_theta = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
  _sfTime_ = (real_T)ssGetT(chartInstance->S);
  _SFD_CC_CALL(CHART_ENTER_SFUNCTION_TAG, 0U, chartInstance->c2_sfEvent);
  _SFD_DATA_RANGE_CHECK(*c2_b_theta, 0U);
  _SFD_DATA_RANGE_CHECK(*c2_c_ax, 1U);
  _SFD_DATA_RANGE_CHECK(*c2_c_ay, 2U);
  _SFD_DATA_RANGE_CHECK(*c2_b_sx, 3U);
  _SFD_DATA_RANGE_CHECK(*c2_b_vx, 4U);
  _SFD_DATA_RANGE_CHECK(*c2_c_theta_dot_dot, 5U);
  _SFD_DATA_RANGE_CHECK(*c2_b_sy, 6U);
  _SFD_DATA_RANGE_CHECK(*c2_b_vy, 7U);
  _SFD_DATA_RANGE_CHECK(*c2_b_t, 8U);
  chartInstance->c2_sfEvent = CALL_EVENT;
  _SFD_CC_CALL(CHART_ENTER_DURING_FUNCTION_TAG, 0U, chartInstance->c2_sfEvent);
  c2_hoistedGlobal = *c2_b_theta;
  c2_b_hoistedGlobal = *c2_b_sx;
  c2_c_hoistedGlobal = *c2_b_vx;
  c2_d_hoistedGlobal = *c2_b_sy;
  c2_e_hoistedGlobal = *c2_b_vy;
  c2_f_hoistedGlobal = *c2_b_t;
  c2_theta = c2_hoistedGlobal;
  c2_sx = c2_b_hoistedGlobal;
  c2_vx = c2_c_hoistedGlobal;
  c2_sy = c2_d_hoistedGlobal;
  c2_vy = c2_e_hoistedGlobal;
  c2_t = c2_f_hoistedGlobal;
  _SFD_SYMBOL_SCOPE_PUSH_EML(0U, 11U, 11U, c2_debug_family_names,
    c2_debug_family_var_map);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_nargin, 0U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_nargout, 1U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_theta, 2U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_sx, 3U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_vx, 4U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_sy, 5U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_vy, 6U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML(&c2_t, 7U, c2_sf_marshallOut);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_ax, 8U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_ay, 9U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  _SFD_SYMBOL_SCOPE_ADD_EML_IMPORTABLE(&c2_theta_dot_dot, 10U, c2_sf_marshallOut,
    c2_sf_marshallIn);
  CV_EML_FCN(0, 0);
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 4);
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 7);
  c2_ax = 0.0;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 8);
  c2_ay = 0.0;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 9);
  c2_theta_dot_dot = 0.0;
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, 12);
  c2_u = c2_theta;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 0, 0U, 0U, 0U, 0), FALSE);
  c2_b_u = c2_sx;
  c2_b_y = NULL;
  sf_mex_assign(&c2_b_y, sf_mex_create("y", &c2_b_u, 0, 0U, 0U, 0U, 0), FALSE);
  c2_c_u = c2_vx;
  c2_c_y = NULL;
  sf_mex_assign(&c2_c_y, sf_mex_create("y", &c2_c_u, 0, 0U, 0U, 0U, 0), FALSE);
  c2_d_u = c2_sy;
  c2_d_y = NULL;
  sf_mex_assign(&c2_d_y, sf_mex_create("y", &c2_d_u, 0, 0U, 0U, 0U, 0), FALSE);
  c2_e_u = c2_vy;
  c2_e_y = NULL;
  sf_mex_assign(&c2_e_y, sf_mex_create("y", &c2_e_u, 0, 0U, 0U, 0U, 0), FALSE);
  c2_f_u = c2_t;
  c2_f_y = NULL;
  sf_mex_assign(&c2_f_y, sf_mex_create("y", &c2_f_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_call_debug("rockoon_calc", 3U, 6U, 14, c2_y, 14, c2_b_y, 14, c2_c_y, 14,
                    c2_d_y, 14, c2_e_y, 14, c2_f_y, &c2_b_ax, &c2_b_ay,
                    &c2_b_theta_dot_dot);
  c2_ax = c2_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_b_ax), "ax");
  c2_ay = c2_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_b_ay), "ay");
  c2_theta_dot_dot = c2_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c2_b_theta_dot_dot), "theta_dot_dot");
  _SFD_EML_CALL(0U, chartInstance->c2_sfEvent, -12);
  _SFD_SYMBOL_SCOPE_POP();
  sf_mex_destroy(&c2_b_ax);
  sf_mex_destroy(&c2_b_ay);
  sf_mex_destroy(&c2_b_theta_dot_dot);
  *c2_c_ax = c2_ax;
  *c2_c_ay = c2_ay;
  *c2_c_theta_dot_dot = c2_theta_dot_dot;
  _SFD_CC_CALL(EXIT_OUT_OF_FUNCTION_TAG, 0U, chartInstance->c2_sfEvent);
  _SFD_CHECK_FOR_STATE_INCONSISTENCY(_rockoon_2D_LaunchMachineNumber_,
    chartInstance->chartNumber, chartInstance->instanceNumber);
}

static void initSimStructsc2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance)
{
}

static void registerMessagesc2_rockoon_2D_Launch
  (SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance)
{
}

static void init_script_number_translation(uint32_T c2_machineNumber, uint32_T
  c2_chartNumber)
{
}

static const mxArray *c2_sf_marshallOut(void *chartInstanceVoid, void *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  real_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance;
  chartInstance = (SFc2_rockoon_2D_LaunchInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(real_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 0, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static void c2_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_ax;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  real_T c2_y;
  SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance;
  chartInstance = (SFc2_rockoon_2D_LaunchInstanceStruct *)chartInstanceVoid;
  c2_ax = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_ax), &c2_thisId);
  sf_mex_destroy(&c2_ax);
  *(real_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

const mxArray *sf_c2_rockoon_2D_Launch_get_eml_resolved_functions_info(void)
{
  const mxArray *c2_nameCaptureInfo = NULL;
  c2_nameCaptureInfo = NULL;
  sf_mex_assign(&c2_nameCaptureInfo, sf_mex_create("nameCaptureInfo", NULL, 0,
    0U, 1U, 0U, 2, 0, 1), FALSE);
  return c2_nameCaptureInfo;
}

static real_T c2_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_ax, const char_T *c2_identifier)
{
  real_T c2_y;
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_b_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_ax), &c2_thisId);
  sf_mex_destroy(&c2_ax);
  return c2_y;
}

static real_T c2_b_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  real_T c2_y;
  real_T c2_d0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_d0, 1, 0, 0U, 0, 0U, 0);
  c2_y = c2_d0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static const mxArray *c2_b_sf_marshallOut(void *chartInstanceVoid, void
  *c2_inData)
{
  const mxArray *c2_mxArrayOutData = NULL;
  int32_T c2_u;
  const mxArray *c2_y = NULL;
  SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance;
  chartInstance = (SFc2_rockoon_2D_LaunchInstanceStruct *)chartInstanceVoid;
  c2_mxArrayOutData = NULL;
  c2_u = *(int32_T *)c2_inData;
  c2_y = NULL;
  sf_mex_assign(&c2_y, sf_mex_create("y", &c2_u, 6, 0U, 0U, 0U, 0), FALSE);
  sf_mex_assign(&c2_mxArrayOutData, c2_y, FALSE);
  return c2_mxArrayOutData;
}

static int32_T c2_c_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  int32_T c2_y;
  int32_T c2_i0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_i0, 1, 6, 0U, 0, 0U, 0);
  c2_y = c2_i0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void c2_b_sf_marshallIn(void *chartInstanceVoid, const mxArray
  *c2_mxArrayInData, const char_T *c2_varName, void *c2_outData)
{
  const mxArray *c2_b_sfEvent;
  const char_T *c2_identifier;
  emlrtMsgIdentifier c2_thisId;
  int32_T c2_y;
  SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance;
  chartInstance = (SFc2_rockoon_2D_LaunchInstanceStruct *)chartInstanceVoid;
  c2_b_sfEvent = sf_mex_dup(c2_mxArrayInData);
  c2_identifier = c2_varName;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_c_emlrt_marshallIn(chartInstance, sf_mex_dup(c2_b_sfEvent),
    &c2_thisId);
  sf_mex_destroy(&c2_b_sfEvent);
  *(int32_T *)c2_outData = c2_y;
  sf_mex_destroy(&c2_mxArrayInData);
}

static uint8_T c2_d_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_b_is_active_c2_rockoon_2D_Launch, const
  char_T *c2_identifier)
{
  uint8_T c2_y;
  emlrtMsgIdentifier c2_thisId;
  c2_thisId.fIdentifier = c2_identifier;
  c2_thisId.fParent = NULL;
  c2_y = c2_e_emlrt_marshallIn(chartInstance, sf_mex_dup
    (c2_b_is_active_c2_rockoon_2D_Launch), &c2_thisId);
  sf_mex_destroy(&c2_b_is_active_c2_rockoon_2D_Launch);
  return c2_y;
}

static uint8_T c2_e_emlrt_marshallIn(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance, const mxArray *c2_u, const emlrtMsgIdentifier *c2_parentId)
{
  uint8_T c2_y;
  uint8_T c2_u0;
  sf_mex_import(c2_parentId, sf_mex_dup(c2_u), &c2_u0, 1, 3, 0U, 0, 0U, 0);
  c2_y = c2_u0;
  sf_mex_destroy(&c2_u);
  return c2_y;
}

static void init_dsm_address_info(SFc2_rockoon_2D_LaunchInstanceStruct
  *chartInstance)
{
}

/* SFunction Glue Code */
#ifdef utFree
#undef utFree
#endif

#ifdef utMalloc
#undef utMalloc
#endif

#ifdef __cplusplus

extern "C" void *utMalloc(size_t size);
extern "C" void utFree(void*);

#else

extern void *utMalloc(size_t size);
extern void utFree(void*);

#endif

void sf_c2_rockoon_2D_Launch_get_check_sum(mxArray *plhs[])
{
  ((real_T *)mxGetPr((plhs[0])))[0] = (real_T)(1322146179U);
  ((real_T *)mxGetPr((plhs[0])))[1] = (real_T)(73570740U);
  ((real_T *)mxGetPr((plhs[0])))[2] = (real_T)(1111532489U);
  ((real_T *)mxGetPr((plhs[0])))[3] = (real_T)(1304768022U);
}

mxArray *sf_c2_rockoon_2D_Launch_get_autoinheritance_info(void)
{
  const char *autoinheritanceFields[] = { "checksum", "inputs", "parameters",
    "outputs", "locals" };

  mxArray *mxAutoinheritanceInfo = mxCreateStructMatrix(1,1,5,
    autoinheritanceFields);

  {
    mxArray *mxChecksum = mxCreateString("6vMbkTDw5yn5qtC0iziEPH");
    mxSetField(mxAutoinheritanceInfo,0,"checksum",mxChecksum);
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,6,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,3,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,3,"type",mxType);
    }

    mxSetField(mxData,3,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,4,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,4,"type",mxType);
    }

    mxSetField(mxData,4,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,5,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,5,"type",mxType);
    }

    mxSetField(mxData,5,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"inputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"parameters",mxCreateDoubleMatrix(0,0,
                mxREAL));
  }

  {
    const char *dataFields[] = { "size", "type", "complexity" };

    mxArray *mxData = mxCreateStructMatrix(1,3,3,dataFields);

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,0,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,0,"type",mxType);
    }

    mxSetField(mxData,0,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,1,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,1,"type",mxType);
    }

    mxSetField(mxData,1,"complexity",mxCreateDoubleScalar(0));

    {
      mxArray *mxSize = mxCreateDoubleMatrix(1,2,mxREAL);
      double *pr = mxGetPr(mxSize);
      pr[0] = (double)(1);
      pr[1] = (double)(1);
      mxSetField(mxData,2,"size",mxSize);
    }

    {
      const char *typeFields[] = { "base", "fixpt" };

      mxArray *mxType = mxCreateStructMatrix(1,1,2,typeFields);
      mxSetField(mxType,0,"base",mxCreateDoubleScalar(10));
      mxSetField(mxType,0,"fixpt",mxCreateDoubleMatrix(0,0,mxREAL));
      mxSetField(mxData,2,"type",mxType);
    }

    mxSetField(mxData,2,"complexity",mxCreateDoubleScalar(0));
    mxSetField(mxAutoinheritanceInfo,0,"outputs",mxData);
  }

  {
    mxSetField(mxAutoinheritanceInfo,0,"locals",mxCreateDoubleMatrix(0,0,mxREAL));
  }

  return(mxAutoinheritanceInfo);
}

mxArray *sf_c2_rockoon_2D_Launch_third_party_uses_info(void)
{
  mxArray * mxcell3p = mxCreateCellMatrix(1,0);
  return(mxcell3p);
}

static const mxArray *sf_get_sim_state_info_c2_rockoon_2D_Launch(void)
{
  const char *infoFields[] = { "chartChecksum", "varInfo" };

  mxArray *mxInfo = mxCreateStructMatrix(1, 1, 2, infoFields);
  const char *infoEncStr[] = {
    "100 S1x4'type','srcId','name','auxInfo'{{M[1],M[5],T\"ax\",},{M[1],M[13],T\"ay\",},{M[1],M[11],T\"theta_dot_dot\",},{M[8],M[0],T\"is_active_c2_rockoon_2D_Launch\",}}"
  };

  mxArray *mxVarInfo = sf_mex_decode_encoded_mx_struct_array(infoEncStr, 4, 10);
  mxArray *mxChecksum = mxCreateDoubleMatrix(1, 4, mxREAL);
  sf_c2_rockoon_2D_Launch_get_check_sum(&mxChecksum);
  mxSetField(mxInfo, 0, infoFields[0], mxChecksum);
  mxSetField(mxInfo, 0, infoFields[1], mxVarInfo);
  return mxInfo;
}

static void chart_debug_initialization(SimStruct *S, unsigned int
  fullDebuggerInitialization)
{
  if (!sim_mode_is_rtw_gen(S)) {
    SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance;
    chartInstance = (SFc2_rockoon_2D_LaunchInstanceStruct *) ((ChartInfoStruct *)
      (ssGetUserData(S)))->chartInstance;
    if (ssIsFirstInitCond(S) && fullDebuggerInitialization==1) {
      /* do this only if simulation is starting */
      {
        unsigned int chartAlreadyPresent;
        chartAlreadyPresent = sf_debug_initialize_chart
          (sfGlobalDebugInstanceStruct,
           _rockoon_2D_LaunchMachineNumber_,
           2,
           1,
           1,
           9,
           0,
           0,
           0,
           0,
           0,
           &(chartInstance->chartNumber),
           &(chartInstance->instanceNumber),
           ssGetPath(S),
           (void *)S);
        if (chartAlreadyPresent==0) {
          /* this is the first instance */
          init_script_number_translation(_rockoon_2D_LaunchMachineNumber_,
            chartInstance->chartNumber);
          sf_debug_set_chart_disable_implicit_casting
            (sfGlobalDebugInstanceStruct,_rockoon_2D_LaunchMachineNumber_,
             chartInstance->chartNumber,1);
          sf_debug_set_chart_event_thresholds(sfGlobalDebugInstanceStruct,
            _rockoon_2D_LaunchMachineNumber_,
            chartInstance->chartNumber,
            0,
            0,
            0);
          _SFD_SET_DATA_PROPS(0,1,1,0,"theta");
          _SFD_SET_DATA_PROPS(1,2,0,1,"ax");
          _SFD_SET_DATA_PROPS(2,2,0,1,"ay");
          _SFD_SET_DATA_PROPS(3,1,1,0,"sx");
          _SFD_SET_DATA_PROPS(4,1,1,0,"vx");
          _SFD_SET_DATA_PROPS(5,2,0,1,"theta_dot_dot");
          _SFD_SET_DATA_PROPS(6,1,1,0,"sy");
          _SFD_SET_DATA_PROPS(7,1,1,0,"vy");
          _SFD_SET_DATA_PROPS(8,1,1,0,"t");
          _SFD_STATE_INFO(0,0,2);
          _SFD_CH_SUBSTATE_COUNT(0);
          _SFD_CH_SUBSTATE_DECOMP(0);
        }

        _SFD_CV_INIT_CHART(0,0,0,0);

        {
          _SFD_CV_INIT_STATE(0,0,0,0,0,0,NULL,NULL);
        }

        _SFD_CV_INIT_TRANS(0,0,NULL,NULL,0,NULL);

        /* Initialization of MATLAB Function Model Coverage */
        _SFD_CV_INIT_EML(0,1,1,0,0,0,0,0,0,0,0);
        _SFD_CV_INIT_EML_FCN(0,0,"eML_blk_kernel",0,-1,322);
        _SFD_TRANS_COV_WTS(0,0,0,1,0);
        if (chartAlreadyPresent==0) {
          _SFD_TRANS_COV_MAPS(0,
                              0,NULL,NULL,
                              0,NULL,NULL,
                              1,NULL,NULL,
                              0,NULL,NULL);
        }

        _SFD_SET_DATA_COMPILED_PROPS(0,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(1,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)c2_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(2,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)c2_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(3,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(4,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(5,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)c2_sf_marshallIn);
        _SFD_SET_DATA_COMPILED_PROPS(6,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(7,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);
        _SFD_SET_DATA_COMPILED_PROPS(8,SF_DOUBLE,0,NULL,0,0,0,0.0,1.0,0,0,
          (MexFcnForType)c2_sf_marshallOut,(MexInFcnForType)NULL);

        {
          real_T *c2_theta;
          real_T *c2_ax;
          real_T *c2_ay;
          real_T *c2_sx;
          real_T *c2_vx;
          real_T *c2_theta_dot_dot;
          real_T *c2_sy;
          real_T *c2_vy;
          real_T *c2_t;
          c2_t = (real_T *)ssGetInputPortSignal(chartInstance->S, 5);
          c2_vy = (real_T *)ssGetInputPortSignal(chartInstance->S, 4);
          c2_sy = (real_T *)ssGetInputPortSignal(chartInstance->S, 3);
          c2_theta_dot_dot = (real_T *)ssGetOutputPortSignal(chartInstance->S, 3);
          c2_vx = (real_T *)ssGetInputPortSignal(chartInstance->S, 2);
          c2_sx = (real_T *)ssGetInputPortSignal(chartInstance->S, 1);
          c2_ay = (real_T *)ssGetOutputPortSignal(chartInstance->S, 2);
          c2_ax = (real_T *)ssGetOutputPortSignal(chartInstance->S, 1);
          c2_theta = (real_T *)ssGetInputPortSignal(chartInstance->S, 0);
          _SFD_SET_DATA_VALUE_PTR(0U, c2_theta);
          _SFD_SET_DATA_VALUE_PTR(1U, c2_ax);
          _SFD_SET_DATA_VALUE_PTR(2U, c2_ay);
          _SFD_SET_DATA_VALUE_PTR(3U, c2_sx);
          _SFD_SET_DATA_VALUE_PTR(4U, c2_vx);
          _SFD_SET_DATA_VALUE_PTR(5U, c2_theta_dot_dot);
          _SFD_SET_DATA_VALUE_PTR(6U, c2_sy);
          _SFD_SET_DATA_VALUE_PTR(7U, c2_vy);
          _SFD_SET_DATA_VALUE_PTR(8U, c2_t);
        }
      }
    } else {
      sf_debug_reset_current_state_configuration(sfGlobalDebugInstanceStruct,
        _rockoon_2D_LaunchMachineNumber_,chartInstance->chartNumber,
        chartInstance->instanceNumber);
    }
  }
}

static const char* sf_get_instance_specialization(void)
{
  return "J9lDttwdkI3NMAmRIirlPF";
}

static void sf_opaque_initialize_c2_rockoon_2D_Launch(void *chartInstanceVar)
{
  chart_debug_initialization(((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar)->S,0);
  initialize_params_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar);
  initialize_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_enable_c2_rockoon_2D_Launch(void *chartInstanceVar)
{
  enable_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_disable_c2_rockoon_2D_Launch(void *chartInstanceVar)
{
  disable_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar);
}

static void sf_opaque_gateway_c2_rockoon_2D_Launch(void *chartInstanceVar)
{
  sf_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar);
}

extern const mxArray* sf_internal_get_sim_state_c2_rockoon_2D_Launch(SimStruct*
  S)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_raw2high");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = (mxArray*) get_sim_state_c2_rockoon_2D_Launch
    ((SFc2_rockoon_2D_LaunchInstanceStruct*)chartInfo->chartInstance);/* raw sim ctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_rockoon_2D_Launch();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_raw2high'.\n");
  }

  return plhs[0];
}

extern void sf_internal_set_sim_state_c2_rockoon_2D_Launch(SimStruct* S, const
  mxArray *st)
{
  ChartInfoStruct *chartInfo = (ChartInfoStruct*) ssGetUserData(S);
  mxArray *plhs[1] = { NULL };

  mxArray *prhs[4];
  int mxError = 0;
  prhs[0] = mxCreateString("chart_simctx_high2raw");
  prhs[1] = mxCreateDoubleScalar(ssGetSFuncBlockHandle(S));
  prhs[2] = mxDuplicateArray(st);      /* high level simctx */
  prhs[3] = (mxArray*) sf_get_sim_state_info_c2_rockoon_2D_Launch();/* state var info */
  mxError = sf_mex_call_matlab(1, plhs, 4, prhs, "sfprivate");
  mxDestroyArray(prhs[0]);
  mxDestroyArray(prhs[1]);
  mxDestroyArray(prhs[2]);
  mxDestroyArray(prhs[3]);
  if (mxError || plhs[0] == NULL) {
    sf_mex_error_message("Stateflow Internal Error: \nError calling 'chart_simctx_high2raw'.\n");
  }

  set_sim_state_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInfo->chartInstance, mxDuplicateArray(plhs[0]));
  mxDestroyArray(plhs[0]);
}

static const mxArray* sf_opaque_get_sim_state_c2_rockoon_2D_Launch(SimStruct* S)
{
  return sf_internal_get_sim_state_c2_rockoon_2D_Launch(S);
}

static void sf_opaque_set_sim_state_c2_rockoon_2D_Launch(SimStruct* S, const
  mxArray *st)
{
  sf_internal_set_sim_state_c2_rockoon_2D_Launch(S, st);
}

static void sf_opaque_terminate_c2_rockoon_2D_Launch(void *chartInstanceVar)
{
  if (chartInstanceVar!=NULL) {
    SimStruct *S = ((SFc2_rockoon_2D_LaunchInstanceStruct*) chartInstanceVar)->S;
    if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
      sf_clear_rtw_identifier(S);
      unload_rockoon_2D_Launch_optimization_info();
    }

    finalize_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
      chartInstanceVar);
    utFree((void *)chartInstanceVar);
    ssSetUserData(S,NULL);
  }
}

static void sf_opaque_init_subchart_simstructs(void *chartInstanceVar)
{
  initSimStructsc2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
    chartInstanceVar);
}

extern unsigned int sf_machine_global_initializer_called(void);
static void mdlProcessParameters_c2_rockoon_2D_Launch(SimStruct *S)
{
  int i;
  for (i=0;i<ssGetNumRunTimeParams(S);i++) {
    if (ssGetSFcnParamTunable(S,i)) {
      ssUpdateDlgParamAsRunTimeParam(S,i);
    }
  }

  if (sf_machine_global_initializer_called()) {
    initialize_params_c2_rockoon_2D_Launch((SFc2_rockoon_2D_LaunchInstanceStruct*)
      (((ChartInfoStruct *)ssGetUserData(S))->chartInstance));
  }
}

static void mdlSetWorkWidths_c2_rockoon_2D_Launch(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S) || sim_mode_is_external(S)) {
    mxArray *infoStruct = load_rockoon_2D_Launch_optimization_info();
    int_T chartIsInlinable =
      (int_T)sf_is_chart_inlinable(S,sf_get_instance_specialization(),infoStruct,
      2);
    ssSetStateflowIsInlinable(S,chartIsInlinable);
    ssSetRTWCG(S,sf_rtw_info_uint_prop(S,sf_get_instance_specialization(),
                infoStruct,2,"RTWCG"));
    ssSetEnableFcnIsTrivial(S,1);
    ssSetDisableFcnIsTrivial(S,1);
    ssSetNotMultipleInlinable(S,sf_rtw_info_uint_prop(S,
      sf_get_instance_specialization(),infoStruct,2,
      "gatewayCannotBeInlinedMultipleTimes"));
    sf_update_buildInfo(S,sf_get_instance_specialization(),infoStruct,2);
    if (chartIsInlinable) {
      ssSetInputPortOptimOpts(S, 0, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 1, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 2, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 3, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 4, SS_REUSABLE_AND_LOCAL);
      ssSetInputPortOptimOpts(S, 5, SS_REUSABLE_AND_LOCAL);
      sf_mark_chart_expressionable_inputs(S,sf_get_instance_specialization(),
        infoStruct,2,6);
      sf_mark_chart_reusable_outputs(S,sf_get_instance_specialization(),
        infoStruct,2,3);
    }

    {
      unsigned int outPortIdx;
      for (outPortIdx=1; outPortIdx<=3; ++outPortIdx) {
        ssSetOutputPortOptimizeInIR(S, outPortIdx, 1U);
      }
    }

    {
      unsigned int inPortIdx;
      for (inPortIdx=0; inPortIdx < 6; ++inPortIdx) {
        ssSetInputPortOptimizeInIR(S, inPortIdx, 1U);
      }
    }

    sf_set_rtw_dwork_info(S,sf_get_instance_specialization(),infoStruct,2);
    ssSetHasSubFunctions(S,!(chartIsInlinable));
  } else {
  }

  ssSetOptions(S,ssGetOptions(S)|SS_OPTION_WORKS_WITH_CODE_REUSE);
  ssSetChecksum0(S,(139373762U));
  ssSetChecksum1(S,(229152239U));
  ssSetChecksum2(S,(2679658188U));
  ssSetChecksum3(S,(1427755772U));
  ssSetmdlDerivatives(S, NULL);
  ssSetExplicitFCSSCtrl(S,1);
  ssSupportsMultipleExecInstances(S,1);
}

static void mdlRTW_c2_rockoon_2D_Launch(SimStruct *S)
{
  if (sim_mode_is_rtw_gen(S)) {
    ssWriteRTWStrParam(S, "StateflowChartType", "Embedded MATLAB");
  }
}

static void mdlStart_c2_rockoon_2D_Launch(SimStruct *S)
{
  SFc2_rockoon_2D_LaunchInstanceStruct *chartInstance;
  chartInstance = (SFc2_rockoon_2D_LaunchInstanceStruct *)utMalloc(sizeof
    (SFc2_rockoon_2D_LaunchInstanceStruct));
  memset(chartInstance, 0, sizeof(SFc2_rockoon_2D_LaunchInstanceStruct));
  if (chartInstance==NULL) {
    sf_mex_error_message("Could not allocate memory for chart instance.");
  }

  chartInstance->chartInfo.chartInstance = chartInstance;
  chartInstance->chartInfo.isEMLChart = 1;
  chartInstance->chartInfo.chartInitialized = 0;
  chartInstance->chartInfo.sFunctionGateway =
    sf_opaque_gateway_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.initializeChart =
    sf_opaque_initialize_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.terminateChart =
    sf_opaque_terminate_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.enableChart = sf_opaque_enable_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.disableChart = sf_opaque_disable_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.getSimState =
    sf_opaque_get_sim_state_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.setSimState =
    sf_opaque_set_sim_state_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.getSimStateInfo =
    sf_get_sim_state_info_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.zeroCrossings = NULL;
  chartInstance->chartInfo.outputs = NULL;
  chartInstance->chartInfo.derivatives = NULL;
  chartInstance->chartInfo.mdlRTW = mdlRTW_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.mdlStart = mdlStart_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.mdlSetWorkWidths =
    mdlSetWorkWidths_c2_rockoon_2D_Launch;
  chartInstance->chartInfo.extModeExec = NULL;
  chartInstance->chartInfo.restoreLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.restoreBeforeLastMajorStepConfiguration = NULL;
  chartInstance->chartInfo.storeCurrentConfiguration = NULL;
  chartInstance->S = S;
  ssSetUserData(S,(void *)(&(chartInstance->chartInfo)));/* register the chart instance with simstruct */
  init_dsm_address_info(chartInstance);
  if (!sim_mode_is_rtw_gen(S)) {
  }

  sf_opaque_init_subchart_simstructs(chartInstance->chartInfo.chartInstance);
  chart_debug_initialization(S,1);
}

void c2_rockoon_2D_Launch_method_dispatcher(SimStruct *S, int_T method, void
  *data)
{
  switch (method) {
   case SS_CALL_MDL_START:
    mdlStart_c2_rockoon_2D_Launch(S);
    break;

   case SS_CALL_MDL_SET_WORK_WIDTHS:
    mdlSetWorkWidths_c2_rockoon_2D_Launch(S);
    break;

   case SS_CALL_MDL_PROCESS_PARAMETERS:
    mdlProcessParameters_c2_rockoon_2D_Launch(S);
    break;

   default:
    /* Unhandled method */
    sf_mex_error_message("Stateflow Internal Error:\n"
                         "Error calling c2_rockoon_2D_Launch_method_dispatcher.\n"
                         "Can't handle method %d.\n", method);
    break;
  }
}
