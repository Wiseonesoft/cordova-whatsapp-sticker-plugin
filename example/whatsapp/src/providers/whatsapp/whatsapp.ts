//#region Imports

import { Injectable } from '@angular/core';
import { IonicNativePlugin, Plugin, Cordova } from "@ionic-native/core";

//#endregion

@Plugin({
  pluginName: 'WhatsAppSticker',
  plugin: 'cordova-whatsapp-sticker-plugin',
  pluginRef: 'cordova.plugins.WhatsAppSticker',
  repo: '',
  platforms: ['iOS'],
})

/**
 * A classe que representa o serviço na qual se conecta com o cordova e executa o método.
 */
@Injectable()
export class WhatsappProvider extends IonicNativePlugin {

  /**
   * Método que envia as informações do Sticker Pack para o WhatsApp
   */
  @Cordova()
  sendToWhatsapp(stickerPack: string): Promise<any> {
    return;
  }

}
