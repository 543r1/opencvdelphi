unit OpenCV_HighGUI;

{$A+,Z+}
{$ASSERTIONS on}

interface

uses
  Windows, IPL, OpenCV;

const
 HighGUI_DLL='highgui110.dll';

 { load image from file
   iscolor: >0 - output image is always color,
             0 - output image is always grayscale,
            <0 - output image is color or grayscale dependending on the file }
function  cvLoadImage( const filename : PChar; iscolor : integer=1) : PIplImage; cdecl;
function  cvSaveImage( const filename : PChar; const image : Pointer) : integer; cdecl;

{ start capturing frames from video file  }
function cvCreateFileCapture(filename:Pchar): PCvCapture; cdecl;

{ start capturing frames from camera: index = camera_index + domain_offset (CV_CAP_*)  }
function cvCreateCameraCapture(index:longint):PCvCapture; cdecl;

{ grab a frame, return 1 on success, 0 on fail.
  this function is thought to be fast                }
function cvGrabFrame(capture:PCvCapture):longint; cdecl;

{ get the frame grabbed with cvGrabFrame(..)
 This function may apply some frame processing like
 frame decompression, flipping etc.
!!!DO NOT RELEASE or MODIFY the retrieved frame!!!  }
function cvRetrieveFrame(capture:PCvCapture): PIplImage; cdecl;

{ Just a combination of cvGrabFrame and cvRetrieveFrame
  !!!DO NOT RELEASE or MODIFY the retrieved frame!!!       }
function cvQueryFrame(capture:PCvCapture):PIplImage;  cdecl;

{ stop capturing/reading and free resources  }
procedure cvReleaseCapture(capture:P2PCvCapture);  cdecl;


implementation

function  cvLoadImage;                    external HighGUI_DLL name 'cvLoadImage';
function  cvSaveImage;                    external HighGUI_DLL name 'cvSaveImage';
function  cvCreateFileCapture;            external HighGUI_DLL name 'cvCreateFileCapture';
function  cvCreateCameraCapture;          external HighGUI_DLL name 'cvCreateCameraCapture';
function  cvGrabFrame;                    external HighGUI_DLL name 'cvGrabFrame';
function  cvRetrieveFrame;                external HighGUI_DLL name 'cvRetrieveFrame';
function  cvQueryFrame;                   external HighGUI_DLL name 'cvQueryFrame';
procedure cvReleaseCapture;               external HighGUI_DLL name 'cvReleaseCapture';


end.
