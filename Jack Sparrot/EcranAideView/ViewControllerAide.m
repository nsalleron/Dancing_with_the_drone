//
//  ViewController.m
//  Jack Sparrot
//
//  Created by Gregoire Gasc on 07/03/2017.
//
//


#import "ViewControllerAide.h"
#import "ViewAide.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

@interface ViewControllerAide ()
@end

ViewAide *ecranAide;


@implementation ViewControllerAide

- (void)viewDidLoad {
    [super viewDidLoad];
    ecranAide = [[ViewAide alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecranAide setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [self setView:ecranAide];
    [[self navigationController] setNavigationBarHidden:NO];
    [self setTitle:@"Aide"];

}

- (void) launchVideo:(UIButton*)send{
    
    NSURL *path;
    
    if([send.titleLabel.text isEqualToString:@"Changement des axes"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoChangementAxes" ofType:@"mov"]];
    }else if([send.titleLabel.text isEqualToString:@"Changement de mode"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoChangementMode" ofType:@"mov"]];
    }else if([send.titleLabel.text isEqualToString:@"Changement de couleurs"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoChangementCouleur" ofType:@"mov"]];
    }else if([send.titleLabel.text isEqualToString:@"Retour Accueil"]){
        path = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"demoRetourAccueil" ofType:@"mov"]];
    }
    
    AVPlayer *player = [AVPlayer playerWithURL:path];
    AVPlayerViewController *playerViewController = [AVPlayerViewController new];
    playerViewController.player = player;
    [playerViewController.player play];
    [self.navigationController pushViewController:playerViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    
    [ecranAide updateView:size];
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

- (BOOL)prefersStatusBarHidden {
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


@end
