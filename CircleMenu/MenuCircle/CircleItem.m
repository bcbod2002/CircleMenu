//
//  CircleItem.m
//  CircleMenu
//
//  Created by shinsoft on 2013/12/27.
//  Copyright (c) 2013年 shinsoft. All rights reserved.
//

#import "CircleItem.h"

@implementation CircleItem

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 初始化 Item 的大小與 Item 的號碼牌
-(id)initWithNumber:(NSInteger)number
{
    self = [super init];
    if (self)
    {
        [self setUserInteractionEnabled:YES];
        [self setFrame:CGRectMake(0, 0, 50, 50)];
        self.layer.cornerRadius = 15;
        self_number = number;
    }
    default_vector = 90;
    UITapGestureRecognizer *tap_item = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(item_tapped:)];
    
    [self addGestureRecognizer:tap_item];
    
    return self;
}

-(void)set_move_vector:(NSInteger)vector
{
    default_vector = vector;
}

// 被 Tap 的 Item 通知給 menu 知道
-(void)item_tapped:(UITapGestureRecognizer *)event
{
    [self.delegate circle_item_chosen:self_number];
}

// 設定 item 的圖片
-(void)set_icon:(UIImage *)image
{
    image_view = [[UIImageView alloc] initWithImage:image];
    [image_view setFrame:self.frame];
    [self addSubview:image_view];
}

/*- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat;
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0  * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}*/

// 展開的動作
- (void)item_extend_parabola
{
    // 設定 Item 初始位置 Menu 頁面的正中心
    CGFloat item_center_x = (self.superview.frame.size.width / 2);
    CGFloat item_center_y = (self.superview.frame.size.height / 2);
    
    // 預設的移動的距離為 90
    CGFloat vector = default_vector;
    CGFloat vector_x = 0;
    CGFloat vector_y = 0;
    
    // 畫出弧線的角度為 90 度
    CGFloat curve_parabola_x = vector / 2 * cosf(M_PI_2);
    CGFloat curve_parabola_y = vector / 2 * sinf(M_PI_2);
    CGMutablePathRef path = CGPathCreateMutable();
    
    // 移動到 Menu 頁面正中心
    CGPathMoveToPoint(path, NULL, item_center_x, item_center_y);
    
    // 不同的 Item 展開到不同的位置
    switch (self_number)
    {
        case 0:
        {
            vector_x = vector * cosf(0);
            vector_y = vector * sinf(0);
        }
            break;
        case 1:
        {
            vector_x = vector * cosf(M_PI / 3);
            vector_y = vector * sinf(M_PI / 3);
        }
            break;
        case 2:
        {
            vector_x = vector * cosf(M_PI / 3 * 2);
            vector_y = vector * sinf(M_PI / 3 * 2);
        }
            break;
        case 3:
        {
            vector_x = vector * cosf(M_PI);
            vector_y = vector * sinf(M_PI);
        }
            break;
        case 4:
        {
            vector_x = vector * cosf(M_PI / 3 * 4);
            vector_y = vector * sinf(M_PI / 3 * 4);
        }
            break;
        case 5:
        {
            vector_x = vector * cosf(M_PI / 3 * 5);
            vector_y = vector * sinf(M_PI / 3 * 5);
        }
            break;
            
        default:
            break;
    }
    
    // 以弧線移動到定點
    CGPathAddCurveToPoint(path, NULL, item_center_x, item_center_y, item_center_x + curve_parabola_x, item_center_y + curve_parabola_y, item_center_x + vector_x, item_center_y + vector_y);
    
    // Animation 的 key 為 position
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    [animation setPath:path];
    [animation setDuration:0.3];
    
    CFRelease(path);
    
    // 開始動畫到並移動到定點
    [self.layer addAnimation:animation forKey:@"parabola"];
    
    // 最後將 Item 的位置固定，不然會跳回原本的定點
    [self setFrame:CGRectMake(item_center_x + vector_x - self.frame.size.width / 2, item_center_y + vector_y - self.frame.size.height / 2, self.frame.size.width, self.frame.size.height)];
}


// 收縮的動作
-(void)item_shrink_parabola
{
    // 設定 Item 初始位置，由於動畫移動是 UIView 的 Center ，這邊設定 Item 的位置
    CGFloat item_center_x = self.frame.origin.x + self.frame.size.width / 2;
    CGFloat item_center_y = self.frame.origin.y + self.frame.size.height / 2;
    
    // 預設的移動的距離為 80
    CGFloat vector = -default_vector;
    CGFloat vector_x = 0;
    CGFloat vector_y = 0;
    
    // 畫出弧線的角度為 90 度
    CGFloat curve_parabola_x = vector / 2 * cosf(M_PI_2);
    CGFloat curve_parabola_y = vector / 2 * sinf(M_PI_2);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Item 的位置
    CGPathMoveToPoint(path, NULL, item_center_x, item_center_y);
    
    // 不同的 Item 收縮到相同的位置
    switch (self_number)
    {
        case 0:
        {
            vector_x = vector * cosf(0);
            vector_y = vector * sinf(0);
        }
            break;
        case 1:
        {
            vector_x = vector * cosf(M_PI / 3);
            vector_y = vector * sinf(M_PI / 3);
        }
            break;
        case 2:
        {
            vector_x = vector * cosf(M_PI / 3 * 2);
            vector_y = vector * sinf(M_PI / 3 * 2);
        }
            break;
        case 3:
        {
            vector_x = vector * cosf(M_PI);
            vector_y = vector * sinf(M_PI);
        }
            break;
        case 4:
        {
            vector_x = vector * cosf(M_PI / 3 * 4);
            vector_y = vector * sinf(M_PI / 3 * 4);
        }
            break;
        case 5:
        {
            vector_x = vector * cosf(M_PI / 3 * 5);
            vector_y = vector * sinf(M_PI / 3 * 5);
        }
            break;
            
        default:
            break;
    }
    
    // 以弧線移動到定點
    CGPathAddCurveToPoint(path, NULL, item_center_x, item_center_y, item_center_x + curve_parabola_x, item_center_y + curve_parabola_y, item_center_x + vector_x, item_center_y + vector_y);
    
    // 開始動畫到並移動到定點
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    animation.delegate = self;
    [animation setPath:path];
    [animation setDuration:0.3];
    
    CFRelease(path);
    
    // 開始動畫到並移動到定點
    [self.layer addAnimation:animation forKey:@"parabola"];
    // 最後將 Item 的位置固定，不然會跳回原本的定點
    [self setFrame:CGRectOffset(self.frame, vector_x, vector_y)];
}

// 收縮結束之後通知 Menu 將 Menu 收縮
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self.delegate item_shrink_stopped:YES];
}


//- (CAAnimation*)pathAnimation
//{
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path,NULL,50.0,120.0);
//    
//    CGPathAddCurveToPoint(path,NULL,50.0,275.0, 150.0,275.0, 150.0,120.0);
//    CGPathAddCurveToPoint(path,NULL,150.0,275.0, 250.0,275.0, 250.0,120.0);
//    CGPathAddCurveToPoint(path,NULL,250.0,275.0, 350.0,275.0, 350.0,120.0);
//    CGPathAddCurveToPoint(path,NULL,350.0,275.0, 450.0,275.0, 450.0,120.0);
//    
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//    
//    [animation setPath:path];
//    [animation setDuration:1.0];
//    
//    [animation setAutoreverses:YES];
//    CFRelease(path);
//    
//    return animation;
//    
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
