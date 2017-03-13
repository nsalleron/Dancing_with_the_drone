//
//  ViewDimension.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 28/02/2017.
//
//

#import <UIKit/UIKit.h>

@interface ViewDimension : UIView


@property (readonly,nonatomic,retain) UIButton *btn1D;
@property (readonly,nonatomic,retain) UIButton *btn2D;
@property (readonly,nonatomic,retain) UIButton *btn3D;
@property (readwrite,nonatomic,retain) UIColor *color1D;
@property (readwrite,nonatomic,retain) UIColor *color2D;
@property (readwrite,nonatomic,retain) UIColor *color3D;
- (void) updateView:(CGSize) format;

@end
