//
//  ViewController.h
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import <UIKit/UIKit.h>
#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>

@interface ViewControllerAccueil : UIViewController

@property (readonly,nonatomic,retain) UIButton *btnDrone;
@property (readonly,nonatomic,retain) UIButton *btnOptions;
@property (assign, nonatomic) NSInteger index;
@property (nonatomic, strong) ARService *service;


- (void) goToDroneControl:(UIButton*)send;

@end

