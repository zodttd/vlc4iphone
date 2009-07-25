//
//  TableEditorViewController.h
//  VideoStreaming
//
//  Created by ZodTTD & Derek Tse on 09年4月5日.
//  Copyright 2009 ZodTTD (Spookysoft LLC) & HKUST. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TableEditorViewController : UIViewController {
	IBOutlet UITextField *editTextField;
}

@property (nonatomic, retain) IBOutlet UITextField* editTextField;

-(void) addNewItemInArray:(NSMutableArray*) array;
-(void) editItemAtIndex:(NSInteger) index OfArray:(NSMutableArray*) array;
@end
