@objc(WhatsAppSticker) class WhatsAppSticker : CDVPlugin {
  func sendToWhatsapp(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_ERROR
    )

    let arguments = command.arguments[0];
    let jsonData = JSON(arguments);

    var stickerPack: StickerPack!;

    stickerPack = try StickerPack(
      identifier: jsonData["identifier"],
      name: jsonData["name"],
      publisher: jsonData["publisher"],
      trayImageFileName: jsonData["trayImageFileName"],
      '',
      '',
      ''
    )

    stickerPack.sendToWhatsApp { completed in 
    
      if (completed) {
        pluginResult = CDVPluginResult(
          status: CDVCommandStatus_OK,
          messageAsString: 'Deu certo'
        )
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

    self.commandDelegate!.sendPluginResult(
      pluginResult, 
      callbackId: command.callbackId
    )
  }
}