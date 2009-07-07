unit OpenCV_CV;

{$A+,Z+}
{$ASSERTIONS on}

interface

uses
  Windows, Sysutils, Math, Graphics, IPL, OpenCV;

const
 cvDLL = 'cv110.dll';

procedure cvFindExtrinsicCameraParams( numPoints         : integer;
                                        imageSize         : TCvSize;
                                        imagePoints32f    : PCvPoint2D32f;
                                        objectPoints32f   : PCvPoint3D32f;
                                        focalLength32f    : PCvVect32f;
                                        principalPoint32f : TCvPoint2D32f;
                                        distortion32f     : PCvVect32f;
                                        rotVect32f        : PCvVect32f;
                                        transVect32f      : PCvVect32f
                                        ); cdecl;

{ Calibrates camera using multiple views of calibration pattern }
procedure  cvCalibrateCamera( numImages         : Integer;        //int
                               numPoints         : PInteger;       //int*
                               imageSize         : TCvSize;        //CvSize
                               imagePoints32f    : PCvPoint2D32f;  //CvPoint2D32f*
                               objectPoints32f   : PCvPoint3D32f;  //CvPoint3D32f*
                               distortion32f     : PCvVect32f;     //CvVect32f
                               cameraMatrix32f   : PCvMatr32f;     //CvMatr32f
                               transVects32f     : PCvVect32f;     //CvVect32f
                               rotMatrs32f       : PCvMatr32f;     //CvMatr32f
                               useIntrinsicGuess : Integer         //int
                               ); cdecl;

procedure cvRodrigues( rotMatrix : PCVMAT;
                        rotVector : PCVMAT;
                        jacobian  : PCVMAT;
                        convType  : Integer ); cdecl ;

 { Allocates array data }
procedure cvCreateData( arr : Pointer ); cdecl;
 { Releases array data  }
procedure cvReleaseData(arr : Pointer ); cdecl;

function  cvInvert( const A : PCvArr; B : PCvArr; method : integer ) : double; cdecl;
//function  cvPseudoInverse( const src : PCvArr; dst : PCvArr ) : double;

procedure cvMatMulAdd( const  A,B,C : PCvArr;  D : PCvArr ); cdecl;
//procedure cvMatMul( A,B,D : PCvArr );

{ Allocates and initializes IplImage header }
function cvCreateImageHeader( size : TCvSize; depth, channels : integer ) : PIplImage; cdecl;
{ Releases (i.e. deallocates) IPL image header  : void  cvReleaseImageHeader( IplImage** image );}
procedure cvReleaseImageHeader( var image : PIplImage ); cdecl;
{ Creates a copy of IPL image (widthStep may differ). }
function  cvCloneImage( const image : PIplImage ) : PIplImage; cdecl;
{ Converts input array from one color space to another. }
procedure cvCvtColor( const src : Pointer; dst : Pointer; colorCvtCode : integer );  cdecl;


{ Detects corners on a chess-board - "brand" OpenCV calibration pattern }
function  cvFindChessBoardCornerGuesses( const arr          : Pointer;
                                                thresh       : Pointer;
                                                storage      : PCvMemStorage;
                                                etalon_size  : TCvSize;
                                                corners      : PCvPoint2D32f;
                                                corner_count : PInteger ) : integer;  cdecl;

{  Adjust corner position using some sort of gradient search }
procedure  cvFindCornerSubPix( const  src         : Pointer;
                                      corners     : PCvPoint2D32f;
                                      count       : integer;
                                      win         : TCvSize;
                                      zero_zone   : TCvSize;
                                      criteria    : TCvTermCriteria ); cdecl;

procedure cvCalcBackProject(image:P2PIplImage; dst:PCvArr; hist:PCvHistogram);
{ Calculates back project  }
procedure cvCalcArrBackProject(image:P2PCvArr; dst:PCvArr; hist:PCvHistogram); cdecl;

{ Creates new histogram  }
function cvCreateHist(dims:longint; sizes:Plongint; _type:longint; ranges:P2Pfloat;
        uniform:longint): PCvHistogram; cdecl;

procedure cvCalcHist(image:longint; hist:PCvHistogram; accumulate:longint; mask:PCvArr);
{ Calculates array histogram  }
procedure cvCalcArrHist(arr:P2PCvArr; hist:PCvHistogram; accumulate:longint; mask:PCvArr); cdecl;

{ Finds indices and values of minimum and maximum histogram bins  }
procedure cvGetMinMaxHistValue(hist:PCvHistogram; min_value:Pdouble;
                max_value:Pdouble; min_idx:Plongint; max_idx:Plongint);  cdecl;


{ Implements CAMSHIFT algorithm - determines object position, size and orientation
  from the object histogram back project (extension of meanshift)  }
function cvCamShift(prob_image:PCvArr; window:CvRect; criteria:CvTermCriteria;
            comp:PCvConnectedComp; box:PCvBox2D):longint; cdecl;

{ Resizes image (input array is resized to fit the destination array) }
procedure cvResize(const src:PCvArr; dst:PCvArr; interpolation:longint=CV_INTER_LINEAR );  cdecl;

{ equalizes histogram of 8-bit single-channel image }
procedure cvEqualizeHist(const src:PCvArr; dst:PCvArr); cdecl;


//CVAPI(CvSeq*) cvHaarDetectObjects( const CvArr* image,
//                     CvHaarClassifierCascade* cascade,
//                     CvMemStorage* storage, double scale_factor CV_DEFAULT(1.1),
//                     int min_neighbors CV_DEFAULT(3), int flags CV_DEFAULT(0),
//                     CvSize min_size CV_DEFAULT(cvSize(0,0)));

const
  defaultmin : CvSize =
    ( width: 0;
      height: 0; );

function cvHaarDetectObjects(const image:PCvArr;
                     cascade: PCvHaarClassifierCascade;
                     storage: PCvMemStorage;
                     scale_factor: Double;
                     min_neighbors: Integer;
                     flags: Integer;
                     min_size: CvSize): PCvSeq; cdecl;


procedure cvReleaseHaarClassifierCascade( cascade: P2PCvHaarClassifierCascade ); cdecl;



implementation

procedure cvCreateData;                   external cvDLL name 'cvCreateData';
procedure cvReleaseData;                  external cvDLL name 'cvReleaseData';
function  cvCreateImageHeader;            external cvDLL name 'cvCreateImageHeader';
procedure cvReleaseImageHeader;           external cvDLL name 'cvReleaseImageHeader';
procedure cvCalibrateCamera;              external cvDLL name 'cvCalibrateCamera';
procedure cvFindExtrinsicCameraParams;    external cvDLL name 'cvFindExtrinsicCameraParams';
procedure cvRodrigues;                    external cvDLL name 'cvRodrigues';
function  cvInvert;                       external cvDLL name 'cvInvert';
procedure cvMatMulAdd;                    external cvDLL name 'cvMatMulAdd';
procedure cvCvtColor;                     external cvDLL name 'cvCvtColor';
function  cvCloneImage;                   external cvDLL name 'cvCloneImage';
function  cvFindChessBoardCornerGuesses;  external cvDLL name 'cvFindChessBoardCornerGuesses';
procedure cvFindCornerSubPix;             external cvDLL name 'cvFindCornerSubPix';
function  cvCreateHist;                   external cvDLL name 'cvCreateHist';
procedure cvCalcArrHist;                  external cvDLL name 'cvCalcArrHist';
procedure cvGetMinMaxHistValue;           external cvDLL name 'cvGetMinMaxHistValue';
procedure cvCalcArrBackProject;           external cvDLL name 'cvCalcArrBackProject';
function  cvCamShift;                     external cvDLL name 'cvCamShift';
procedure cvResize;                       external cvDLL name 'cvResize';
procedure cvEqualizeHist;                 external cvDLL name 'cvEqualizeHist';
function  cvHaarDetectObjects;            external cvDLL name 'cvHaarDetectObjects';
procedure cvReleaseHaarClassifierCascade; external cvDLL name 'cvReleaseHaarClassifierCascade';

procedure cvCalcBackProject(image:P2PIplImage; dst:PCvArr; hist:PCvHistogram);
begin
  cvCalcArrBackProject(P2PCvArr(image), dst, hist);
end;

procedure cvCalcHist(image:longint; hist:PCvHistogram; accumulate:longint; mask:PCvArr);
begin
//      cvCalcArrHist( (CvArr**)image, hist, accumulate, mask );
      cvCalcArrHist(P2PCvArr(image), hist, accumulate, mask );

end;

//function cvPseudoInverse( const src : PCvArr; dst : PCvArr ) : double;
//begin
//  cvInvert( src, dst, CV_SVD );
//end;

//procedure cvMatMul( A,B,D : PCvArr );
//begin
//  cvMatMulAdd(A,B,nil,D);
//end;


end.
