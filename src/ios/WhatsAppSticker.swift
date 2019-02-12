

@objc(WhatsAppSticker) class WhatsAppSticker : CDVPlugin {
  func sendToWhatsapp(command: CDVInvokedUrlCommand) {
    var pluginResult = CDVPluginResult(
      status: CDVCommandStatus_ERROR
    )

    let jsonData : [String:Any] = command.arguments[0] as! [String:Any];

    StickerPackManager.queue.async {
      var json: [String: Any] = [:]
      json["identifier"] = jsonData["identifier"]
      json["name"] = jsonData["name"]
      json["publisher"] = jsonData["publisher"]
      json["tray_image"] = jsonData["trayImageFileName"]

      var stickersArray: [[String: Any]] = []

      for sticker in json["stickers"] {
          var stickerDict: [String: Any] = [:]

          stickerDict["image_data"] = sticker

          stickersArray.append(stickerDict)
      }
      
      json["stickers"] = stickersArray

      let result = Interoperability.send(json: json)
      DispatchQueue.main.async {
          pluginResult = CDVPluginResult(
            status: CDVCommandStatus_OK,
            messageAsString: "Deu certo"
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