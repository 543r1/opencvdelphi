    (*********************************************************************
     *                                                                   *
     *  Borland Delphi 4,5,6,7 API for                                   *
     *  Intel Open Source Computer Vision Library                        *
     *                                                                   *
     *                                                                   *
     *  Portions created by Intel Corporation are                        *
     *  Copyright (C) 2000, Intel Corporation, all rights reserved.      *
     *                                                                   *
     *  The original files are: CV.h, CVTypes.h, highgui.h               *        
     *                                                                   *
     *                                                                   *
     *  The original Pascal code is: OpenCV.pas,  released 29 May 2003.  *                                 
     *                                                                   *
     *  The initial developer of the Pascal code is Vladimir Vasilyev    *        
     *                  home page : http://www.nextnow.com               *
     *                  email     : Vladimir@nextnow.com                 *
     *                              W-develop@mtu-net.ru                 *
     *                                                                   *
     *  Contributors: Andrey Klimov                                      *
     *********************************************************************
     *  Expanded version to use CAMShift functions                       *
     *  G. De Sanctis - 9/2005                                           *
     *                                                                   *
     *********************************************************************
     *                                                                   *
     *                                                                   *
     *  The contents of this file are used with permission, subject to   *
     *  the Mozilla Public License Version 1.1 (the "License"); you may  *
     *  not use this file except in compliance with the License. You may *
     *  obtain a copy of the License at                                  *
     *  http://www.mozilla.org/MPL/MPL-1.1.html                          *
     *                                                                   *
     *  Software distributed under the License is distributed on an      *
     *  "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   *
     *  implied. See the License for the specific language governing     *
     *  rights and limitations under the License.                        *
     *                                                                   *
     *********************************************************************)


unit OpenCV;

{$A+,Z+}
{$ASSERTIONS on}

interface

uses
  Windows, Sysutils, Math, Graphics, IPL;

const

  CV_CN_MAX                           = 64;
  CV_CN_SHIFT                         = 3;
  CV_DEPTH_MAX                        = (1 shl CV_CN_SHIFT);

  CV_8U                               = 0;
  CV_8S                               = 1;
  CV_16U                              = 2;
  CV_16S                              = 3;
  CV_32S                              = 4;
  CV_32F                              = 5;
  CV_64F                              = 6;
  CV_USRTYPE1                         = 7;

//  CV_MAKE_TYPE                        = CV_MAKETYPE;

//#define CV_8UC1 CV_MAKETYPE(CV_8U,1)
//#define CV_8UC2 CV_MAKETYPE(CV_8U,2)
//#define CV_8UC3 CV_MAKETYPE(CV_8U,3)
//#define CV_8UC4 CV_MAKETYPE(CV_8U,4)
//#define CV_8UC(n) CV_MAKETYPE(CV_8U,(n))

 CV_32FC1 = CV_32F + 0*8;

 CV_MAT_TYPE_MASK = 31;
 CV_MAT_MAGIC_VAL = $42420000;
 CV_MAT_CONT_FLAG_SHIFT = 9;
 CV_MAT_CONT_FLAG = 1 shl CV_MAT_CONT_FLAG_SHIFT;

 CV_MAT_CN_MASK = 3 shl 3;
 CV_MAT_DEPTH_MASK = 7;


 CV_RODRIGUES_M2V = 0;
 CV_RODRIGUES_V2M = 1;


 CV_LU  = 0;
 CV_SVD = 1;


 CV_BGR2GRAY = 6;
 CV_RGB2GRAY = 7;
 CV_BGR2HSV = 40;
 CV_GRAY2BGR = 8;
 CV_FILLED = -(1);
 CV_AA = 16;

type

  PCvVect32f = PSingle;
  TCvVect32fArr=array of Single;

  PCvMatr32f = PSingle;
  TCvMatr32fArr=array of Single;
  
  TIntegerArr=array of Integer;
  

  CvSize = record
            width  : integer;
            height : integer;
           end;
  TCvSize = CvSize;
  PCvSize = ^TCvSize;

  CvPoint2D32f = record
                    x : Single;
                    y : Single;
                 end;
  TCvPoint2D32f = CvPoint2D32f;
  PCvPoint2D32f = ^TCvPoint2D32f;
  TCvPoint2D32fArr=array of TCvPoint2D32f;


  CvPoint3D32f = record
                    x : Single;
                    y : Single;
                    z : Single;
                 end;
  TCvPoint3D32f = CvPoint3D32f;
  PCvPoint3D32f = ^TCvPoint3D32f;
  TCvPoint3D32fArr=array of TCvPoint3D32f;

  CvMat = record
            type_    : Integer;
            step     : Integer;
            refcount : PInteger;
            hdr_refcount: Integer;
            data : record
              case longint of
                0 : ( ptr : ^uchar ); // uchar* ptr;
                1 : ( s : ^smallint ); // short* s;
                2 : ( i : ^longint ); // int* i;
                3 : ( fl : ^double ); // float* fl;
                4 : ( db : ^double ); // double* db;
              end;
            rows     : Integer;
            cols     : Integer;
          end;
  TCvMat = CvMat;
  PCvMat = ^TCvMat;
  P2PCvMat = ^PCvMat;


    { CvArr* is used to pass arbitrary array-like data structures
     into the functions where the particular
     array type is recognized at runtime  }
    // CvArr = void;
  PCvArr = Pointer;
  P2PCvArr = ^PCvArr;

//****************************************************************************************\
//*                       Multi-dimensional dense array (CvMatND)                          *
//****************************************************************************************/
  const
     CV_MATND_MAGIC_VAL = $42430000;
     CV_TYPE_NAME_MATND = 'opencv-nd-matrix';     
     CV_MAX_DIM = 32;     
     CV_MAX_DIM_HEAP = 1 shl 16;

  type

     CvMatND = record
          _type : longint;
          dims : longint;
          refcount : ^longint;
          data : record
              case longint of
                 0 : ( ptr : ^uchar );
                 1 : ( fl : ^double );
                 2 : ( db : ^double );
                 3 : ( i : ^longint );
                 4 : ( s : ^smallint );
              end;
          dim : array[0..(CV_MAX_DIM)-1] of record
               size : longint;
               step : longint;
            end;
       end;


  {***************************************************************************************\
  *                                         Histogram                                      *
  \*************************************************************************************** }

  type

     CvHistType = longint;

  const
     CV_HIST_MAGIC_VAL = $42450000;
     CV_HIST_UNIFORM_FLAG = 1 shl 10;
  { indicates whether bin ranges are set already or not  }
     CV_HIST_RANGES_FLAG = 1 shl 11;
     CV_HIST_ARRAY = 0;
     CV_HIST_SPARSE = 1;
     CV_HIST_TREE = CV_HIST_SPARSE;
  { should be used as a parameter only,
     it turns to CV_HIST_UNIFORM_FLAG of hist->type  }
     CV_HIST_UNIFORM = 1;
  { for uniform histograms  }
  { for non-uniform histograms  }
  { embedded matrix header for array histograms  }

  type

     CvHistogram = record
          _type : longint;
          bins : PCvArr;
          thresh : array[0..(CV_MAX_DIM)-1] of array[0..1] of float;
          thresh2 : P2Pfloat;
          mat : CvMatND;
       end;
   PCvHistogram = ^CvHistogram;

//******************************** Memory storage ****************************************/
Type
  PCvMemBlock = ^TCvMemBlock;
  CvMemBlock = Record
                 prev : PCvMemBlock;
                 next : PCvMemBlock;
               end;
  TCvMemBlock = CvMemBlock;

Const CV_STORAGE_MAGIC_VAL = $42890000;

Type
  PCvMemStorage = ^TCvMemStorage;
  CvMemStorage = Record
                   signature : integer;
                   bottom    : PCvMemBlock;   //* first allocated block */
                   top       : PCvMemBlock;   //* current memory block - top of the stack */
                   parent    : PCvMemStorage; //* borrows new blocks from */
                   block_size: integer;       //* block size */
                   free_space: integer;       //* free space in the current block */
                 end; 
  TCvMemStorage = CvMemStorage;
  P2PCvMemStorage = ^PCvMemStorage;


   {********************************** Sequence ****************************************** }
  { previous sequence block  }
  { next sequence block  }
  { index of the first element in the block +
                                   sequence->first->start_index  }
  { number of elements in the block  }
  { pointer to the first element of the block  }

  type

     PCvSeqBlock = ^CvSeqBlock;
     CvSeqBlock = record
          prev : PCvSeqBlock;
          next : PCvSeqBlock;
          start_index : longint;
          count : longint;
          data : Pchar;
       end;
       
     PCvSeq = ^CvSeq;
     CvSeq = record
          flags : longint;
          header_size : longint;
          h_prev : PCvSeq;
          h_next : PCvSeq;
          v_prev : PCvSeq;
          v_next : PCvSeq;
          total : longint;
          elem_size : longint;
          block_max : PChar;
          ptr : PChar;
          delta_elems : longint;
          storage : PCvMemStorage;
          free_blocks : PCvSeqBlock;
          first : PCvSeqBlock;
       end;
{************************************ CvScalar **************************************** }

     CvScalar = record
          val : array[0..3] of double;
       end;
{************************************** CvRect **************************************** }

  type

     CvRect = record
          x : longint;
          y : longint;
          width : longint;
          height : longint;
       end;
     PCvRect = ^CvRect;



  {*************************** Connected Component  ************************************* }
  { area of the connected component   }
  { average color of the connected component  }
  { ROI of the component   }
  { optional component boundary
           (the contour might have child contours corresponding to the holes) }

     CvConnectedComp = record
          area : double;
          value : CvScalar;
          rect : CvRect;
          contour : PCvSeq;
       end;
     PCvConnectedComp = ^CvConnectedComp;
{****************************** CvPoint and variants ********************************** }

  type

     CvPoint = record
          x : longint;
          y : longint;
       end;

     CvPoint2D64f = record
          x : double;
          y : double;
       end;

     CvPoint3D64f = record
          x : double;
          y : double;
          z : double;
       end;

     CvSize2D32f = record
          width : float;
          height : float;
       end;
  { center of the box  }
  { box width and length  }
  { angle between the horizontal axis
                               and the first side (i.e. length) in radians  }

     CvBox2D = record
          center : CvPoint2D32f;
          size : CvSize2D32f;
          angle : float;
       end;
     PCvBox2D = ^CvBox2D;
  { Line iterator state  }
  { pointer to the current point  }
  { Bresenham algorithm state  }

     CvLineIterator = record
          ptr : ^uchar;
          err : longint;
          plus_delta : longint;
          minus_delta : longint;
          plus_step : longint;
          minus_step : longint;
       end;


//*********************************** CvTermCriteria *************************************/
Const
 CV_TERMCRIT_ITER = 1;
 CV_TERMCRIT_NUMB = CV_TERMCRIT_ITER;
 CV_TERMCRIT_EPS  = 2;

Type
  CvTermCriteria  = Record
    type_   : integer;  { may be combination of CV_TERMCRIT_ITER, CV_TERMCRIT_EPS }
    maxIter : integer;
    epsilon : double;
  end;
  TCvTermCriteria = CvTermCriteria;
{\*********************************** CvTermCriteria *************************************}

const
CV_INTER_NN       = 0;
CV_INTER_LINEAR   = 1;
CV_INTER_CUBIC    = 2;
CV_INTER_AREA     = 3;

const
CV_HAAR_FEATURE_MAX = 3;

type
CvHaarFeature = record
    tilted: Integer;
    rect : array[0..(CV_HAAR_FEATURE_MAX)-1] of record
      r: CvRect;
      weight: Float;
    end;
end;
PCvHaarFeature = ^CvHaarFeature;

type
CvHaarClassifier = record
    count: Integer;
    haar_feature: PCvHaarFeature;
    threshold: Float;
    left: PInt;
    right: PInt;
    alpha: PFloat;
end;
PCvHaarClassifier = ^CvHaarClassifier;

type
CvHaarStageClassifier = record

    count: Integer;
    threshold: Float;
    classifier: PCvHaarClassifier ;
    next: Integer;
    child: Integer;
    parent: Integer;
end;
PCvHaarStageClassifier = ^CvHaarStageClassifier;

type
CvHidHaarClassifierCascade = record

end;
PCvHidHaarClassifierCascade = ^CvHidHaarClassifierCascade;

type
CvHaarClassifierCascade = record
    flags: longint;
    count: longint;
    orig_window_size: CvSize;
    real_window_size: CvSize;
    scale: Double;
    stage_classifier: PCvHaarStageClassifier ;
    hid_cascade: PCvHidHaarClassifierCascade ;
end;
PCvHaarClassifierCascade = ^CvHaarClassifierCascade;
P2PCvHaarClassifierCascade = ^PCvHaarClassifierCascade;

const
  CV_HAAR_DO_CANNY_PRUNING            = 1;
  CV_HAAR_SCALE_IMAGE                 = 2;
  CV_HAAR_FIND_BIGGEST_OBJECT         = 4;
  CV_HAAR_DO_ROUGH_SEARCH             = 8;







{Delphi procedure to convert a OpenCV iplImage to a Delphi TBitmap}
procedure IplImage2Bitmap(iplImg: PIplImage; var bitmap: TBitmap);

{functions/procedures not in DLL, written in this unit}
function cvMat_( rows, cols, type_: Integer; data : Pointer ):TCvMat;
function cvmGet( const mat : PCvMat; i, j : integer): Single;
procedure cvmSet( mat : PCvMat; i, j : integer; val: Single);
function cvSize_( width, height : integer ) : TcvSize;
function cvScalar_(val0:double; val1:double; val2:double; val3:double):CvScalar;
function cvScalarAll(val0123:double):CvScalar;
function cvFloor(value: double): longint;
function cvRound(value:double):longint;
function cvPoint_( x, y: longint ): CvPoint;
function cvPointFrom32f_( point: CvPoint2D32f ): CvPoint;
function cvTermCriteria_( type_: longint; max_iter: longint; epsilon: double ): CvTermCriteria;
function CV_RGB(r,g,b : longint) : CvScalar;
function cvRect_( x, y, width, height: longint ): CvRect;
function CV_MAKETYPE(depth: DWORD; cn: DWORD): DWORD;  inline;



 {-----------------------------------------------}
                           




  {***************************************************************************************\
  *                         Working with Video Files and Cameras                           *
  \*************************************************************************************** }
  { "black box" capture structure  }

  type
    CvCapture = record
    end;
    PCvCapture = ^CvCapture;
    P2PCvCapture = ^PCvCapture;


  const
     CV_CAP_ANY = 0;
     CV_CAP_MIL = 100;
     CV_CAP_VFW = 200;
     CV_CAP_V4L = 200;
     CV_CAP_V4L2 = 200;
     CV_CAP_FIREWARE = 300;
     CV_CAP_IEEE1394 = 300;
     CV_CAP_DC1394 = 300;
     CV_CAP_CMU1394 = 300;




{*****************************************************************************}

implementation

function CV_MAKETYPE(depth: DWORD; cn: DWORD): DWORD;  inline;
begin
  Result := ((depth)+ (((cn)- 1)shl CV_CN_SHIFT));
end;

 function CV_MAT_TYPE( flags : integer): integer;
 begin
    Result:=(flags and CV_MAT_TYPE_MASK);
 end;

 function CV_MAT_DEPTH( flags : integer): integer;
 begin
    Result:=(flags and CV_MAT_DEPTH_MASK);
 end;

 function CV_MAT_CN( flags : integer): integer;
 begin
    Result:=((flags and CV_MAT_CN_MASK) shr 3)+1;
 end;

 function CV_ELEM_SIZE( type_ : integer): integer;
 begin
    Result:=(CV_MAT_CN(type_) shl (($e90 shr CV_MAT_DEPTH(type_)*2) and 3));
 end;

 function cvMat_( rows : Integer; cols : Integer; type_: Integer; data : Pointer) : CvMat ;
 begin
    type_:= CV_MAT_TYPE(type_);
    Result.type_:= CV_MAT_MAGIC_VAL or CV_MAT_CONT_FLAG or type_;
    Result.cols := cols;
    Result.rows := rows;
    Result.step := Result.cols*CV_ELEM_SIZE(type_);
    Result.data.ptr := data;
    Result.refcount := nil;
 end;

 
 Function cvmGet( const mat : PCvMat; i, j : integer): Single;
 var
  type_ : integer;
  ptr   : PByte;
  pf    : PSingle;
 begin
    type_:= CV_MAT_TYPE(mat.type_);
    assert(  ( i<mat.rows) and (j<mat.cols) );

    if type_ = CV_32FC1 then begin
       ptr:=PByte(mat.data.ptr);
       inc(ptr, mat.step*i+ sizeOf(Single)*j);
       pf:=PSingle(ptr);
       Result:=pf^;
    end
    else Result:=0;

 end;


 Procedure cvmSet( mat : PCvMat; i, j : integer; val: Single  );
 var
  type_ : integer;
  ptr   : PByte;
  pf    : PSingle;
 begin
    type_:= CV_MAT_TYPE(mat.type_);
    assert(  ( i<mat.rows) and (j<mat^.cols) );

    if type_ = CV_32FC1 then begin
       ptr:=PByte(mat.data.ptr);
       inc(ptr, mat.step*i+ sizeOf(Single)*j);
       pf:=PSingle(ptr);
       pf^:=val;
    end;

 end;


 Function cvSize_( width, height : integer ) : TcvSize;
 begin
    Result.width:=width;
    Result.height:=height;
 end;

{-----------------------------------}

function cvScalar_(val0:double; val1:double; val2:double; val3:double):CvScalar;
var
      scalar: CvScalar ;
begin
      scalar.val[0] := val0; scalar.val[1] := val1;
      scalar.val[2] := val2; scalar.val[3] := val3;
      result := scalar;
end;

function cvScalarAll(val0123:double):CvScalar;
var
        scalar: CvScalar;
begin
      scalar.val[0] := val0123;
      scalar.val[1] := val0123;
      scalar.val[2] := val0123;
      scalar.val[3] := val0123;
      result := scalar;
end;



function cvRound(value:double):longint;
//var
//        temp: double;
begin
      {*
       the algorithm was taken from Agner Fog's optimization guide
       at http://www.agner.org/assem
       *}
    //  temp := value + 6755399441055744.0;
    //  result := (int)*((uint64*)&temp);
      result := round(value);

end;

function cvFloor(value:double):longint;
begin
        result := floor(value);
end;

function cvPoint_( x, y: longint ): CvPoint;
var
    p: CvPoint;
begin
    p.x := x;
    p.y := y;

    result := p;
end;

function  cvTermCriteria_( type_: longint; max_iter: longint; epsilon: double ): CvTermCriteria;
var
    t: CvTermCriteria;
begin
    t.type_ := type_;
    t.maxIter := max_iter;
    t.epsilon := epsilon;

    result := t;
end;

function CV_RGB(r,g,b : longint) : CvScalar;
begin
   CV_RGB := cvScalar_(b,g,r,0);
end;

function  cvPointFrom32f_( point: CvPoint2D32f ): CvPoint;
var
    ipt: CvPoint;
begin
    ipt.x := cvRound(point.x);
    ipt.y := cvRound(point.y);

    result := ipt;
end;

function  cvRect_( x, y, width, height: longint ): CvRect;
var
    r: CvRect;
begin
    r.x := x;
    r.y := y;
    r.width := width;
    r.height := height;

    result := r;
end;


{-----------------------------------------------------------------------------
  Procedure:  IplImage2Bitmap
  Author:     De Sanctis
  Date:       23-set-2005
  Arguments:  iplImg: PIplImage; bitmap: TBitmap
  Description: convert a IplImage to a Windows bitmap
-----------------------------------------------------------------------------}
procedure IplImage2Bitmap(iplImg: PIplImage; var bitmap: TBitmap);
  VAR
    i        :  INTEGER;
    j        :  INTEGER;
    offset   :  longint;
    dataByte :  PByteArray;
    RowIn    :  pByteArray;
BEGIN
  TRY
    assert((iplImg.Depth = 8) and (iplImg.NChannels = 3),
                'IplImage2Bitmap: Not a 24 bit color iplImage!');

    bitmap.Height := iplImg.Height;
    bitmap.Width := iplImg.Width;
    FOR j := 0 TO Bitmap.Height-1 DO
    BEGIN
      // origin BL = Bottom-Left
      if (iplimg.Origin = IPL_ORIGIN_BL) then
              RowIn  := Bitmap.Scanline[bitmap.height -1 -j ]
      else
              RowIn  := Bitmap.Scanline[j ];

      offset := longint(iplimg.ImageData) + iplImg.WidthStep * j;
      dataByte := pbytearray( offset);

      if (iplImg.ChannelSeq = 'BGR') then
      begin
        {direct copy of the iplImage row bytes to bitmap row}
        CopyMemory(rowin, dataByte, iplImg.WidthStep);
      end
      else
          FOR i := 0 TO 3*Bitmap.Width-1 DO
            begin
                RowIn[i] := databyte[i+2] ;
                RowIn[i+1] := databyte[i+1] ;
                RowIn[i+2] := databyte[i];
            end;


//      FOR i := 0 TO 3*Bitmap.Width-1 DO
//      BEGIN
//        if iplImg.ChannelSeq = 'BGR' then
//        begin
//            RowIn[i] := databyte[i] ;
//            RowIn[i+1] := databyte[i+1] ;
//            RowIn[i+2] := databyte[i+2];
//        end else
//        begin
//            RowIn[i] := databyte[i+2] ;
//            RowIn[i+1] := databyte[i+1] ;
//            RowIn[i+2] := databyte[i];
//        end;
//      END;
    END;
  Except

  END
END; {IplImage2Bitmap}

{****************************************************************************}
end.


