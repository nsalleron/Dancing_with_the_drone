//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//


#import "ViewControllerOptions.h"
#import "ViewOptions.h"
#import "ViewCouleursController.h"


@interface ViewControllerOptions ()
@end

//UIView *ecranOptions;
ViewOptions *ecranOptions;

@implementation ViewControllerOptions

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    ecranOptions = [[ViewOptions alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranOptions setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView:ecranOptions];
    [[self navigationController] setNavigationBarHidden:NO];
    [self setTitle:@"Options"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) goToColorChoice:(UIButton*)send{
    
    ViewCouleursController *secondController = [[ViewCouleursController alloc] init];
    //secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}


//ROTATION

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    return UIInterfaceOrientationMaskAll;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationPortrait;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecranOptions updateView:size];
}

/*
-(void) modeInOut:(UISwitch*) _swhInOut {
    if (_swhInOut.isset) {
        NSLog(@"bonjour");
    }else{
        NSLog(@"Au revoir");
    }
}
*/

@end
