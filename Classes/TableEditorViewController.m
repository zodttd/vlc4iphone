//
//  TableEditorViewController.m
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月5日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import "TableEditorViewController.h"

@interface TableEditorViewController(private)
BOOL isNewItem;
NSMutableArray *editingArray;
NSInteger editingItemIndex;

-(void) cancel;
-(void) save;
@end


@implementation TableEditorViewController

@synthesize editTextField;

// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)] autorelease];
		self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action: @selector(save)] autorelease];
    }
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	[self.editTextField setKeyboardType:UIKeyboardTypeURL];
	[self.editTextField becomeFirstResponder];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[editingArray release];
	[editTextField release];
    [super dealloc];
}


#pragma mark private methods
-(void) save
{
	if([editTextField.text length] == 0) return;
	
	if(isNewItem)
	{
		[editingArray addObject:self.editTextField.text];
	}
	else {
		[editingArray replaceObjectAtIndex:editingItemIndex withObject:self.editTextField.text];
	}

	[self.navigationController popViewControllerAnimated:YES];
}

-(void) cancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark public methods

-(void) addNewItemInArray:(NSMutableArray*) array{
	self.editTextField.text = @"";
	isNewItem = YES;
	editingArray = array;
}

-(void) editItemAtIndex:(NSInteger) index OfArray:(NSMutableArray*) array
{
	isNewItem = NO;
	editingArray = array;
	editingItemIndex = index;
	self.editTextField.text = (NSString*)[array objectAtIndex:index];
}

@end
