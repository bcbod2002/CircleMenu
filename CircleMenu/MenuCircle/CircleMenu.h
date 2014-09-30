//
//  CircleMenu.h
//  CircleMenu
//
//  Created by shinsoft on 2013/12/30.
//  Copyright (c) 2013年 Goston. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleItem.h"

@class CircleMenu;
@protocol CircleMenuDelegate <NSObject>
@required
-(void)item_chosen:(NSInteger)chosen_number;
@end

typedef struct
{
    CGFloat width, height;
    CGFloat x, y;
}Menu;

@interface CircleMenu : UIView <CircleItemDelegate, UIGestureRecognizerDelegate>
{
    NSMutableArray *menu_items;
    BOOL tap_tag;
    NSMutableArray *item_images;
    NSMutableArray *item_labels;
    Menu init_circle;
    Menu target_circle;
    
    NSInteger item_num_selected;
    CGPoint location;
}
@property (weak, nonatomic) id <CircleMenuDelegate>delegate;
@property (nonatomic) BOOL view_display_tag;

-(id)initMenu;
-(void)set_icons:(NSArray *)array_icon;

@end
