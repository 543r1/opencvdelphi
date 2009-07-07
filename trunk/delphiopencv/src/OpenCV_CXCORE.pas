unit OpenCV_CXCORE;

{$A+,Z+}
{$ASSERTIONS on}

interface

uses
  Windows, Sysutils, Math, Graphics, IPL, OpenCV;

const
 cxCore = 'cxcore110.dll';

{ Creates IPL image (header and data)  }
function cvCreateImage(size:CvSize; depth:longint; channels:longint):PIplImage;
                        cdecl;
{ Returns width and height of array in elements  }
function cvGetSize(const arr: PCvArr):CvSize; cdecl;

{ Copies source array to destination array  }
procedure cvCopy(src:PCvArr; dst:PCvArr; mask:PCvArr); cdecl;

{ dst(idx) = lower <= src(idx) < upper  }
procedure cvInRangeS(src:PCvArr; lower:CvScalar; upper:CvScalar; dst:PCvArr); cdecl;

{ Sets image ROI (region of interest) (COI is not changed)  }
procedure cvSetImageROI(image:PIplImage; rect:CvRect); cdecl;

{ Resets image ROI and COI  }
procedure cvResetImageROI(image:PIplImage); cdecl;


{ Clears all the array elements (sets them to 0)  }
procedure cvSetZero(arr:PCvArr); cdecl;
procedure cvZero(arr:PCvArr); cdecl;

{ Performs linear transformation on every source array element:
  dst(x,y,c) = scale*src(x,y,c)+shift.
  Arbitrary combination of input and output array depths are allowed
  (number of channels must be the same), thus the function can be used
  for type conversion  }
procedure cvConvertScale(src:PCvArr; dst:PCvArr; scale:double; shift:double); cdecl;

{ Splits a multi-channel array into the set of single-channel arrays or
  extracts particular [color] plane  }
procedure cvSplit(src:PCvArr; dst0:PCvArr; dst1:PCvArr; dst2:PCvArr; dst3:PCvArr); cdecl;

{ dst(idx) = src1(idx) & src2(idx)  }
procedure cvAnd(src1:PCvArr; src2:PCvArr; dst:PCvArr; mask:PCvArr);  cdecl;

{ for 1-channel arrays  }
function cvGetReal1D(arr:PCvArr; idx0:longint):double; cdecl;
function cvGetReal2D(arr:PCvArr; idx0:longint; idx1:longint):double; cdecl;
function cvGetReal3D(arr:PCvArr; idx0:longint; idx1:longint; idx2:longint):double; cdecl;
function cvGetRealND(arr:PCvArr; idx:Plongint):double; cdecl;

{ dst(idx) = src(idx) ^ value  }
procedure cvXorS(src:PCvArr; value:CvScalar; dst:PCvArr; mask:PCvArr); cdecl;

{ Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),
  if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn  }
procedure cvRectangle(img:PCvArr; pt1:CvPoint; pt2:CvPoint; color:CvScalar;
            thickness:longint; line_type:longint; shift:longint); cdecl;

{ Draws ellipse outline, filled ellipse, elliptic arc or filled elliptic sector,
  depending on <thickness>, <start_angle> and <end_angle> parameters. The resultant figure
  is rotated by <angle>. All the angles are in degrees  }
procedure cvEllipse(img:PCvArr; center:CvPoint; axes:CvSize; angle:double;
            start_angle:double; end_angle:double; color:CvScalar;
            thickness:longint; line_type:longint; shift:longint); cdecl;

procedure cvEllipseBox(img:PCvArr; box:CvBox2D; color:CvScalar; thickness:longint;
              line_type:longint; shift:longint);


{ Creates new memory storage.
  block_size == 0 means that default, somewhat optimal size, is used (currently, it is 64K). }
function  cvCreateMemStorage( block_size : integer =0) : PCvMemStorage; cdecl;

{ Releases memory storage. All the children of a parent must be released before
  the parent. A child storage returns all the blocks to parent when it is released  }
procedure cvReleaseMemStorage( storage : P2PCvMemStorage ); cdecl;

{  Clears memory storage. This is the only way(!!!) (besides cvRestoreMemStoragePos)
   to reuse memory allocated for the storage - cvClearSeq,cvClearSet ...
   do not free any memory.
   A child storage returns all the blocks to the parent when it is cleared }
procedure cvClearMemStorage( storage : PCvMemStorage ); cdecl;

{ simple API for reading/writing data }
//procedure cvSave( const char* filename, const void* struct_ptr,
//                    const char* name CV_DEFAULT(NULL),
//                    const char* comment CV_DEFAULT(NULL),
//                    CvAttrList attributes CV_DEFAULT(cvAttrList()));

////void cvLoad(
////  const char* filename,
////  CvMemStorage* memstorage,
////  const char* name,
////  const char** real_name );

function cvLoad(const filename: PChar;
  memstorage: PCvMemStorage;
  const name: PChar;
  const real_name: PChar): Pointer; cdecl;

{ helper functions for RNG initialization and accurate time measurement:
  uses internal clock counter on x86 }
function cvGetTickCount(): Int64; cdecl;
function cvGetTickFrequency(): Double; cdecl;


{ Retrieves pointer to specified sequence element.
  Negative indices are supported and mean counting from the end
  (e.g -1 means the last sequence element) }
function cvGetSeqElem(seq: PCvSeq; idx: Integer ): PChar; cdecl;

(* Makes a new matrix from <rect> subrectangle of input array.
   No data is copied *)
function cvGetSubRect(const arr: PCvArr; submat: PCvMat; rect: CvRect): PCvMat; cdecl;

(* Draws a circle with specified center and radius.
   Thickness works in the same way as with cvRectangle *)
procedure cvCircle(img: PCvArr; center: CvPoint; radius: Integer;
  color: CvScalar; thickness: Integer = 1;
  line_type: Integer = 8; shift: Integer = 0); cdecl;

(* Allocates and initializes CvMat header and allocates data *)
function cvCreateMat(rows: Integer; cols: Integer; mtype: Integer): PCvMat; cdecl;

{ Releases IPL image header and data }
procedure cvReleaseImage( image : P2PIplImage ); cdecl;

{ Releases CvMat header and deallocates matrix data
   (reference counting is used for data) }
procedure cvReleaseMat(mat: P2PCvMat); cdecl;

procedure cvAbsDiff(src1:PCvArr; src2:PCvArr; dst:PCvArr);  cdecl;


implementation

function  cvLoad;                         external cxCore name 'cvLoad';
function  cvCreateImage;                  external cxCore name 'cvCreateImage';
function  cvGetSize;                      external cxCore name 'cvGetSize';
procedure cvCopy;                         external cxCore name 'cvCopy';
procedure cvInRangeS;                     external cxCore name 'cvInRangeS';
procedure cvSetZero;                      external cxCore name 'cvSetZero';
procedure cvZero;                         external cxCore name 'cvSetZero';
procedure cvSetImageROI;                  external cxCore name 'cvSetImageROI';
procedure cvResetImageROI;                external cxCore name 'cvResetImageROI';
procedure cvConvertScale;                 external cxCore name 'cvConvertScale';
procedure cvSplit;                        external cxCore name 'cvSplit';
procedure cvAnd;                          external cxCore name 'cvAnd';
procedure cvAbsDiff;                      external cxCore name 'cvAbsDiff';
function  cvGetReal1D;                    external cxCore name 'cvGetReal1D';
function  cvGetReal2D;                    external cxCore name 'cvGetReal2D';
function  cvGetReal3D;                    external cxCore name 'cvGetReal3D';
function  cvGetRealND;                    external cxCore name 'cvGetRealND';
procedure cvXorS;                         external cxCore name 'cvXorS';
procedure cvRectangle;                    external cxCore name 'cvRectangle';
procedure cvEllipse;                      external cxCore name 'cvEllipse';
function  cvCreateMemStorage;             external cxCore name 'cvCreateMemStorage';
procedure cvReleaseMemStorage;            external cxCore name 'cvReleaseMemStorage';
procedure cvClearMemStorage;              external cxCore name 'cvClearMemStorage';
function  cvGetTickCount;                 external cxCore name 'cvGetTickCount';
function  cvGetTickFrequency;             external cxCore name 'cvGetTickFrequency';
function  cvGetSeqElem;                   external cxCore name 'cvGetSeqElem';
function  cvGetSubRect;                   external cxCore name 'cvGetSubRect';
procedure cvCircle;                       external cxCore name 'cvCircle';
function  cvCreateMat;                    external cxCore name 'cvCreateMat';
procedure cvReleaseImage;                 external cxCore name 'cvReleaseImage';
procedure cvReleaseMat;                   external cxCore name 'cvReleaseMat';


procedure cvEllipseBox(img:PCvArr; box:CvBox2D; color:CvScalar; thickness:longint;
              line_type:longint; shift:longint);
var
      axes: CvSize;
begin
      axes.width := cvRound(box.size.height *0.5);
      axes.height := cvRound(box.size.width *0.5);

      cvEllipse( img, cvPointFrom32f_( box.center ), axes, (box.angle*180/pi),
                 0, 360, color, thickness, line_type, shift );
end;

end.
