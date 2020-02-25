
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
