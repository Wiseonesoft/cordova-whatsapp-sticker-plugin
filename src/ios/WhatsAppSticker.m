/********* WhatsAppSticker.h Cordova Plugin Header *******/

#import <Cordova/CDVPlugin.h>

@interface WhatsAppSticker : CDVPlugin

- (void)sendToWhatsapp:(CDVInvokedUrlCommand*)command;

@end

/********* WhatsAppSticker.m Cordova Plugin Implementation *******/

#import <Cordova/CDVPlugin.h>

@implementation WhatsAppSticker

- (void)sendToWhatsapp:(CDVInvokedUrlCommand*)command
{
    CDVPluginResult* pluginResult = nil;
    // NSString* identifier = [ valueForKey:@"identifier" ];
    // NSString* name = [[command.arguments objectAtIndex:0] valueForKey:@"name" ];
    // NSString* publisher = [[command.arguments objectAtIndex:0] valueForKey:@"publisher" ];
    // NSString* trayImage = [[command.arguments objectAtIndex:0] valueForKey:@"trayImage" ];
    // NSArray* stickers = [[command.arguments objectAtIndex:0] valueForKey:@"stickers" ];

    // StickerPackManager.queue.async {
    //   NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:10];



    //   for sticker in json["stickers"] as! [String] {
    //     var stickerDict: [String: Any] = [:]
        
    //     [myArray addObject: @"New item"];
    //     stickerDict["image_data"] = sticker

    //     stickersArray.append(stickerDict)
    //   }
      
    //   json["stickers"] = stickersArray

    //   let result = Interoperability.send(json: json)
    //   DispatchQueue.main.async {
    //       pluginResult = CDVPluginResult(
    //         status: CDVCommandStatus_OK
    //       )
    //   }
    // }
    NSString* json = [command.arguments objectAtIndex:0];

    [[UIPasteboard generalPasteboard] setData:json forPasteboardType:@"net.whatsapp.third-party.sticker-pack"];

    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"whatsapp://stickerPack"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];

    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Deu certo"];

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end