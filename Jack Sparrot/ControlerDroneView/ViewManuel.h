//
//  ViewDrone.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 02/02/2017.
//
//

#import <UIKit/UIKit.h>

@interface ViewManuel : UIView

@property (readonly,nonatomic,retain) UILabel *label;
@property (readwrite,nonatomic,retain) UIButton *btnDimensions;
@property (readonly,nonatomic,retain) UIButton *btnChangementMode;
@property (readonly,nonatomic,retain) UIButton *btnStatioDecoAttr;
@property (readonly,nonatomic,retain) UIButton *btnHome;



@property (assign, nonatomic) CGFloat tailleIcones;

- (void) updateView:(CGSize) format;
- (void) updateBtn:(NSString*) item;

@end
