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
#import "BebopDrone.h"
@interface ViewControllerManuel ()

@end


ViewManuel *ecran;
BOOL firstTime = TRUE;
BebopDrone * droneBebop;

double accX;
double accY;
double accZ;
double rotX;
double rotY;
double rotZ;

@implementation ViewControllerManuel


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Acceleration + Gyroscope */
    _currentMaxAccelX = 0;
    _currentMaxAccelY = 0;
    _currentMaxAccelZ = 0;
    
    _currentMaxRotX = 0;
    _currentMaxRotY = 0;
    _currentMaxRotZ = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    if(self.motionManager.isGyroAvailable && self.motionManager.isDeviceMotionAvailable){
        //Mise en place du gyroscope
        self.motionManager.gyroUpdateInterval = .2;
        //Mise en place du DeviceMotion
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
                                                withHandler:^(CMDeviceMotion *deviceData, NSError *error){
                                                    [self outputDeviceMotionData:deviceData.userAcceleration];
                                                    [self outputRotationData:deviceData.gravity];
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    }
                                                }];
        
        
        
        
    }
    /* Fin acceleration */
    
    
    _enStatio = FALSE;
    _enVol = FALSE;
    _axeX = TRUE;
    
    ecran = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecran setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [ecran setViewController:self];
    [ecran updateBtnStatioDecoAttr:@"Décollage"];
    [ecran updateBtnDimensions:@"1D"];
    [ecran updateBtnChangementMode:@"Axe X"];
    [self setView: ecran];
    [self setTitle:@"Manuel"];
    
    

    //Swipe UP DOWN
    UISwipeGestureRecognizer * swipeUp=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeUp:)];
    swipeUp.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:swipeUp];
    
    UISwipeGestureRecognizer * swipeDown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeDown:)];
    swipeDown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeDown];
    
    //Swipe Right et Left
    UISwipeGestureRecognizer * swipeRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeAxe:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRight];
    UISwipeGestureRecognizer * swipeLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(changeAxe:)];
    swipeRight.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    [NSTimer scheduledTimerWithTimeInterval:0.5
                                     target:self
                                   selector:@selector(sendToDrone)
                                   userInfo:nil
                                    repeats:YES];
    

    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) setDrone:(BebopDrone *) drone{
    droneBebop = drone;
}


- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enVol) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enVol = FALSE;
            _enStatio = FALSE;
            [droneBebop land];
            
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enVol = TRUE;
            _enStatio = TRUE;
            [droneBebop takeOff];
           
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];

    
}

- (void) changeAxe:(UIButton*)gesture{
    NSString *axe = @"Axe X";
    switch (_axeX) {
        case TRUE:
            //Axe Y
            NSLog(@"Axe Y");
            axe = @"Axe Y";
            _axeX = FALSE;
            break;
            
        case FALSE:
            //Axe X
            NSLog(@"Axe X");
            _axeX = TRUE;
        default:
            break;
    }
    [ecran updateBtnChangementMode:axe];
       
}

- (void) changeSatio:(UIButton*)send{
    if(firstTime){
        [self changeDecoAttr:NULL];
        firstTime = FALSE;
        return;
    }
        
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enStatio) {
        case TRUE:
            //Mode non stationnaire;
            NSLog(@"Mode stationnaire : OFF");
            _enStatio = FALSE;
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Mode stationnaire;
            NSLog(@"Mode Stationnaire : ON");
             _enStatio  = TRUE;
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];
}

-(void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture{
    
    ViewDimensionViewController *secondController = [[ViewDimensionViewController alloc] init];
    secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}


- (void) viewDidDisappear:(BOOL)animated{
   
}

/* Gestion des toucher long par le viewController */
- (void) quitView:(UILongPressGestureRecognizer*)gesture{

    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Fonction Home activée!");
    }
}



-(void) changeStatio:(UIButton*)send{
    switch (_enStatio) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enStatio = FALSE;
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enStatio = TRUE;
        default:
            break;
    }
}


- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    
    [ecran updateBtnDimensions:item];
    if([item  isEqual: @"1D"])
        [ecran updateView:[[UIScreen mainScreen] bounds].size];
    else
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    
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

/* Rotation de l'écran */

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}
- (BOOL)shouldAutorotate{
    return YES;
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations // iOS 6 autorotation fix
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskLandscapeRight;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation // iOS 6 autorotation fix
{
    return UIInterfaceOrientationLandscapeRight;
}
-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [ecran updateView:size];
}

/*
 *  @param acceleration : Acceleration en m/s^2 retourné par le téléphone.
 *
 */
-(void) outputDeviceMotionData:(CMAcceleration) acceleration{
    
    double const kThreshold = 0.05;
    
    [ecran updateBtnDimensions:[[NSString alloc] initWithFormat:@"X : %.2f\t Y : %.2f\t Z : %.2f",
                                    acceleration.x,acceleration.y,acceleration.z]];
    //[ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"%2fg",acceleration.x]];
    if(acceleration.x < kThreshold * -1){ // -0.3 < -0.2
        //[ecran updateBtnDimensions:@"----"];
        _currentMaxAccelX = acceleration.x;
        //[ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX - : %2fm/s",_currentMaxAccelX]];
        NSLog(@"----");
    }else if(acceleration.x > kThreshold){ // 0.3 > 0.2
        NSLog(@"++++");
        _currentMaxAccelX = acceleration.x;
        //[ecran updateBtnDimensions:@"++++"];
        //[ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX + : %2fm/s",_currentMaxAccelX]];
    }else{
        //[ecran updateBtnDimensions:@"============="];
        _currentMaxAccelX = 0;
    }
    
    if(acceleration.y < kThreshold * -1){ // -0.3 < -0.2
        //[ecran updateBtnDimensions:@"----"];
        _currentMaxAccelY = acceleration.y;
        //[ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX - : %2fm/s",_currentMaxAccelX]];
        NSLog(@"----");
    }else if(acceleration.y > kThreshold){ // 0.3 > 0.2
        NSLog(@"++++");
        _currentMaxAccelY = acceleration.y;
        //[ecran updateBtnDimensions:@"++++"];
        //[ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX + : %2fm/s",_currentMaxAccelX]];
    }else{
        //[ecran updateBtnDimensions:@"============="];
        _currentMaxAccelY = 0;
    }
    
    if(acceleration.z < kThreshold * -1){ // -0.3 < -0.2
        //[ecran updateBtnDimensions:@"----"];
        _currentMaxAccelZ = acceleration.z;
        //[ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX - : %2fm/s",_currentMaxAccelX]];
        NSLog(@"----");
    }else if(acceleration.z > kThreshold){ // 0.3 > 0.2
        NSLog(@"++++");
        _currentMaxAccelZ = acceleration.z;
        //[ecran updateBtnDimensions:@"++++"];
        //[ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"MAX + : %2fm/s",_currentMaxAccelX]];
    }else{
        //[ecran updateBtnDimensions:@"============="];
        _currentMaxAccelZ = 0;
    }
}
//-(void)outputRotationData:(CMRotationRate)rotation
-(void)outputRotationData:(CMAcceleration)rotation
{
    double rotationXY = atan2(rotation.x, rotation.y) - M_PI;
    double rotationYZ = atan2(rotation.y, rotation.z) - M_PI;
    double rotationZX = atan2(rotation.z, rotation.x) - M_PI;
    
    [ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"X : %.2f\tY : %.2f\tZ : %.2f",rotationXY,rotationYZ,rotationZX
                                    ]];
    //[ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"X : %.2f\t Y : %.2f\t Z : %.2f",
                                //    rotation.x,rotation.y,rotation.z]];
    rotX = rotation.x;
    rotY = rotation.y;
    rotZ = rotation.z;
    
}

-(void)sendToDrone{
    
    
    /* Si le drone est en vol et n'est pas en mode stationnaire */
    if(droneBebop != nil && _enVol && !_enStatio){
        //On balance les ordres
        if(![ecran.btnChangementMode isHidden]){
            if([[ecran.btnChangementMode.titleLabel text] isEqualToString:@"Axe X"]){
                if(_currentMaxAccelX != 0){
                    [droneBebop setFlag:0];
                    [droneBebop setPitch:50];   //Le coefficient doit être appliqué
                }
                
            }else{
                if(_currentMaxAccelY != 0){
                    [droneBebop setFlag:1];
                    [droneBebop setPitch:50];   //Le coefficient doit être appliqué
                }
            }
            //Mode X ou Y
        } else if(![[ecran.btnDimensions.titleLabel text] isEqualToString:@"2D"]){
            //Mode X ET Y
        } else if(![[ecran.btnDimensions.titleLabel text] isEqualToString:@"3D"]){
            //Mode X ET Y ET Z
        }
    }else{
        //Nothing?
    }
}



@end
