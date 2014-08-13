//
//  CircleItem.h
//  CircleMenu
//
//  Created by shinsoft on 2013/12/27.
//  Copyright (c) 2013年 shinsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#include <math.h>

@class CircleItem;
@protocol CircleItemDelegate <NSObject>
@optional
-(void)circle_item_chosen:(NSInteger)number;
-(void)item_shrink_stopped:(BOOL)flag;
@end

@interface CircleItem : UIView <UIGestureRecognizerDelegate>
{
    UIImageView *image_view;
    UILabel *item_lable;
    NSInteger self_number;
    NSInteger default_vector;
    double proportion;
    
    BOOL long_tag;
    
    CGPoint location;
}

@property(weak, nonatomic)id <CircleItemDelegate> delegate;

-(id)initWithNumber:(NSInteger)number;

-(void)item_shrink_parabola;
-(void)item_extend_parabola;

-(void)set_icon:(UIImage *)image;
-(void)set_move_vector:(NSInteger)vector;
@end
