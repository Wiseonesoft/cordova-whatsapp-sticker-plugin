//#region Imports

import { StickerImageData } from './sticker-image-data';

//#endregion

/**
 * As opções do pacote de figurinhas
 */
export interface StickerOptions {

  /**
   * O link para acessar o aplicativo loja da Apple
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  ios_app_store_link?: string;

  /**
   * O link para acessar o aplicativo na PlayStore
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  android_play_store_link?: string;

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
  publisher_website?: string;

  /**
   * O url para as politicas de privacidade
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  privacy_policy_website?: string;

  /**
   * O url para o site com as licensas
   *
   * @note É opcional, mas deve ser incluido mesmo que seja com uma string em branco ''
   */
  license_agreement_website?: string;

  /**
   * A versão das informações da imagem
   *
   * @note É obrigatório, sendo seu valor padrão igual a '1'
   */
  image_data_version: string;

  /**
   * Diz se deve evitar fazer cache das figurinhas
   *
   * @note É obrigatório. Não conheço os impactos que há em adicionar ou remover essa propriedade,
   * ela foi introduzida junto com a "image_data_version" no commit https://github.com/WhatsApp/stickers/commit/9a4bb5ccb14b072e020cf0c14798fac453b18d15#diff-a2165ccb734a0f8fcead6d3458b1d132R11
   */
  avoid_cache: boolean;

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
