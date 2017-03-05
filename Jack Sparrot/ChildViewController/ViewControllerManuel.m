//
//  ChildViewController.m
//  Jack Sparrot
//
//  Created by Nicolas Salleron on 07/02/2017.
//
//

#import "ViewControllerManuel.h"
#import "ViewDimensionViewController.h"
#import "ViewManuel.h"

@interface ViewControllerManuel ()

@end
ViewManuel *ecran;

@implementation ViewControllerManuel



- (void)viewDidLoad {
    [super viewDidLoad];
    
    ecran = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecran setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setView: ecran];
    [self setTitle:@"Manuel"];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    NSLog(@"Passage shouldAutotoratote");
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate  // iOS 6 autorotation fix
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        NSLog(@"LANDSCAPE");
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    NSLog(@"PREFERRED");
    return UIInterfaceOrientationLandscapeRight;
}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecran updateView:size];
}

-(void) goToDimensionChoice:(UIButton*)send{
    
    ViewDimensionViewController *secondController = [[ViewDimensionViewController alloc] init];
    secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}

- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    [ecran updateBtn:item];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Up");
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Down");
}



@end
