unit OpenCV_CVAUX;

interface

uses
  Windows, Sysutils, Math, Graphics, IPL, OpenCV;

const
cvauxDLL = 'cvaux110.dll';


{
/****************************************************************************************\
*                           Background/foreground segmentation                           *
\****************************************************************************************/

/* We discriminate between foreground and background pixels
 * by building and maintaining a model of the background.
 * Any pixel which does not fit this model is then deemed
 * to be foreground.
 *
 * At present we support two core background models,
 * one of which has two variations:
 *
 *  o CV_BG_MODEL_FGD: latest and greatest algorithm, described in
 *    
 *	 Foreground Object Detection from Videos Containing Complex Background.
 *	 Liyuan Li, Weimin Huang, Irene Y.H. Gu, and Qi Tian. 
 *	 ACM MM2003 9p
 *
 *  o CV_BG_MODEL_FGD_SIMPLE:
 *       A code comment describes this as a simplified version of the above,
 *       but the code is in fact currently identical
 *
 *  o CV_BG_MODEL_MOG: "Mixture of Gaussians", older algorithm, described in
 *
 *       Moving target classification and tracking from real-time video.
 *       A Lipton, H Fujijoshi, R Patil
 *       Proceedings IEEE Workshop on Application of Computer Vision pp 8-14 1998
 *
 *       Learning patterns of activity using real-time tracking
 *       C Stauffer and W Grimson  August 2000
 *       IEEE Transactions on Pattern Analysis and Machine Intelligence 22(8):747-757
 */
}

const
  CV_BG_MODEL_FGD                     = 0;
  CV_BG_MODEL_MOG                     = 1;  { "Mixture of Gaussians".	}
  CV_BG_MODEL_FGD_SIMPLE              = 2;


type
PCvBGStatModel = ^TCvBGStatModel;
P2PCvBGStatModel = ^PCvBGStatModel;

//typedef void (CV_CDECL * CvReleaseBGStatModel)( struct CvBGStatModel** bg_model );
TCvReleaseBGStatModel = procedure(bg_model: P2PCvBGStatModel); cdecl;

//typedef int (CV_CDECL * CvUpdateBGStatModel)( IplImage* curr_frame, struct CvBGStatModel* bg_model );
TCvUpdateBGStatModel = function(curr_frame: PIplImage; bg_model: PCvBGStatModel): Integer;  cdecl;


////typedef struct CvBGStatModel
////{
////    int             type; /*type of BG model*/
////    CvReleaseBGStatModel release;
////    CvUpdateBGStatModel update;
////    IplImage*       background;   /*8UC3 reference background image*/
////    IplImage*       foreground;   /*8UC1 foreground image*/
////    IplImage**      layers;       /*8UC3 reference background image, can be null */
////    int             layer_count;  /* can be zero */
////    CvMemStorage*   storage;      /*storage for “foreground_regions”*/
////    CvSeq*          foreground_regions; /*foreground object contours*/
////}
////CvBGStatModel;

CvBGStatModel = record
  type_: Integer;   {type of BG model}
  release: TCvReleaseBGStatModel; //direct function call????
  update: TCvUpdateBGStatModel;   //direct function call????
  background: PIplImage;   {8UC3 reference background image}
  foreground: PIplImage;   {8UC1 foreground image}
  layers: P2PIplImage;      {8UC3 reference background image, can be null }
  layer_count: Integer;    { can be zero }
  storage: PCvMemStorage;  {storage for “foreground_regions”}
  foreground_regions: PCvSeq;  {foreground object contours}
end;
TCvBGStatModel = CvBGStatModel;



const
(*
  Interface of ACM MM2003 algorithm
*)

(* Default parameters of foreground detection algorithm: *)
  CV_BGFG_FGD_LC                      = 128;
  CV_BGFG_FGD_N1C                     = 15;
  CV_BGFG_FGD_N2C                     = 25;

  CV_BGFG_FGD_LCC                     = 64;
  CV_BGFG_FGD_N1CC                    = 25;
  CV_BGFG_FGD_N2CC                    = 40;

(* Background reference image update parameter: *)
  CV_BGFG_FGD_ALPHA_1                 = 0.1;

(* stat model update parameter
 * 0.002f ~ 1K frame(~45sec), 0.005 ~ 18sec (if 25fps and absolutely static BG)
 *)
  CV_BGFG_FGD_ALPHA_2                 = 0.005;

(* start value for alpha parameter (to fast initiate statistic model) *)
  CV_BGFG_FGD_ALPHA_3                 = 0.1;
  CV_BGFG_FGD_DELTA                   = 2;
  CV_BGFG_FGD_T                       = 0.9;
  CV_BGFG_FGD_MINAREA                 = 15.0;
  CV_BGFG_FGD_BG_UPDATE_TRESH         = 0.5;

type
////typedef struct CvFGDStatModelParams
////{
////    int    Lc;			/* Quantized levels per 'color' component. Power of two, typically 32, 64 or 128.				*/
////    int    N1c;			/* Number of color vectors used to model normal background color variation at a given pixel.			*/
////    int    N2c;			/* Number of color vectors retained at given pixel.  Must be > N1c, typically ~ 5/3 of N1c.			*/
////				/* Used to allow the first N1c vectors to adapt over time to changing background.				*/
////
////    int    Lcc;			/* Quantized levels per 'color co-occurrence' component.  Power of two, typically 16, 32 or 64.			*/
////    int    N1cc;		/* Number of color co-occurrence vectors used to model normal background color variation at a given pixel.	*/
////    int    N2cc;		/* Number of color co-occurrence vectors retained at given pixel.  Must be > N1cc, typically ~ 5/3 of N1cc.	*/
////				/* Used to allow the first N1cc vectors to adapt over time to changing background.				*/
////
////    int    is_obj_without_holes;/* If TRUE we ignore holes within foreground blobs. Defaults to TRUE.						*/
////    int    perform_morphing;	/* Number of erode-dilate-erode foreground-blob cleanup iterations.						*/
////				/* These erase one-pixel junk blobs and merge almost-touching blobs. Default value is 1.			*/
////
////    float  alpha1;		/* How quickly we forget old background pixel values seen.  Typically set to 0.1  				*/
////    float  alpha2;		/* "Controls speed of feature learning". Depends on T. Typical value circa 0.005. 				*/
////    float  alpha3;		/* Alternate to alpha2, used (e.g.) for quicker initial convergence. Typical value 0.1.				*/
////
////    float  delta;		/* Affects color and color co-occurrence quantization, typically set to 2.					*/
////    float  T;			/* "A percentage value which determines when new features can be recognized as new background." (Typically 0.9).*/
////    float  minArea;		/* Discard foreground blobs whose bounding box is smaller than this threshold.					*/
////}
////CvFGDStatModelParams;

CvFGDStatModelParams = record
  Lc: Integer;    { Quantized levels per 'color' component. Power of two, typically 32, 64 or 128.				}
  N1c: Integer;   { Number of color vectors used to model normal background color variation at a given pixel.			}
  N2c: Integer;   { Number of color vectors retained at given pixel.  Must be > N1c, typically ~ 5/3 of N1c.			}
                  { Used to allow the first N1c vectors to adapt over time to changing background.				}
  Lcc: Integer;   { Quantized levels per 'color co-occurrence' component.  Power of two, typically 16, 32 or 64.			}
  N1cc: Integer;  { Number of color co-occurrence vectors used to model normal background color variation at a given pixel.	}
  N2cc: Integer;  { Number of color co-occurrence vectors retained at given pixel.  Must be > N1cc, typically ~ 5/3 of N1cc.	}
                  { Used to allow the first N1cc vectors to adapt over time to changing background.				}
  is_obj_without_holes: Integer;   { If TRUE we ignore holes within foreground blobs. Defaults to TRUE.						}
  perform_morphing: Integer;      { Number of erode-dilate-erode foreground-blob cleanup iterations.						}
                                  { These erase one-pixel junk blobs and merge almost-touching blobs. Default value is 1.			}
  alpha1: Single;   { How quickly we forget old background pixel values seen.  Typically set to 0.1  				}
  alpha2: Single;   { "Controls speed of feature learning". Depends on T. Typical value circa 0.005. 				}
  alpha3: Single;   { Alternate to alpha2, used (e.g.) for quicker initial convergence. Typical value 0.1.				}
  delta: Single;    { Affects color and color co-occurrence quantization, typically set to 2.					}
  T: Single;        { "A percentage value which determines when new features can be recognized as new background." (Typically 0.9).}
  minArea: Single;   { Discard foreground blobs whose bounding box is smaller than this threshold.					}
end;
TCvFGDStatModelParams = CvFGDStatModelParams;
PCvFGDStatModelParams = ^TCvFGDStatModelParams;

////typedef struct CvBGPixelCStatTable
////{
////    float          Pv, Pvb;
////    uchar          v[3];
////}
////CvBGPixelCStatTable;

PCvBGPixelCStatTable = ^TCvBGPixelCStatTable;
CvBGPixelCStatTable = record
  Pv: Single;
  Pvb: Single;
  v: array[0..2] of uchar;
end;
TCvBGPixelCStatTable = CvBGPixelCStatTable;

////typedef struct CvBGPixelCCStatTable
////{
////    float          Pv, Pvb;
////    uchar          v[6];
////}
////CvBGPixelCCStatTable;

PCvBGPixelCCStatTable = ^TCvBGPixelCCStatTable;
CvBGPixelCCStatTable = record
  Pv: Single;
  Pvb: Single;
  v: array[0..5] of uchar;
end;
TCvBGPixelCCStatTable = CvBGPixelCCStatTable;

////typedef struct CvBGPixelStat
////{
////    float                 Pbc;
////    float                 Pbcc;
////    CvBGPixelCStatTable*  ctable;
////    CvBGPixelCCStatTable* cctable;
////    uchar                 is_trained_st_model;
////    uchar                 is_trained_dyn_model;
////}
////CvBGPixelStat;

PCvBGPixelStat = ^TCvBGPixelStat;
CvBGPixelStat = record
  Pbc: Single;
  Pbcc: Single;
  ctable: PCvBGPixelCStatTable;
  cctable: PCvBGPixelCCStatTable;
  is_trained_st_model: uchar;
  is_trained_dyn_model: uchar;
end;
TCvBGPixelStat = CvBGPixelStat;


////typedef struct CvFGDStatModel
////{
////    CvBGPixelStat*         pixel_stat;
////    IplImage*              Ftd;
////    IplImage*              Fbd;
////    IplImage*              prev_frame;
////    CvFGDStatModelParams   params;
////}
////CvFGDStatModel;

PCvFGDStatModel = ^TCvFGDStatModel;
CvFGDStatModel = record
  type_: Integer;   {type of BG model}
  release: TCvReleaseBGStatModel; //direct function call????
  update: TCvUpdateBGStatModel;   //direct function call????
  background: PIplImage;   {8UC3 reference background image}
  foreground: PIplImage;   {8UC1 foreground image}
  layers: P2PIplImage;      {8UC3 reference background image, can be null }
  layer_count: Integer;    { can be zero }
  storage: PCvMemStorage;  {storage for “foreground_regions”}
  foreground_regions: PCvSeq;  {foreground object contours}
  pixel_stat: PCvBGPixelStat;
  Ftd: PIplImage;
  Fbd: PIplImage;
  prev_frame: PIplImage;
  params: CvFGDStatModelParams;
end;
TCvFGDStatModel = CvFGDStatModel;


const
(*
   Interface of Gaussian mixture algorithm

   "An improved adaptive background mixture model for real-time tracking with shadow detection"
   P. KadewTraKuPong and R. Bowden,
   Proc. 2nd European Workshp on Advanced Video-Based Surveillance Systems, 2001."
   http://personal.ee.surrey.ac.uk/Personal/R.Bowden/publications/avbs01/avbs01.pdf
*)

(* Note:  "MOG" == "Mixture Of Gaussians": *)

  {$EXTERNALSYM CV_BGFG_MOG_MAX_NGAUSSIANS}
  CV_BGFG_MOG_MAX_NGAUSSIANS          = 500; 

(* default parameters of gaussian background detection algorithm *)
  CV_BGFG_MOG_BACKGROUND_THRESHOLD    = 0.7;  { threshold sum of weights for background test }
  CV_BGFG_MOG_STD_THRESHOLD           = 2.5; { lambda = 2.5 is 99%  }
  CV_BGFG_MOG_WINDOW_SIZE             = 200;  { Learning rate; alpha = 1/CV_GBG_WINDOW_SIZE }
  CV_BGFG_MOG_NGAUSSIANS              = 5;  { = K = number of Gaussians in mixture }
  CV_BGFG_MOG_WEIGHT_INIT             = 0.5;
  CV_BGFG_MOG_SIGMA_INIT              = 30;
  CV_BGFG_MOG_MINAREA                 = 15.0;

  CV_BGFG_MOG_NCOLORS                 = 3;

type
////typedef struct CvGaussBGStatModelParams
////{
////    int     win_size;               /* = 1/alpha */
////    int     n_gauss;
////    double  bg_threshold, std_threshold, minArea;
////    double  weight_init, variance_init;
////}CvGaussBGStatModelParams;
PCvGaussBGStatModelParams = ^TCvGaussBGStatModelParams;
CvGaussBGStatModelParams = record
  win_size: Integer;   { = 1/alpha }
  n_gauss: Integer;
  bg_threshold: Double;
  std_threshold: Double;
  minArea: Double;
  weight_init: Double;
  variance_init: Double;
end;
TCvGaussBGStatModelParams = CvGaussBGStatModelParams;

////typedef struct CvGaussBGValues
////{
////    int         match_sum;
////    double      weight;
////    double      variance[CV_BGFG_MOG_NCOLORS];
////    double      mean[CV_BGFG_MOG_NCOLORS];
////}
////CvGaussBGValues;

PCvGaussBGValues = ^TCvGaussBGValues;
CvGaussBGValues = record
  match_sum: Integer;
  weight: Double;
  variance: array[0..CV_BGFG_MOG_NCOLORS - 1] of Double;
  mean: array[0..CV_BGFG_MOG_NCOLORS - 1] of Double;
end;
TCvGaussBGValues = CvGaussBGValues;

////typedef struct CvGaussBGPoint
////{
////    CvGaussBGValues* g_values;
////}
////CvGaussBGPoint;
PCvGaussBGPoint = ^TCvGaussBGPoint;
CvGaussBGPoint = record
  g_values: PCvGaussBGValues;
end;
TCvGaussBGPoint = CvGaussBGPoint;


////typedef struct CvGaussBGModel
////{
////    CvGaussBGStatModelParams   params;
////    CvGaussBGPoint*            g_point;    
////    int                        countFrames;
////}
////CvGaussBGModel;

PCvGaussBGModel = ^TCvGaussBGModel;
CvGaussBGModel = record
  type_: Integer;   {type of BG model}
  release: TCvReleaseBGStatModel; //direct function call????
  update: TCvUpdateBGStatModel;   //direct function call????
  background: PIplImage;   {8UC3 reference background image}
  foreground: PIplImage;   {8UC1 foreground image}
  layers: P2PIplImage;      {8UC3 reference background image, can be null }
  layer_count: Integer;    { can be zero }
  storage: PCvMemStorage;  {storage for “foreground_regions”}
  foreground_regions: PCvSeq;  {foreground object contours}
  params: CvGaussBGStatModelParams;
  g_point: PCvGaussBGPoint;
  countFrames: Integer;
end;
TCvGaussBGModel = CvGaussBGModel;



// Releases memory used by BGStatModel
procedure cvReleaseBGStatModel( bg_model: P2PCvBGStatModel );  cdecl;

// Updates statistical model and returns number of found foreground regions
function cvUpdateBGStatModel(const current_frame: PIplImage; const bg_model: PCvBGStatModel): Integer; cdecl; inline;


// Performs FG post-processing using segmentation
// (all pixels of a region will be classified as foreground if majority of pixels of the region are FG).
// parameters:
//      segments - pointer to result of segmentation (for example MeanShiftSegmentation)
//      bg_model - pointer to CvBGStatModel structure
procedure cvRefineForegroundMaskBySegm( segments: PCvSeq;  bg_model: PCvBGStatModel );  cdecl;

// Common use change detection function
function cvChangeDetection( prev_frame: PIplImage;
                            curr_frame: PIplImage;
                            change_mask: PIplImage): Integer;   cdecl;


// Creates FGD model
function cvCreateFGDStatModel( first_frame : PIplImage;
                               parameters: PCvFGDStatModelParams = nil): PCvBGStatModel; cdecl;


// Creates Gaussian mixture background model
function cvCreateGaussianBGModel( first_frame: PIplImage;
                                  parameters: PCvGaussBGStatModelParams = nil): PCvBGStatModel; cdecl;


function icvUpdateGaussianBGModel (current_frame: PIplImage; bg_model: PCvBGStatModel): Integer; cdecl;



implementation

procedure cvReleaseBGStatModel( bg_model: P2PCvBGStatModel );
begin
{
    if( bg_model && *bg_model && (*bg_model)->release )
        (*bg_model)->release( bg_model );
}
  if Assigned(bg_model) and Assigned(bg_model^) and Assigned(bg_model^.release) then
  begin
    bg_model^.release(bg_model);
  end;
end;


function cvUpdateBGStatModel(const current_frame: PIplImage; const bg_model: PCvBGStatModel): Integer;
var
  tmp: Integer;
begin
{
    return bg_model && bg_model->update ? bg_model->update( current_frame, bg_model ) : 0;
}
try
  if Assigned(bg_model) and Assigned(bg_model.update) then
    tmp := bg_model.update(current_frame, bg_model)
  else
    tmp := 0;
except
  tmp := 0;
end;
  Result := tmp;
end;


procedure cvRefineForegroundMaskBySegm; external cvauxDLL name 'cvRefineForegroundMaskBySegm';
function cvChangeDetection; external cvauxDLL name 'cvChangeDetection';
function cvCreateFGDStatModel; external cvauxDLL name 'cvCreateFGDStatModel';
function cvCreateGaussianBGModel; external cvauxDLL name 'cvCreateGaussianBGModel';
function icvUpdateGaussianBGModel; external cvauxDLL name 'icvUpdateGaussianBGModel';


end.
