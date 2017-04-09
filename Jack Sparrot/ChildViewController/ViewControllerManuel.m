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
#import "DroneDiscoverer.h"
#import <CoreMotion/CoreMotion.h>
#import <libARDiscovery/ARDiscovery.h>

#define frequenceMAJ = (1.f/30.f)
#define kFilteringFactor 0.1
#define DFMotionMonitorInterval   0.1f
#define DFGravityAcceleration       0.98f
@interface ViewControllerManuel ()<BebopDroneDelegate,DroneDiscovererDelegate,ViewDimensionViewControllerDelegate,UIAccelerometerDelegate>
@property (nonatomic, strong) UIAlertView *connectionAlertView;
@property (nonatomic, strong) BebopDrone *bebopDrone;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) DroneDiscoverer *droneDiscoverer;
@property (nonatomic) dispatch_semaphore_t stateSem;
@property (atomic, strong) NSMutableArray *arrayFloat;
@property (nonatomic) bool bExterieur;
@end


ViewManuel *ecran;
BOOL firstTime = TRUE;
int currentDimensions = 0;

double currentX = 0;
double currentY = 0;
double currentZ = 0;
double threshAccelerometer = 4.00f;
boolean bFinMouvementX = true, bFinMouvementY = true;

//  some behavior and view constants.
const static float GRAVITY_SCALE    = 9.81f;
const static float FRAME_RATE       = 60.0f;
const static float tiltSensitivity  = 0.02f;
const static float nearlyVertical   = 0.9;

int nbCount = 0;

float gyroX, gyroY, gyroZ, accelX, gravityX;
int pitchFinal, rollFinal;
float x;
int i;
float moyenneX;
boolean bFirstTimeX = true;
float previous_accel;
float resultX, resultY;

float xVelocity, yVelocity, zVelocity;
float xPosition, yPosition, zPosition;

#define MAX 10
float values[MAX];
NSString *strong;
float somme;
int GaucheOuDroite;
boolean stop;
boolean bFirstTime;
lineYPlus = 0;
lineYMoins = 0;
NSDate *dateMouvement;
NSThread *mythread;
boolean isRecord;
#define THRESH 1



double vx;  //X轴速度
double vy;  //Y轴速度
double vz;  //Z轴速度

double v_max;   //最大速度
double v_real;  //当前实际速度
double move_distance;   //总移动路程

int intervalTimes;  //获取数据次数

CMAttitude *refAttitude; //第一次获取的手机摆放方式，用来作参考坐标系

NSTimer *timer;

double ax;
double ay;
double az;


@implementation ViewControllerManuel
-(void)isolateHorizontalMotionFromMotionData:(CMDeviceMotion *)data

{
    
    //Matrice de rotation
    
    CMRotationMatrix matriceRotation = data.attitude.rotationMatrix;
    
    
    
    double vectAccelX = data.userAcceleration.x;
    
    double vectAccelY = data.userAcceleration.y;
    
    double vectAccelZ = data.userAcceleration.z;
    
    
    
    
    
    //Multiplication de la matrice a l'arrache
    
    double accelerationFinX = (matriceRotation.m11 * vectAccelX)+ (matriceRotation.m21 * vectAccelY)+ (matriceRotation.m31 * vectAccelZ) ;

    double accelerationFinY = (matriceRotation.m12*vectAccelX)+ (matriceRotation.m22 * vectAccelY)+ (matriceRotation.m32 * vectAccelZ) ;
    
    double accelerationFinZ = (matriceRotation.m13*vectAccelX)+ (matriceRotation.m23 * vectAccelY)+ (matriceRotation.m33 * vectAccelZ) ;
    
    //acceleration horizontale
    float horizontalAcceleration = sqrtf(powf(accelerationFinX,2)+powf(accelerationFinY,2));
    [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"horizontal : %0.2f",horizontalAcceleration]  ];
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*Récupération mode intérieur extérieur */
    _bExterieur = ![[NSUserDefaults standardUserDefaults] objectForKey:@"InOut"];
   
    //[_bebopDrone setInterieurExterieur:_bExterieur];
    
    /*DRONE*/
    if(_bebopDrone == nil) {
        _dataSource = [NSArray array];
        _droneDiscoverer = [[DroneDiscoverer alloc] init];
        [_droneDiscoverer setDelegate:self];
    }

    
    /* Acceleration + Gyroscope */
    self.motionManager = [[CMMotionManager alloc] init];
    _arrayFloat = [[NSMutableArray alloc] init];
    
    
    
    
    
    if(self.motionManager.isDeviceMotionAvailable){
        
        
        if (self.motionManager.deviceMotionAvailable) {

            
            
            //self.motionManager.deviceMotionUpdateInterval = 0.2f;
            self.motionManager.deviceMotionUpdateInterval = 0.5;
            [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                  withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
                      
                      return;
                      
                      
                      //[self isolateHorizontalMotionFromMotionData:data];
                      CMDeviceMotion *data;
                      
                      [ecran updateBtnDimensions:[[NSString alloc] initWithFormat:@"%0.2f",data.userAcceleration.x]];
                      
                      if (isRecord) {
                          
                          NSNumber *num = [NSNumber numberWithFloat:data.userAcceleration.x];
                          @synchronized (_arrayFloat) {
                                [_arrayFloat addObject:num];
                          }
                          return;
                      }
                      
                      if(data.userAcceleration.x > THRESH){
                          isRecord = true;
                          [ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"%0.2f",data.userAcceleration.x]];
                          //Enregistrement du mouvement + Démarrage du thread
                          NSNumber *num = [NSNumber numberWithFloat:data.userAcceleration.x];
                          [_arrayFloat addObject:num];
                          [ecran updateBtnChangementMode:@"MOUVEMENT"];
                          dateMouvement = [NSDate date];
                          
                          
                          mythread = [[NSThread alloc] initWithBlock:^(void){
                              while (true) {
                                  
                                  if(_bebopDrone == nil || !_enVol || _enStatio) break;
                                
                                  [_bebopDrone setFlag:1];
                                  [_bebopDrone setPitch:-20];
                                 
                                      
                                  float somme = 0;
                                  int i;
                                  @synchronized (_arrayFloat) {
                                      for (i = 0; i<[_arrayFloat count]; i++) {
                                          NSNumber *tmp = [_arrayFloat objectAtIndex:i];
                                          somme += [tmp floatValue];
                                          
                                      }
                                  }
                                  
                                  somme = somme / [_arrayFloat count];
                                  [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"%0.2f : i : %d",somme,i]];
                                  if( -0.05 < somme && somme < 0.05){
                                      [ecran updateBtnHome:[[NSString alloc ] initWithFormat:@" time : %0.2f",[[NSDate date] timeIntervalSinceDate: dateMouvement] ]];
                                      if([[NSDate date] timeIntervalSinceDate: dateMouvement] > 0.5){
                                          break;
                                      }
                                      
                                  }
                                  if([[NSDate date] timeIntervalSinceDate: dateMouvement] > 2){ //Trop long
                                      break;
                                  }
                              }
                              //CMQuaternion qua = data.attitude.quaternion;
                              isRecord = false;
                              _arrayFloat = [[NSMutableArray alloc] init]; // RAZ du tableau
                              [_bebopDrone setFlag:0];
                              [_bebopDrone setPitch:0];
                              [ecran updateBtnChangementMode:@"FIN MOUVEMENT +"];
                              
                              
                          }];
                          [mythread start];
                      }
                      
                      if(data.userAcceleration.x < -THRESH){
                          isRecord = true;
                          [ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"%0.2f",data.userAcceleration.x]];
                          //Enregistrement du mouvement + Démarrage du thread
                          NSNumber *num = [NSNumber numberWithFloat:data.userAcceleration.x];
                          [_arrayFloat addObject:num];
                          [ecran updateBtnChangementMode:@"MOUVEMENT"];
                          dateMouvement = [NSDate date];
                          
                          
                          
                          mythread = [[NSThread alloc] initWithBlock:^(void){
                              while (true) {
                                  
                                  if(_bebopDrone == nil || !_enVol || _enStatio) break;
                                  
                                  [_bebopDrone setFlag:1];
                                  [_bebopDrone setPitch:20];
                                  
                                  float somme = 0;
                                  int i;
                                  
                                  @synchronized (_arrayFloat) {
                                      for (i = 0; i<[_arrayFloat count]; i++) {
                                          NSNumber *tmp = [_arrayFloat objectAtIndex:i];
                                          somme += [tmp floatValue];
                                          
                                      }
                                  }
                                  
                                  
                                  somme = somme / [_arrayFloat count];
                                  [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"%0.2f : i : %d",somme,i]];
                                   if( -0.05 < somme && somme < 0.05){
                                           [ecran updateBtnHome:[[NSString alloc ] initWithFormat:@" time : %0.2f",[[NSDate date] timeIntervalSinceDate: dateMouvement] ]];
                                       if([[NSDate date] timeIntervalSinceDate: dateMouvement] > 0.5){
                                           break;
                                       }
                                  }
                                  if([[NSDate date] timeIntervalSinceDate: dateMouvement] > 2){ //Trop long
                                      break;
                                  }
                              }
                              //CMQuaternion qua = data.attitude.quaternion;
                              isRecord = false;
                              _arrayFloat = [[NSMutableArray alloc] init]; // RAZ du tableau
                              [_bebopDrone setFlag:0];
                              [_bebopDrone setPitch:0];
                              [ecran updateBtnChangementMode:@"FIN MOUVEMENT - "];
                              
                              
                          }];
                          [mythread start];
                      }
                      
                      //Au cas ou
                      
                      [_bebopDrone setFlag:0];
                      [_bebopDrone setPitch:0];
                      
                      
                      return;
                      
                      //NSThread *mythread = [[NSThread alloc] initWithTarget:target selector:selector object:argument];
                      float timeInterval = [[NSDate date] timeIntervalSinceDate:dateMouvement];
                      
                      //NSLog(@"Y value is: %f", data.userAcceleration.y);
                      if (data.userAcceleration.y > 0.05) {
                          //a solid move forward starts
                          lineYPlus++; //increment a line length value
                          [ecran updateBtnDimensions:@"Moving... Plus"];
                          dateMouvement = [NSDate date];
                      }
                      if (data.userAcceleration.y < -0.05){
                          lineYMoins++; //increment a line length value
                          [ecran updateBtnDimensions:@"Moving... Moins"];
                          dateMouvement = [NSDate date];
                      }
                      if (data.userAcceleration.y < -0.02 && lineYPlus > 10) {
                          /*user has abruptly slowed indicating end of the move forward.
                           * we also make sure we have more than 10 events
                           */
                          [ecran updateBtnDimensions:@"STOP ! Plus "];
                          lineYPlus = 0;
                          //lineYMoins = 0;
                          dateMouvement = [NSDate date];
                          //[self.motionManager stopDeviceMotionUpdates];
                      }
                      if (data.userAcceleration.y > 0.02 && lineYMoins > 10) {
                          /*user has abruptly slowed indicating end of the move forward.
                           * we also make sure we have more than 10 events
                        */
                          [ecran updateBtnDimensions:@"STOP ! Moins"];
                          lineYMoins = 0;
                          //lineYPlus = 0;
                          dateMouvement = [NSDate date];
                          //[self.motionManager stopDeviceMotionUpdates];
                      }
                      if (data.userAcceleration.y > -0.02 && data.userAcceleration.y < 0.02 && timeInterval >= 0.5 ){
                          [ecran updateBtnDimensions:@"STOP !"];
                          lineYMoins = 0;
                          lineYPlus = 0;
                      }
                      
                      
                      
                      return;
                      
                      
                      
                      for (int i = 0; i < MAX ; i++) {
                          if(i == MAX-1){
                              values[MAX - 1] = data.userAcceleration.x;
                              break;
                          }
                          values[i] = values[i+1];
                      }
                      
                      strong = [[NSString alloc] init];
                     
                      
                      for (int i = 0; i < MAX ; i++) {
                          strong = [[NSString alloc] initWithFormat:@"%@ | %0.2f",strong,values[i]];
                      }
                      [ecran updateBtnDimensions:strong];
                    
                    
                      somme = 0;
                      for (int i = 0; i<MAX; i++) {
                          somme+=values[i];
                      }
                      somme = somme / MAX;
                      somme *= 10;
                     
                       [ecran updateBtnStatioDecoAttr:[[NSString alloc] initWithFormat:@"%0.2f",somme]];
                      
                      
                      if(   (somme > 0.1 && stop == true ) ){
                          [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"DROITE"]];
                          GaucheOuDroite = 1;
                         
                      }
                      if(   (somme <-0.1 && stop == true )){
                          [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"GAUCHE"]];
                          GaucheOuDroite = -1;
                          
                      }
                      if(somme > -0.1 && somme < 0.1){
                          [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"STOP"]];
                          stop = true;
                          GaucheOuDroite = 0;
                      }
                          
                   
                      
                      
                    return;
                      
                  
                    moyenneX = data.userAcceleration.x;
                  
                      if (moyenneX < -0.5f  ) {
                          if(!bFirstTimeX){
                                [ecran updateBtnDimensions:[[NSString alloc ] initWithFormat:@"GAUCHE %0.2f",moyenneX]];
                                bFirstTimeX = true;
                          }else{
                                bFirstTimeX = false;
                          }
                     }
                     if (moyenneX > 0.5f)  {
                          if(!bFirstTimeX){
                                [ecran updateBtnDimensions:[[NSString alloc ] initWithFormat:@"DROITE %0.2f",moyenneX]];
                                bFirstTimeX = true;
                            }else{
                                bFirstTimeX = false;
                            }
                                                                
                        }
                        if (moyenneX > -0.03f && moyenneX < 0.03f && bFinMouvementX == true ){
                            [ecran updateBtnDimensions:[[NSString alloc ] initWithFormat:@"STOP %0.2f",moyenneX]];
                        }
                      moyenneX = 0;
                  
                  }];
        }
    }
    
    
    self.motionManager = [CMMotionManager new];
    [self.motionManager setAccelerometerUpdateInterval:1];
    
    if (self.motionManager.deviceMotionAvailable) {
        
        /*
        
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
           
            CMAcceleration accel = [self userAccelerationInReferenceAttitude:motion.attitude];
            [ecran updateBtnDimensions:[[NSString alloc ] initWithFormat:@"X : %0.2f ",accel.x]];
            
           
        }];
         
         */
    }
    /*
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *data, NSError *error){
            //[self movement:data.acceleration];
        
        CMAcceleration accel = data.acceleration;
        
        [ecran updateBtnChangementMode:[[NSString alloc ] initWithFormat:@"accel.x : %0.2f accel.y: %0.2f accel.z : %0.2f",accel.x,accel.y,accel.z]];
        
        resultX = accel.x + sinf(gyroY) - sinf(gyroX);
        resultY = accel.y + sinf(gyroY);
        
        [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"X : %0.2f, Y : %0.2f",resultX, resultY]];
        
    
        
        
        return;
        
        
        
        
        
        
        
        
        
            float x = data.acceleration.x;
            float y = data.acceleration.y;
            float angle = atan2(y, x);
            
            if(angle >= -2.25 && angle <= -0.75) {
                [ecran updateBtnStatioDecoAttr:[self stringFromOrientation:UIInterfaceOrientationPortrait]];
            } else if(angle >= -0.75 && angle <= 0.75){
               [ecran updateBtnStatioDecoAttr:[self stringFromOrientation:UIInterfaceOrientationLandscapeRight]];
            } else if(angle >= 0.75 && angle <= 2.25) {
                [ecran updateBtnStatioDecoAttr:[self stringFromOrientation:UIInterfaceOrientationPortraitUpsideDown]];
            } else if(angle <= -2.25 || angle >= 2.25) {
                [ecran updateBtnStatioDecoAttr:[self stringFromOrientation:UIInterfaceOrientationLandscapeLeft]];
            }

            [ecran updateBtnHome:[[NSString alloc] initWithFormat:@"%0.2f",angle ]];
            
            
            
            if (error) {
                NSLog(@"%@", error);
            }
        }];
        
    //}
    /* Fin acceleration */
    toto :
    
    _enStatio = FALSE;
    _enVol = FALSE;
    _axeX = TRUE;
    
    ecran = [[ViewManuel alloc ] initWithFrame:[[UIScreen mainScreen] bounds]];
    [ecran setBackgroundColor:[UIColor colorWithRed:250.0/255 green:246.0/255 blue:244.0/255 alpha:1.0]];
    [ecran setViewController:self];
    [ecran updateBtnStatioDecoAttr:@"Décollage"];
    [ecran updateBtnDimensions:@"1D"];
    currentDimensions = 1;
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
    
    /*[NSTimer scheduledTimerWithTimeInterval:0.1
                                     target:self
                                   selector:@selector(sendToDrone)
                                   userInfo:nil
                                    repeats:YES];*/
    

    
}


- (NSString *)stringFromOrientation:(UIDeviceOrientation) orientation {
    
    NSString *orientationString;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            orientationString =  @"Portrait";
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientationString =  @"Portrait Upside Down";
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationString =  @"Landscape Left";
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationString =  @"Landscape Right";
            break;
        case UIDeviceOrientationFaceUp:
            orientationString =  @"Face Up";
            break;
        case UIDeviceOrientationFaceDown:
            orientationString =  @"Face Down";
            break;
        case UIDeviceOrientationUnknown:
            orientationString = @"Unknown";
            break;
        default:
            orientationString = @"Not Known";
            break;
    }
    return orientationString;
}



- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) changeDecoAttr:(UILongPressGestureRecognizer*)gesture{
    NSString *statio = @"Mode Stationnaire : ON";
    switch (_enVol) {
        case TRUE:
            //Atterrissage;
            NSLog(@"Atterrissage");
            _enVol = FALSE;
            _enStatio = FALSE;
            [_bebopDrone land];
            
            statio = @"Mode Stationnaire : OFF";
            break;
            
        case FALSE:
            //Decollage;
            NSLog(@"Decollage");
            _enVol = TRUE;
            _enStatio = TRUE;
            [_bebopDrone takeOff];
           
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
            [_bebopDrone setFlag:0];
            [_bebopDrone setPitch:0];
            _axeX = FALSE;
            break;
            
        case FALSE:
            //Axe X
            NSLog(@"Axe X");
            [_bebopDrone setFlag:0];
            [_bebopDrone setRoll:0];
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
            [_bebopDrone setFlag:0];
            [_bebopDrone setRoll:0];
            [_bebopDrone setPitch:0];
            break;
        default:
            break;
    }
    [ecran updateBtnStatioDecoAttr:statio];
}

-(void) goToDimensionChoice:(UILongPressGestureRecognizer*)gesture{
    
    /* On met le drone en mode stationnaire */
    [_bebopDrone setFlag:0];
    [_bebopDrone setRoll:0];
    [_bebopDrone setPitch:0];
    
    ViewDimensionViewController *secondController = [[ViewDimensionViewController alloc] init];
    secondController.delegate = self;
    [self.navigationController pushViewController:secondController animated:YES];
    
}


/* Gestion des toucher long par le viewController */
- (void) quitView:(UILongPressGestureRecognizer*)gesture{

    if(_service == nil){
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [self unregisterNotifications];
    [_droneDiscoverer stopDiscovering];
    
    [self deconnexionDrone];
    
    
    
}


- (void) homeFunction:(UILongPressGestureRecognizer*)gesture{
    if ( gesture.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Fonction Home activée! bExterieur = %d",_bExterieur);
        if(_bExterieur){
            [_bebopDrone returnHomeExterieur];
        }else{
            [_bebopDrone returnHomeInterieur];
        }
        
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

/* Changement de dimensions et redimensionnement des écrans */

- (void)addItemViewController:(ViewDimensionViewController *)controller didFinishEnteringItem:(NSString *)item
{
    
    [ecran updateBtnDimensions:item];
    if([item  isEqual: @"1D"]){
        [ecran updateView:[[UIScreen mainScreen] bounds].size];
        currentDimensions = 1;
    }else if([item  isEqual: @"2D"]){
        currentDimensions = 2;
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    }else if([item  isEqual: @"3D"]){
        currentDimensions = 3;
        [ecran update2D3D:[[UIScreen mainScreen] bounds].size];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)swipeUp:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Up");
    if(_bebopDrone == nil || !_enVol || _enStatio) return;
    
    // in background, disconnect from the drone
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bebopDrone setGaz:100];
        NSLog(@"GAZ UP");
        [NSThread sleepForTimeInterval:0.5f];
        NSLog(@"GAZ DOWN");
        [_bebopDrone setGaz:0];
    });
    
    
    
}

-(void)swipeDown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    NSLog(@"Down");
    if(_bebopDrone == nil || !_enVol || _enStatio) return;
    
    // in background, disconnect from the drone
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_bebopDrone setGaz:-100];
        NSLog(@"GAZ UP");
        [NSThread sleepForTimeInterval:0.5f];
        NSLog(@"GAZ DOWN");
        [_bebopDrone setGaz:0];
    });
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

-(void)movement:(CMAcceleration)data {
    
    /*
    if(_bebopDrone != nil){
        [_bebopDrone setYaw:-100];
        [ecran updateBtnChangementMode:[[NSString alloc] initWithFormat:@"NB : %d",i]];
        i++;
    }
    
    
    return;
    */
    
    //  get current frame location:
    float x = data.x;
    float y = data.y;
    float z = data.z;
    
    float newY = 0;
    float newX = 0;
    float newZ = 0;
    
    //left and right tilt
    if (ABS(x) >= tiltSensitivity) {
        newX = x * GRAVITY_SCALE;
    }
    
    //up and down tilt
    if (ABS(y) >= tiltSensitivity) {
        newY = y * -GRAVITY_SCALE;
    }
    
    if (ABS(z) >= tiltSensitivity) {
        newZ = (z * GRAVITY_SCALE) + GRAVITY_SCALE;
    }
    
    //if(_bebopDrone == nil || !_enVol || _enStatio) return;
    
    /* à partir d'ici on traite les mouvements */
    if(newX < -threshAccelerometer || threshAccelerometer < newX){
        currentX = newX;
    }
    if(newY < -threshAccelerometer || threshAccelerometer < newY){
        currentY = newY;
    }
    if( -threshAccelerometer < newX && newX < threshAccelerometer ){
        currentX = 0;
    }
    if( -threshAccelerometer < newY && newY < threshAccelerometer ){
        currentY = 0;
    }
    
    
    double result = cos(gyroX) * x;
    
    [ecran updateBtnDimensions:[[NSString alloc] initWithFormat:@"COS %0.2f X BRUT : %0.2f X : %0.2f",gyroZ,x,result]];
    

    /* Début algo vitesse
     *  (X * vitesseMax/AccelerationMAX)
     */
    
    int vitesseXFinal = (currentX*10);
    if (vitesseXFinal > 90) {
        vitesseXFinal = 90;
    }else if (vitesseXFinal < -90){
        vitesseXFinal = -90;
    }
    if(vitesseXFinal > 1)
        vitesseXFinal = vitesseXFinal - 40;
    else if (vitesseXFinal < -1)
        vitesseXFinal = vitesseXFinal + 40;
    
    /* Début algo vitesse
     *  (X * vitesseMax/AccelerationMAX)
     */
    
    int vitesseYFinal = (currentY*10);
    if (vitesseYFinal > 90) {
        vitesseYFinal = 90;
    }else if (vitesseYFinal < -90){
        vitesseYFinal = -90;
    }
    if(vitesseYFinal > 1)
        vitesseYFinal = vitesseYFinal - 40;
    else if (vitesseYFinal < -1)
        vitesseYFinal = vitesseYFinal + 40;
    
    //[ecran updateBtnDimensions:[[NSString alloc] initWithFormat:@"vitesseFinale X : %d, Y : %d",vitesseXFinal,vitesseYFinal]];
   // [ecran updateBtnDimensions:[[NSString alloc] initWithFormat:@"tresh X : %.2f, Y : %.2f",currentX,currentY]];
    
    /* Dans le cas 1D : On s'occupe de X et Y séparément*/
    
    
    if(currentDimensions == 1){
        
        NSString *label = [[[ecran btnChangementMode] titleLabel ] text];
        
        
        if(_axeX){
            /*
            if(currentX < - threshAccelerometer || currentX > threshAccelerometer ){
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:vitesseXFinal]; // Si non fonctionnel remplacer par -50
            }
            
            if(currentX == 0 ){
                [_bebopDrone setFlag:0];
                [_bebopDrone setPitch:0];
            }
             */
            
            if(currentX < - threshAccelerometer || currentX > threshAccelerometer ){
                [_bebopDrone setFlag:1];
                [_bebopDrone setPitch:pitchFinal];
            }
            
            if(currentX == 0 ){
                [_bebopDrone setFlag:0];
                [_bebopDrone setPitch:0];
            }
            
        }else{
            /*if(currentY < -threshAccelerometer || currentY > threshAccelerometer){
                
                [_bebopDrone setFlag:1];
                [_bebopDrone setRoll:vitesseYFinal]; // -50
                
            }
            
            if(currentY == 0){
                [_bebopDrone setFlag:0];
                [_bebopDrone setRoll:0];
            }
             */
            
            [_bebopDrone setFlag:1];
            [_bebopDrone setRoll:vitesseYFinal]; // -50
            
        }
            
            if(currentY == 0){
                [_bebopDrone setFlag:0];
                [_bebopDrone setRoll:0];
            
        }
        
    /* Dans le cas 2D et 3D : On s'occupe de X et Y ensemble */
    }else if(currentDimensions == 2 || currentDimensions == 3){
        pitchFinal = (vitesseXFinal*(cos(gyroZ)*100) + vitesseYFinal*(sin(gyroZ)*100));
        rollFinal = (vitesseXFinal*(sin(gyroZ)*100) + vitesseYFinal*(cos(gyroZ)*100));
        pitchFinal /= 100;
        rollFinal /= 100;
        
                     
        /*if(currentX == 0 && currentY == 0){
            [_bebopDrone setFlag:0];
            [_bebopDrone setRoll:0];
            [_bebopDrone setPitch:0];
            return;
        }
        
        [_bebopDrone setFlag:1];
        if(currentX == 0){
            [_bebopDrone setPitch:0];
        }else{
            [_bebopDrone setPitch:vitesseXFinal];
        }
        if(currentY == 0){
            [_bebopDrone setRoll:0];
        }else{
            [_bebopDrone setRoll:vitesseYFinal];
        }
         */
        if(currentX == 0 && currentY == 0){
            [_bebopDrone setFlag:0];
            [_bebopDrone setRoll:0];
            [_bebopDrone setPitch:0];
            return;
        }
        [_bebopDrone setFlag:1];
        if(currentX == 0){
            [_bebopDrone setPitch:0];
        }else{
            [_bebopDrone setPitch:pitchFinal];
        }
        if(currentY == 0){
            [_bebopDrone setRoll:0];
        }else{
            [_bebopDrone setRoll:rollFinal];
        }
    }
        
    //[ecran updateBtnDimensions:[NSString stringWithFormat:@"Pitch=%d",pitchFinal]];
    
}

- (void) finCommande{
    [ecran updateBtnChangementMode:@"FIN MOUVEMENT"];
}


#pragma mark DroneDiscovererDelegate
- (void)droneDiscoverer:(DroneDiscoverer *)droneDiscoverer didUpdateDronesList:(NSArray *)dronesList {
    _dataSource = dronesList;
    
    if(_dataSource.count != 0 ){
        _service = [_dataSource objectAtIndex:0];
        
        _stateSem = dispatch_semaphore_create(0);
        
        _bebopDrone = [[BebopDrone alloc] initWithService:_service];
        [_bebopDrone setDelegate:self];
        [_bebopDrone connect];
        
        _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Connexion ..."
                                                         delegate:self cancelButtonTitle:@"Annulation" otherButtonTitles:nil, nil];
        if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
            [_connectionAlertView show];
        }
    }
    
}

- (BOOL)bebopDrone:(BebopDrone*)bebopDrone configureDecoder:(ARCONTROLLER_Stream_Codec_t)codec {
    return NO;
}

- (BOOL)bebopDrone:(BebopDrone*)bebopDrone didReceiveFrame:(ARCONTROLLER_Frame_t*)frame {
    return NO;
}

#pragma mark notification registration
- (void)registerNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enteredBackground:) name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForeground:) name: UIApplicationWillEnterForegroundNotification object: nil];
}

- (void)unregisterNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationDidEnterBackgroundNotification object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: UIApplicationWillEnterForegroundNotification object: nil];
}

#pragma mark - application notifications
- (void)enterForeground:(NSNotification*)notification {
    [_droneDiscoverer startDiscovering];
}

- (void)enteredBackground:(NSNotification*)notification {
    [_droneDiscoverer stopDiscovering];
}

- (void) deconnexionDrone{
    
    if(_service != nil){
        if (_connectionAlertView && !_connectionAlertView.isHidden) {
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:NO];
        }
        
        _connectionAlertView = [[UIAlertView alloc] initWithTitle:[_service name] message:@"Disconnecting ..."
                                                         delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [_connectionAlertView show];
        
        
        NSLog(@"DECONNEXION SHOW MANUEL");
        
        // in background, disconnect from the drone
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [_bebopDrone disconnect];
            // wait for the disconnection to appear
            dispatch_semaphore_wait(_stateSem, DISPATCH_TIME_FOREVER);
            _bebopDrone = nil;
            
            // dismiss the alert view in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
                 NSLog(@"FIN CONNEXION ALERT VIEW MANUEL");
                _service = nil;
                _bebopDrone = nil;
                [self.navigationController popViewControllerAnimated:YES];
                
                
            });
        });
    }
    
}


-(void)bebopDrone:(BebopDrone *)bebopDrone connectionDidChange:(eARCONTROLLER_DEVICE_STATE)state {
    
    
    NSLog(@"CHANGEMENT ETAT MANUEL");
    switch (state) {
        case ARCONTROLLER_DEVICE_STATE_RUNNING:
            NSLog(@"STATE RUNNING");
            [_connectionAlertView dismissWithClickedButtonIndex:0 animated:YES];
            break;
        case ARCONTROLLER_DEVICE_STATE_STOPPED:
            NSLog(@"STATE STOPPED");
            dispatch_semaphore_signal(_stateSem);
            
            [self deconnexionDrone];
            
            break;
            
        default:
            break;
    }
}

- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage {

}

- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state {
    
    switch (state) {
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_LANDED:
            //[ecran updateBtnStatioDecoAttr:@"TAKE OFF"];
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_FLYING:
            //[ecran updateBtnChangementMode:@"FIN CMD"];
            break;
        case ARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE_HOVERING:
            //[ecran updateBtnChangementMode:@"HOVERING "];
            //[ecran updateBtnStatioDecoAttr:@"LAND"];
            break;
        default:
            NSLog(@"Default");
            break;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    if(_bebopDrone == nil) {
        [self registerNotifications];
        [_droneDiscoverer startDiscovering];
    
        if ([_bebopDrone connectionState] != ARCONTROLLER_DEVICE_STATE_RUNNING) {
            [_connectionAlertView show];
        }
    }
}



@end
