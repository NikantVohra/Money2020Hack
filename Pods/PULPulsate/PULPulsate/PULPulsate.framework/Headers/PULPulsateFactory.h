//
//  PULPulsateFactory.h
//  PULPulsate
//
//  Created by Michal on 04/12/2014.
//  Copyright (c) 2014 Pulsatehq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PULPulsateManager.h"

@class PULAuthorizationData;

@interface PULPulsateFactory : NSObject

/**
 *  Creates pulsate manager instance with given API keys. If an instance already exists
 *  it returns it instead.
 *
 *  @param authorizationData authorization data
 *  @param locationEnabled   hould location be enabled at start - this will show the location prompt on start of the session
 *  @param pushEnabled       should push be enabled at start - this will show the notifications prompt on start of the session
 *  @param error             error
 *
 *  @return returns Pulsate Manager instance
 */
+(PULPulsateManager*)getInstanceWithAuthorizationData:(PULAuthorizationData*)authorizationData withLocationEnabled:(BOOL)locationEnabled withPushEnabled:(BOOL)pushEnabled withLaunchOptions:(NSDictionary*)launchOptions error:(NSError**)error;


/**
 *  Creates a PulsateManager instance with API Keys fetched from the *.plist file. If an instance
 *  already exists it returns it instead.
 *  The keys can be added to the *.plist file in such format:
 
 <key>Pulsate</key>
 <dict>
 <key>App ID</key>
 <string>XXXXXX</string>
 <key>App Key</key>
 <string>XXXXXX</string>
 </dict>
 
*
*  @param locationEnabled should location be enabled at start - this will show the location prompt on start of the session
*  @param pushEnabled     should push be enabled at start - this will show the notifications prompt on start of the session
*  @param launchOptions   launchOptions should be passed from the app delegate
*  @param error           error
*
*  @return returns nil if keys weren't found
*/
+(PULPulsateManager*)getInstanceWithLocationEnabled:(BOOL)locationEnabled withPushEnabled:(BOOL)pushEnabled withLaunchOptions:(NSDictionary*)launchOptions error:(NSError**)error;


/**
 *  Creates a PulsateManager instance with API Keys fetched from the config, location enabled and push enabled. If an instance already exists it returns it instead.
 *
 *  @return
 */
+(PULPulsateManager*)getInstanceWithLaunchOptions:(NSDictionary*)launchOptions error:(NSError**)error;

/**
 *  Returns an instance if it already exists.
 *
 *  @return returns nil if instance doesn't exist
 */
+(PULPulsateManager*)getDefaultInstance;

@end
