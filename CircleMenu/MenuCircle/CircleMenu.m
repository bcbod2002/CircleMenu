//
//  CircleMenu.m
//  CircleMenu
//
//  Created by shinsoft on 2013/12/30.
//  Copyright (c) 2013年 shinsoft. All rights reserved.
//

#import "CircleMenu.h"

@implementation CircleMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//
-(id)initMenu
{
    self = [super init];
    self.userInteractionEnabled = YES;
    tap_tag = NO;
    [self setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, 50, 50)];
    
    [self setBackgroundColor:[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.7]];
    self.layer.cornerRadius = 15;
    
    init_circle.x = self.frame.origin.x;
    init_circle.y = self.frame.origin.y;
    init_circle.width = self.frame.size.width;
    init_circle.height = self.frame.size.height;
    
    target_circle.width = 300;
    target_circle.height = 300;
    target_circle.x = 160 - (target_circle.width / 2);
    target_circle.y = 284 - (target_circle.height / 2);
    
    if (self)
    {
        menu_items = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < 6; i++)
        {
            CircleItem *phony_item = [[CircleItem alloc] initWithNumber:i];
            phony_item.delegate = self;
            [menu_items addObject:phony_item];
            [self addSubview:phony_item];
        }
    }
    
    UITapGestureRecognizer *tap_cancel = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel_chosen:)];
    [self addGestureRecognizer:tap_cancel];
    
    return self;
}

// 點選 Menu 背景便會收縮 Item
-(void)cancel_chosen:(UITapGestureRecognizer *)event
{
    [self item_shrink_parabola];
    tap_tag = NO;
}

// 手指觸碰到畫面時便記錄手指觸碰的位置
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!tap_tag)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        location = point;
    }
}

// 手指移動的時候 Menu 便跟著手指移動
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!tap_tag)
    {
        CGPoint point = [[touches anyObject] locationInView:self];
        CGRect frame = self.frame;
        
        frame.origin.x += (point.x - location.x);
        frame.origin.y += (point.y - location.y);
        
        [self setFrame:frame];
    }
}

// 設定 Item 的圖片
-(void)set_icons:(NSArray *)array_icon
{
    for (NSInteger i = 0; i < 6; ++i)
    {
        [[menu_items objectAtIndex:i] set_icon:[UIImage imageNamed:[array_icon objectAtIndex:i]]];
    }
}

// 被選中的 item 便會展開或是收縮
-(void)circle_item_chosen:(NSInteger)number
{
    if (!tap_tag)
    {
        item_num_selected = number;
        [self item_extend_parabola];
        tap_tag = YES;
    }
    else
    {
        [self item_shrink_parabola];
        [self.delegate item_chosen:number];
        [self bringSubviewToFront:[menu_items objectAtIndex:number]];
        tap_tag = NO;
    }
}

// Item 收縮結束時，Menu 開始收縮
-(void)item_shrink_stopped:(BOOL)flag
{
    [self background_move_to_locate];
    // Goston ADD 會被呼叫6次   有問題
}

// Menu 伸展 與 Item 伸展
-(void)item_extend_parabola
{
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self setFrame:CGRectMake(target_circle.x, target_circle.y, target_circle.width, target_circle.height)];
        for (NSInteger i = 0; i < 6; ++i)
        {
            [[menu_items objectAtIndex:i] setFrame:CGRectMake((self.frame.size.width / 2) - (init_circle.width / 2), (self.frame.size.height / 2) - (init_circle.height / 2), init_circle.width, init_circle.height)];
        }
    } completion:^(BOOL finished) {
        for (NSInteger i = 0; i < 6; ++i)
        {
            if (i != item_num_selected)
            {
                [[menu_items objectAtIndex:i] item_extend_parabola];
            }
        }
    }];
}


// Item 收縮
-(void)item_shrink_parabola
{
    // Goston ADD 收起的時候位子出錯 1/2
    for (NSInteger i = 0; i < 6; ++i)
    {
        if (i != item_num_selected)
        {
            [[menu_items objectAtIndex:i] item_shrink_parabola];
        }
    }
}

// Menu 收縮
-(void)background_move_to_locate
{
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
        [self setFrame:CGRectMake(init_circle.x, init_circle.y, init_circle.width, init_circle.height)];
        for (NSInteger i = 0; i < 6; ++i)
        {
            [[menu_items objectAtIndex:i] setFrame:CGRectMake(0, 0, init_circle.width, init_circle.height)];
        }
    } completion:^(BOOL finished) {
        
    }];
}

// 在 Menu 跟著手指移動後，Menu 不會跑出畫片之外，並黏著邊界
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!tap_tag)
    {
        if (self.center.x > 160)
        {
            if (self.center.y < self.frame.size.height)
            {
                [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
                    [self setFrame:CGRectMake(320 - self.frame.size.width, [UIApplication sharedApplication].statusBarFrame.size.height, self.frame.size.width, self.frame.size.height)];
                } completion:^(BOOL finished) {
                    
                }];

            }
            else if ((568 - self.center.y) < self.frame.size.height)
            {
                [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
                    [self setFrame:CGRectMake(/*320 - self.frame.size.width*/self.frame.origin.x, 568 - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                } completion:^(BOOL finished) {
                    
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
                    [self setFrame:CGRectMake(320 - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
                } completion:^(BOOL finished) {
                    
                    
                }];
            }
        }
        else
        {
            if (self.center.y < self.frame.size.height)
            {
                [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
                    [self setFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.frame.size.width, self.frame.size.height)];
                } completion:^(BOOL finished) {
                    
                }];
                
            }
            else if ((568 - self.center.y) < self.frame.size.height)
            {
                [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
                    [self setFrame:CGRectMake(/*0*/self.frame.origin.x, 568 - self.frame.size.height, self.frame.size.width, self.frame.size.height)];
                } completion:^(BOOL finished) {
                    
                    
                }];
            }
            else
            {
                [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionCurveEaseInOut) animations:^{
                    [self setFrame:CGRectMake(0, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
                } completion:^(BOOL finished) {
                    
                    
                }];
            }
        }
    }
    init_circle.x = self.frame.origin.x;
    init_circle.y = self.frame.origin.y;
}

/*-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchlocation = [touch locationInView:self.superview];
    
    [self setFrame:CGRectMake(touchlocation.x, touchlocation.y, self.frame.size.width, self.frame.size.height)];
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
