//
//  UIView+Attributes.h
//  InloveLost
//
//  Created by daihz on 2018/7/31.
//  Copyright © 2018年 make1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Attributes)

/**  起点x坐标  */
@property (nonatomic, assign) CGFloat x;
/**  起点y坐标  */
@property (nonatomic, assign) CGFloat y;
/**  中心点x坐标  */
@property (nonatomic, assign) CGFloat centerX;
/**  中心点y坐标  */
@property (nonatomic, assign) CGFloat centerY;
/**  宽度  */
@property (nonatomic, assign) CGFloat width;
/**  高度  */
@property (nonatomic, assign) CGFloat height;
/**  顶部  */
@property (nonatomic, assign) CGFloat top;
/**  底部  */
@property (nonatomic, assign) CGFloat bottom;
/**  左边  */
@property (nonatomic, assign) CGFloat left;
/**  右边  */
@property (nonatomic, assign) CGFloat right;
/**  size  */
@property (nonatomic, assign) CGSize size;
/**  origin */
@property (nonatomic, assign) CGPoint origin;

@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;

@property(nonatomic,assign) IBInspectable CGFloat borderWidth;

@end
