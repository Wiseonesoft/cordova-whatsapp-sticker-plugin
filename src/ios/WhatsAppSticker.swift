import UIKit

@objc(WhatsAppSticker) class WhatsAppSticker : CDVPlugin {

  private static let PasteboardExpirationSeconds: TimeInterval = 60
  private static let PasteboardStickerPackDataType: String = "net.whatsapp.third-party.sticker-pack"
  private static let WhatsAppURL: URL = URL(string: "whatsapp://stickerPack")!
    
  func sendToWhatsapp(_ command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_ERROR
    )

    let jsonData = command.arguments[0] as? String ?? ""

    if #available(iOS 10.0, *) {
        pasteboard.setItems([[PasteboardStickerPackDataType: jsonData]], options: [UIPasteboardOption.localOnly: true, UIPasteboardOption.expirationDate: NSDate(timeIntervalSinceNow: PasteboardExpirationSeconds)])
    } else {
        pasteboard.setData(jsonData, forPasteboardType: PasteboardStickerPackDataType)
    }
    
    DispatchQueue.main.async {
      if canSend() {
          if #available(iOS 10.0, *) {
              UIApplication.shared.open(WhatsAppURL, options: [:], completionHandler: nil)
          } else {
              UIApplication.shared.openURL(WhatsAppURL)
          }
      }
    }

    // let msg = command.arguments[0] as? String ?? ""

    // if msg.characters.count > 0 {
    //   /* UIAlertController is iOS 8 or newer only. */
    //   let toastController: UIAlertController = 
    //     UIAlertController(
    //       title: "", 
    //       message: msg, 
    //       preferredStyle: .Alert
    //     )

    //   self.viewController?.presentViewController(
    //     toastController, 
    //     animated: true, 
    //     completion: nil
    //   )

    //   let duration = Double(NSEC_PER_SEC) * 3.0
      
    //   dispatch_after(
    //     dispatch_time(
    //       DISPATCH_TIME_NOW, 
    //       Int64(duration)
    //     ), 
    //     dispatch_get_main_queue(), 
    //     { 
    //       toastController.dismissViewControllerAnimated(
    //         true, 
    //         completion: nil
    //       )
    //     }
    //   )

    //   
    // }

    self.commandDelegate!.send(
      pluginResult, 
      callbackId: command.callbackId
    )
  }
}