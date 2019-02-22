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

    // Obtém o JSON contendo as informações do Sticker Pack
    NSString* json = [command.arguments objectAtIndex:0];

    // Copia as informações do JSON para o Pasteboard, que é a forma na qual o Whatsapp lê as informações do Sticker Pack no iOS
    [[UIPasteboard generalPasteboard] setData:json forPasteboardType:@"net.whatsapp.third-party.sticker-pack"];

    UIApplication *application = [UIApplication sharedApplication];

    // O URL Scheme usado para enviar as informações do Sticker Pack
    NSURL *URL = [NSURL URLWithString:@"whatsapp://stickerPack"];

    // Abre o URL Scheme, e por consequencia, abre o WhatsApp
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        CDVPluginResult* pluginResult = nil;
        if (success) {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Figurinhas enviadas."];
        } else {
            pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"Ocorreu algum problema, as figurinhas não foram enviadas."];
        }

        [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    }];
}

@end