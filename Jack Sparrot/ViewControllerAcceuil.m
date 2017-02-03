//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import "ViewControllerAcceuil.h"
#import "ViewEcranAccueil.h"
#import "ControlerDroneView/ViewControllerDrone.h"

@interface ViewControllerAccueil()

@end

ViewEcranAccueil *ecranAccueil;


@implementation ViewControllerAccueil

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ecranAccueil = [[ViewEcranAccueil alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAccueil setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
        //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setView: ecranAccueil];
    [self setTitle:@"Accueil"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [ecranAccueil updateView:size];
}

-(void) goToDroneControl:(UIButton*)send{

    ViewControllerDrone *secondController = [[ViewControllerDrone alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
}

-(void) goToDroneChorégraphie:(UIButton*)send{
    
}

-(void) goToDroneOptions:(UIButton*)send{
    
}


@end
