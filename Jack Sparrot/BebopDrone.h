//
//  BebopDrone.h
//  SDKSample
//

#import <Foundation/Foundation.h>
#import <libARController/ARController.h>
#import <libARDiscovery/ARDISCOVERY_BonjourDiscovery.h>
#import "ViewControllerManuel.h"

@class BebopDrone;

@protocol BebopDroneDelegate <NSObject>
@required
/**
 * Called when the connection to the drone did change
 * Called on the main thread
 * @param bebopDrone the drone concerned
 * @param state the state of the connection
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone connectionDidChange:(eARCONTROLLER_DEVICE_STATE)state;

/**
 * Called when the battery charge did change
 * Called on the main thread
 * @param bebopDrone the drone concerned
 * @param batteryPercent the battery remaining (in percent)
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone batteryDidChange:(int)batteryPercentage;

/**
 * Called when the piloting state did change
 * Called on the main thread
 * @param bebopDrone the drone concerned
 * @param batteryPercent the piloting state of the drone
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone flyingStateDidChange:(eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)state;

/**
 * Called when the video decoder should be configured
 * Called on separate thread
 * @param bebopDrone the drone concerned
 * @param codec the codec information about the stream
 * @return true if configuration went well, false otherwise
 */
- (BOOL)bebopDrone:(BebopDrone*)bebopDrone configureDecoder:(ARCONTROLLER_Stream_Codec_t)codec;

/**
 * Called when a frame has been received
 * Called on separate thread
 * @param bebopDrone the drone concerned
 * @param frame the frame received
 */
- (BOOL)bebopDrone:(BebopDrone*)bebopDrone didReceiveFrame:(ARCONTROLLER_Frame_t*)frame;

/**
 * Called before medias will be downloaded
 * Called on the main thread
 * @param bebopDrone the drone concerned
 * @param nbMedias the number of medias that will be downloaded
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone didFoundMatchingMedias:(NSUInteger)nbMedias;

/**
 * Called each time the progress of a download changes
 * Called on the main thread
 * @param bebopDrone the drone concerned
 * @param mediaName the name of the media
 * @param progress the progress of its download (from 0 to 100)
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone media:(NSString*)mediaName downloadDidProgress:(int)progress;

/**
 * Called when a media download has ended
 * Called on the main thread
 * @param bebopDrone the drone concerned
 * @param mediaName the name of the media
 */
- (void)bebopDrone:(BebopDrone*)bebopDrone mediaDownloadDidFinish:(NSString*)mediaName;

@end

@interface BebopDrone : NSObject

@property (nonatomic, weak) id<BebopDroneDelegate>delegate;

/**
 *  @brief Instanciation de la classe avec un service qui contient l'identificateur du drone.
 *  @param service notre service de découverte de drone.
 */
- (id)initWithService:(ARService*)service;
/**
 * @brief Connexion au drone
 */
- (void)connect;
/**
 * @brief Deconnexion du drone
 */
- (void)disconnect;
/**
 * @brief Récupère l'état actuel du drone
 * @return etat de connexion au drone
 */
- (eARCONTROLLER_DEVICE_STATE)connectionState;
/**
 * @brief Récupération de l'état de vol du drone
 * @return L'etat du drone en cours. 
 */
- (eARCOMMANDS_ARDRONE3_PILOTINGSTATE_FLYINGSTATECHANGED_STATE)flyingState;
/**
 * @brief Arrêt immédiat des hélices du drone
 */
- (void)emergency;
/**
 * @brief Décollage du drone, mise à une altitude gérée par l'API elle-même. L'évitement est actif par defaut.
 *
 */
- (void)takeOff;
/**
 * @brief Atterrissage du drone, l'atterrissage est gérée automatiquement par l'API
 */
- (void)land;
/**
 * @brief Pitch, ATTENTION le drone avance jusqu'à recevoir un pitch de 0
 * @param Pitch La valeur du pitch comprise entre [-100;100]
 */
- (void)setPitch:(int)pitch;
/**
 * @brief Roll, ATTENTION le drone avance jusqu'à recevoir un roll de 0
 * @param Roll La valeur du roll comprise entre [-100;100]
 */
- (void)setRoll:(uint8_t)roll;
/**
 * @brief Yaw, ATTENTION le drone fait une rotation jusqu'à recevoir un yaw de 0
 * @param Yaw La valeur du yaw comprise entre [-100;100]
 */
- (void)setYaw:(uint8_t)yaw;
/**
 * @brief Gaz, ATTENTION le drone monte/descend jusqu'à recevoir un 0 ou hauteur max.
 * @param Gaz La valeur du Gaz comprise entre [-100;100]
 */
- (void)setGaz:(uint8_t)gaz;
/**
 * @brief Flag pour l'activation des fonctions pitch/roll
 * @param Flag Compris entre 0 ou 1; 1 active le pitch/roll.
 */
- (void)setFlag:(uint8_t)flag;
/**
 * @brief Annulation immédiate si un returnToHome est en cours (Interieur/Exterieur)
 */
- (void)cancelReturnHome;
/**
 * @brief implémentation particulière du returnHome le drone fait les mouvements inverse de ceux qu'il a effectué
 */
- (void)returnHomeInterieur;
/**
 * @brief implémentation par defaut de Parrot
 */
- (void)returnHomeExterieur;
/**
 * @brief Mise en place de l'hauteur maximale pour le drone
 * @param altitude L'altitude maximale du drone
 */
- (void)setMaxHauteur:(float)altitude;
/**
 * @brief Mise en place de l'acceleration maximale pour le drone
 * @param coef Le coefficient d'acceleration du drone
 */
- (void)setAcceleration:(float)coef;
/**
 * @brief Remise en place des réglages par défault (vitesse/camera)
 */
- (void)setDefaultSetting;
/**
 * @brief Référence pour pouvoir mettre à jour la view
 */
- (void)setViewCall:(ViewControllerManuel*)view;
/**
 * @brief Mise en place des settings de l'utilisateur
 */
- (void)setCustomSetting;
/**
 * @brief Méthode pour déterminer si le drone est en état de vol ou non.
 */
- (int) isFlying;

@end
