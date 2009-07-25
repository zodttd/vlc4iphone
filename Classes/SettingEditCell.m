/*

File: SettingEditCell.m
Abstract: 
 Custom table cell used in the editing view's table. Contains a UITextField for
in-place editing of content.

*/

#import "SettingEditCell.h"

@implementation SettingEditCell

@synthesize textField;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
        // Set the frame to CGRectZero as it will be reset in layoutSubviews
        textField = [[UITextField alloc] initWithFrame:CGRectZero];
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = [UIFont systemFontOfSize:18.0];
        textField.textColor = [UIColor darkGrayColor];
        [self addSubview:textField];
    }
    return self;
}

- (void)dealloc {
    // Release allocated resources.
    [textField dealloc];
    [super dealloc];
}

- (void)layoutSubviews {
    // Place the subviews appropriately.
    textField.frame = CGRectInset(self.contentView.bounds, 10, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Update text color so that it matches expected selection behavior.
    if (selected) {
        textField.textColor = [UIColor yellowColor];
    } else {
        textField.textColor = [UIColor blueColor];
    }
}

@end
