/********* WhatsAppSticker.h Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>

@interface WhatsAppSticker : CDVPlugin

- (void)sendToWhatsapp:(CDVInvokedUrlCommand*)command;

@end

/********* WhatsAppSticker.m Cordova Plugin Implementation *******/

#import "WhatsAppSticker.h"
#import <Cordova/CDVPlugin.h>

@implementation WhatsAppSticker

- (void)sendToWhatsapp:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    NSString* echo = [command.arguments objectAtIndex:0];

    if (echo != nil && [echo length] > 0) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:echo];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end