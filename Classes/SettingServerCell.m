/*

File: SettingServerCell.m
Abstract: 
 Custom table cell used in the main view's table. Capable of displaying in two
modes - a "type:name" mode for existing
 data and a "prompt" mode when used as a placeholder for data creation.

*/

#import "SettingServerCell.h"

@implementation SettingServerCell

//@synthesize type, 
@synthesize name, prompt, promptMode;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Initialize the labels, their fonts, colors, alignment, and background color.
        name = [[UILabel alloc] initWithFrame:CGRectZero];
        name.font = [UIFont boldSystemFontOfSize:14];
        name.backgroundColor = [UIColor clearColor];
        prompt = [[UILabel alloc] initWithFrame:CGRectZero];
        prompt.font = [UIFont boldSystemFontOfSize:12];
        prompt.textColor = [UIColor darkGrayColor];
        prompt.backgroundColor = [UIColor clearColor];
        
        // Add the labels to the content view of the cell.
        
        // Important: although UITableViewCell inherits from UIView, you should add subviews to its content view
        // rather than directly to the cell so that they will be positioned appropriately as the cell transitions 
        // into and out of editing mode.
        
        [self.contentView addSubview:name];
        [self.contentView addSubview:prompt];
//        self.autoresizesSubviews = YES;
    }
    return self;
}

- (void)dealloc {
    [name dealloc];
    [prompt dealloc];
    [super dealloc];
}

// Setting the prompt mode to YES hides the type/name labels and shows the prompt label.
- (void)setPromptMode:(BOOL)flag {
    if (flag) {
        name.hidden = YES;
        prompt.hidden = NO;
    } else {
        name.hidden = NO;
        prompt.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // Start with a rect that is inset from the content view by 10 pixels on all sides.
    CGRect baseRect = CGRectInset(self.contentView.bounds, 10, 10);
    CGRect rect = baseRect;
    rect.origin.x += 15;
    // Position each label with a modified version of the base rect.
    prompt.frame = rect;
    rect.origin.x += 20;
    rect.size.width = baseRect.size.width - 40;
    name.frame = rect;
}

// Update the text color of each label when entering and exiting selected mode.
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        name.textColor = [UIColor whiteColor];
        prompt.textColor = [UIColor whiteColor];
    } else {
        name.textColor = [UIColor blackColor];
        prompt.textColor = [UIColor darkGrayColor];
    }
}

@end
