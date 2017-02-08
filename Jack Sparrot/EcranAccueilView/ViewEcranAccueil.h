//
//  EcranAccueil.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#ifndef EcranAccueil_h
#define EcranAccueil_h
#import <UIKit/UIKit.h>


@interface ViewEcranAccueil : UIView

@property (readonly,nonatomic,retain) UIImageView *imgLogo;
@property (readonly,nonatomic,retain) UIButton *btnDrone;
@property (readonly,nonatomic,retain) UIButton *btnChore;
@property (readonly,nonatomic,retain) UIButton *btnOptions;
@property (readonly,nonatomic,retain) UILabel *labelBatteryDrone;
@property (readonly,nonatomic,retain) UILabel *labelBatterySmartphone;
@property (readonly,nonatomic,retain) UILabel *labelVersionApp;
@property (nonatomic, assign) CGFloat tailleIcones;

- (void) updateView:(CGSize) format;

- (void) setNavigationController:(UINavigationController*) nv;

@end

#endif
