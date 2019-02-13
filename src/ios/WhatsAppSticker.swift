import UIKit

@objc(WhatsAppSticker) class WhatsAppSticker : CDVPlugin {

  private let PasteboardExpirationSeconds: TimeInterval = 60
  private let PasteboardStickerPackDataType: String = "net.whatsapp.third-party.sticker-pack"
  private let WhatsAppURL: URL = URL(string: "whatsapp://stickerPack")!
    
  func sendToWhatsapp(_ command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_ERROR
    )

    let pasteboard: UIPasteboard = UIPasteboard.general
    let json = command.arguments[0] as? String ?? ""
    let jsonData = Data(json.utf8);

    if #available(iOS 10.0, *) {
        pasteboard.setItems([[PasteboardStickerPackDataType: jsonData]], options: [UIPasteboardOption.localOnly: true, UIPasteboardOption.expirationDate: NSDate(timeIntervalSinceNow: PasteboardExpirationSeconds)])
    } else {
        pasteboard.setData(jsonData, forPasteboardType: PasteboardStickerPackDataType)
    }
    
    DispatchQueue.main.async {
      if UIApplication.shared.canOpenURL(URL(string: "whatsapp://stickerPack")!) {
          if #available(iOS 10.0, *) {
              UIApplication.shared.open(self.WhatsAppURL, options: [:], completionHandler: nil)
          } else {
              UIApplication.shared.openURL(self.WhatsAppURL)
          }
      }
    }

    self.commandDelegate!.send(
      pluginResult, 
      callbackId: command.callbackId
    )
  }
}