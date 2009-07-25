/*

File: Constants.h
Abstract: Common constants across source files (screen coordinate consts, etc.)

*/

// these are the various screen placement constants used across all the UIViewControllers
 
// padding for margins
#define kLeftMargin				20.0
#define kTopMargin				20.0
#define kRightMargin			20.0
#define kBottomMargin			20.0
#define kTweenMargin			10.0

// control dimensions
#define kPageControlHeight		20.0
#define kPageControlWidth		160.0
//#define kSliderHeight			7.0
#define kSwitchButtonWidth		94.0
#define kSwitchButtonHeight		27.0
#define kSegmentedControlWidth  110.0
#define kSegmentedControlHeight 27.0
//#define kTextFieldHeight		30.0
#define kSearchBarHeight		40.0
//#define kLabelHeight			20.0
//#define kProgressIndicatorSize	40.0
//#define kToolbarHeight			40.0
//#define kUIProgressBarWidth		160.0
//#define kUIProgressBarHeight	24.0

// specific font metrics used in our text fields and text views
#define kFontName				@"Arial"
#define kTextFieldFontSize		18.0
#define kTextViewFontSize		18.0

// UITableView row heights
#define kUIRowHeight			50.0
#define kUIRowLabelHeight		22.0

// table view cell content offsets
#define kCellLeftOffset			20.0
#define kCellTopOffset			12.0

//accelerometer
#define kAccelerationThreshold          2.0

enum ControlTableSections
{
	kPlayerSection = 0,
	kServerSection	
};