//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 31/01/2017.
//
//

#import "ViewControllerAcceuil.h"
#import "ViewControllerManuel.h"
#import "ViewDimensionViewController.h"
#import "ViewEcranAccueil.h"


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

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

-(void) goToDroneControl:(UIButton*)send{

    ViewControllerManuel *secondController = [[ViewControllerManuel alloc] init];
    [self.navigationController pushViewController:secondController animated:YES];
}

-(void) goToDroneOptions:(UIButton*)send{
    
}


@end
