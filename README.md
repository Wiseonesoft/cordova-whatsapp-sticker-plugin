# Cordova WhatsApp Sticker Plugin

Um plugin para o Cordova Apache usado para compartilhar stickers do WhatsApp.

## Indice

- [Plataformas Suportadas](#plataformas-suportadas)
- [Instalação](#instalação)
- [Como usar](#como-usar)
  - [Ionic](#ionic)
    - [Exemplo](#exemplo)
- [Para evitar problemas](#para-evitar-problemas)
  - [Imagens](#imagens)

## Plataformas Suportadas

- iOS

Por enquanto, há apenas suporte para iOS, visto que, a forma na qual é compartilhado o Sticker é mais simples do que a usada no Android.

## Instalação

`cordova plugin add cordova-whatsapp-sticker-plugin`

## Como usar

### Ionic

Caso queira baixar um código para ver como funciona, [clique aqui](https://github.com/H4ad/webapp-whatsapp-sticker/tree/ios) para ver um repositório com um código implementando o plugin.

### Usar no Ionic

> Por enquanto, apenas é possivel utilizar o plugin no Ionic v3, visto que, no v4 há algums problemas na criação do serviço que se conecta com o plugin no cordova.
> Mas, se houver uma atualização, sinta-se a vontade de criar seu próprio serviço que deve funcionar sem problemas.

Primeiro, crie um `provider` e adicione o seguinte código:

```TypeScript
import { Injectable } from '@angular/core';
import { IonicNativePlugin, Plugin, Cordova } from "@ionic-native/core";

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

/**
 * As opções do pacote de figurinhas
 */
export interface StickerOptions {

  /**
   * O link para acessar o aplicativo loja da Apple
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  ios_app_store_link: string;

  /**
   * O link para acessar o aplicativo na PlayStore
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  android_play_store_link: string;

  /**
   * O identificador desse pacote
   */
  identifier: string;

  /**
   * O nome do pacote
   */
  name: string;

  /**
   * O nome de quem está publicando o pacote
   */
  publisher: string;

  /**
   * O url do site de quem está publicando o pacote
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  publisher_website: string;

  /**
   * O url para as politicas de privacidade
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  privacy_policy_website: string;

  /**
   * O url para o site com as licensas
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  license_agreement_website: string;

  /**
   * A imagem que representa esse pacote como um todo
   *
   * @note É necessário ser um BASE64 de um PNG
   * @note É necessário seguir as especificações impostas pelo WhatsApp
   */
  tray_image: string;

  /**
   * A lista com as informações sobre as figurinhas
   */
  stickers: StickerImageData[];

}

 /**
  * As informações sobre um Sticker
  */
export interface StickerImageData {

  /**
   * A representação do Sticker
   *
   * @note Elas devem estar em BASE64 da imagem SEM O PREFIXO data:image/webp;base64,
   * @note Elas devem ser imagens em formato WEBP que sigam os requisitos do WhatsApp
   */
  image_data: string;

  /**
   * Uma lista de emojis para representar esse Sticker, no máximo 3 emojis
   */
  emojis: string[];

}
```

Após isso, adicione ele no `app.module.ts` no `array` de `imports`:

```TypeScript
@NgModule({
  providers: [
    ...
    WhatsappProvider,
    ...
  ]
})
```  

Agora, você só precisa adiciona-lo no construtor para conseguir compartilhar os Stickers.

#### Exemplo

```TypeScript
import { Component } from '@angular/core';
import { WhatsappProvider, StickerOptions } from "../../providers/whatsapp/whatsapp";

@Component({
  selector: 'page-home',
  templateUrl: 'home.html'
})
export class HomePage {

  /**
   * Construtor padrão
   */
  constructor(
    private whatsapp: WhatsappProvider,
  ) {}

  /**
   * Método que envia as figurinhas para o WhatsApp
   */ 
  public sendToWhatsapp(): void {
    const data: StickerOptions = {
      ios_app_store_link: '', // Opcional
      android_play_store_link: '', // Opcional
      identifier: 'COLOQUE AQUI A IDENTIFICAÇÃO DO PACOTE',
      name: 'O NOME DO PACOTE',
      publisher: 'O NOME DE QUEM ESTÁ PUBLICANDO',
      publisher_website: '', // Opcional
      privacy_policy_website: '', // Opcional
      license_agreement_website: '', // Opcional
      tray_image: 'PNG EM BASE64',
      stickers: [
        {
          image_data: 'WEBP EM BASE64',
          emoji: ["☕", "🙂"]
        },
        {
          image_data: 'WEBP EM BASE64',
          emoji: ["☕", "🙂"]
        },
        {
          image_data: 'WEBP EM BASE64',
          emoji: ["☕", "🙂"]
        },
      ]
    };
    
    const json = JSON.stringify(data);

    this.whatsapp.sendToWhatsapp(json).then(success => alert(success), error => alert(error));
  }
}
```

## Para evitar problemas

Para não haver nenhum erro, é necessário seguir todos os padrões impostos pelo WhatsApp sobre as espeficiações das imagens na documentação oficial que você pode acessar [aqui](https://github.com/WhatsApp/stickers/tree/master/iOS)

### Imagens

Para as imagens, elas não devem possuir os prefixos `data:image/png;base64,` ou `data:image/webp;base64,`, caso contrário, o WhatsApp apontará um erro na hora de compartilhar o Sticker.


## Alternativa para Android

Há umas formas de se compartilhar um Sticker no Android pelo Ionic também, só que é um tanto mais trabalhoso, visto que, você precisa editar o código nativo gerado pelo Cordova.

Se mesmo assim você quiser saber como, [veja aqui como implementar.](/Android.md)