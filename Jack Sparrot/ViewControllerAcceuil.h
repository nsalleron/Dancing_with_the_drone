//
//  ViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import <UIKit/UIKit.h>

@interface ViewControllerAccueil : UIViewController

@property (readonly,nonatomic,retain) UIButton *btnDrone;
@property (readonly,nonatomic,retain) UIButton *btnChore;
@property (readonly,nonatomic,retain) UIButton *btnOptions;

- (void) goToDroneControl:(UIButton*)send;

@end

