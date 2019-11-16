# Implementação no Android

Essa implementação não utiliza nada do plugin, ela é uma alternativa manual para que você consiga compartilhar as figurinhas do WhatsApp pelo Ionic e funciona apenas no Android. 
Se você quer utilizar o plugin em conjunto com essa implementação, eu sugiro que você trabalhe com duas três branchs ( android, ios e develop), e realize a implementação em cada plataforma em sua respectiva branch, e na develop, você adiciona modificações que irão para ambas as branchs, como por exemplo uma paǵina nova no aplicativo.

## Preparação

Para começar, gere um novo projeto do Ionic na versão 3 com o comando:

```Bash
ionic start android-whatsapp-sticker blank --type=ionic-angular
```

A preferência pela versão 3 do Ionic é porque eu ainda não encontrei uma forma de criar um serviço na versão 4 que se conecte com o plugin.

Caso você encontre uma forma, sinta-se livre para tentar a implementação que possivelmente não deverá haver nenhuma diferença entre a versaõ 3 e versão 4.

Agora, gera uma nova `build` do Ionic para o Android, para que ele possa gerar os arquivos nativos, com o comando:

```Bash
ionic cordova build android
```

---
Pronto, com os arquivos nativos gerados, vamos começar realmente com a implementação no Android.

## Arquivos necessários

Para começar a implementação, precisamos adicionar os arquivos que realizam o compartilhamento de Stickers nativo. Os arquivos são:

- [ContentFileParser.java](https://github.com/WhatsApp/stickers/blob/master/Android/app/src/main/java/com/example/samplestickerapp/ContentFileParser.java)
- [Sticker.java](https://github.com/WhatsApp/stickers/blob/master/Android/app/src/main/java/com/example/samplestickerapp/Sticker.java)
- [StickerContentProvider.java](https://github.com/WhatsApp/stickers/blob/master/Android/app/src/main/java/com/example/samplestickerapp/StickerContentProvider.java)
- [StickerPack.java](https://github.com/WhatsApp/stickers/blob/master/Android/app/src/main/java/com/example/samplestickerapp/StickerPack.java)

Baixe esses arquivos, vá na pasta do projeto, e copie esses arquivos em `platforms/android/app/src/main/java/{bundle_id}`. Esse `{bundle_id}` é a identificação do seu aplicativo, você pode encontrar no `config.xml`, na primeira linha ao lado de `widget`.

```Xml
<widget id="io.ionic.starter" version="0.0.1" xmlns="ttp://www.w3.org/ns/widgets" xmlns:cdv="http://cordova.apache.org/ns/1.0">
```

Como pode ver acima, é meu `{bundle_id}` é `io.ionic.starter`, substituindo e trocando os pontos por `/`, fica `platforms/android/app/src/main/java/io/ionic/starter`.

Com os arquivos adicionados, abra cada um deles para que possamos corrigir o `package` de cada arquivo `.java` adicionado. A linha que iremos trocar será a seguir:

```Java
package com.example.samplestickerapp;
```

Por `package {bundle_id};`, só que dessa vez, sem trocar os pontos, ficando:

```Java
package io.ionic.starter;
```

Para mantermos essas alterações no histórico do GIT, precisamos adicionar forçadamente os arquivos, pois o local onde alteramos está sendo ignorado pelo GIT. Para isso, vamos usar os seguintes comandos: 

```Bash
git add platforms/android/app/src/main/java/{bundle_id} -f 
git reset HEAD -- platforms/android/app/src/main/java/{bundle_id}/MainActivity.java
```

Trocando o `{bundle_id}` pelo encontrado em `config.xml`, e substituindo os pontos por `/`, fica assim:

```Bash
git add platforms/android/app/src/main/java/io/ionic/starter -f 
git reset HEAD -- platforms/android/app/src/main/java/io/ionic/starter/MainActivity.java
```

Com isso, digite `git status` para verificar se os arquivos foram adicionados corretamente, e depois criamos um novo commit para salvar as alterações:

```Bash
git commit -m "add: native files for stickers"
```


Agora, precisamos editar o arquivo `build.gradle` com algumas configurações necessárias. Para encontrar o arquivo, vá em `platforms/android/app/src`, e procure pelo seguinte trecho de código:

```
android {
    defaultConfig {
        versionCode cdvVersionCode ?: new BigInteger("" + privateHelpers.extractIntFromManifest("versionCode"))
        applicationId privateHelpers.extractStringFromManifest("package")

        if (cdvMinSdkVersion != null) {
            minSdkVersion cdvMinSdkVersion
        }
    }
    ...
```

E editando e adicionando as linhas necessárias, ele ficará assim:

```diff
android {
+    aaptOptions {
+      noCompress "webp"
+    }

    defaultConfig {
        versionCode cdvVersionCode ?: new BigInteger("" + privateHelpers.extractIntFromManifest("versionCode"))
        applicationId privateHelpers.extractStringFromManifest("package")

        if (cdvMinSdkVersion != null) {
            minSdkVersion cdvMinSdkVersion
        }

+        def contentProviderAuthority = applicationId + ".stickercontentprovider"
+        manifestPlaceholders = [contentProviderAuthority: contentProviderAuthority]
+        buildConfigField "String", "CONTENT_PROVIDER_AUTHORITY", "\"${contentProviderAuthority}\""
    }
    ...
```

Com as alterações feitas, precisamos forçar o git a aceitar essas modificações com o seguinte comando:

```Bash
git add platforms/android/app/build.gradle -f 
```

E depois comitamos essas alterações:

```Bash
git commit -m "add: configurations for build.gradle"
```

Agora, precisamos editar algumas configurações no arquivo `config.xml`, que pode ser encontrado na raiz do projeto. Abra o arquivo e adicione o seguinte trecho de código dentro da `tag` do `widget`:

```Diff
    <widget id="io.ionic.starter" 
    version="0.0.1" 
    xmlns="http://www.w3.org/ns/widgets" 
+   xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:cdv="http://cordova.apache.org/ns/1.0">
  ...
```

E no mesmo arquivo, dentro da `tag` chamada `platform` com o `name` igual a `android`, adicione:

```Diff
    <platform name="android">
+        <config-file mode="merge" parent="/manifest/application" platform="android" target="AndroidManifest.xml">
+            <provider android:authorities="${applicationId}.stickercontentprovider" android:enabled="true" android:exported="true" android:name=".StickerContentProvider" android:readPermission="com.whatsapp.sticker.READ" />
+        </config-file>
    ...
```

Essas alterações apenas refletiram no `AndroidManifest.xml`, elas são necessárias para que um plugin que iremos utilizar mais a frente consiga se comunicar com os arquivos nativos adicionados.

E depois, salve as alterações:

```Bash
git add .
git commit -m "add: configurations for config.xml"
```

Com isso, temos que realizar uma ultima configuração, isso é, adicionar o plugin que utilizaremos para se comunicar com esses arquivos nativos. 

O plugin se chama [Web Intent](https://ionicframework.com/docs/v3/native/web-intent/), e para adiciona-lo, use os comandos:

```Bash
ionic cordova plugin add com-darryncampbell-cordova-plugin-intent
npm install --save @ionic-native/web-intent@4
```

E no arquivo `app.module.ts`, na pasta `src/app`, adicione o plugin em `providers`:

```TypeScript
import { WebIntent } from '@ionic-native/web-intent';

@NgModule({
  ...
  providers: [
    WebIntent,
    ...
  ],
})
export class AppModule {}
```


E mais uma vez, salve as alterações:

```Bash
git add .
git commit -m "add: web intent plugin"
```

---
Pronto! Com isso, temos todas as configurações e arquivos básicos para que possa se realizar o compartilhamento de figurinhas, a seguir, precisamos adicionar as figurinhas que queremos compartilhar.

## Adicionando figurinhas

Para adicionar os arquivos das figurinhas, vá em `platforms/android/app/src/main/assets`, e nessa pasta será adicionado as suas figurinhas, a sua estrutura de pasta ficará:

- assets
    - www
    - `pacote-um`
    - `pacote-n`
    - `contents.json`

Com exceção da pasta `www`, as pastas `pacote-um` e `pacote-n` serão as pastas que possuiram as figurinhas de um pacote. Dentro dessas pastas, serão colocados as figurinhas, seguindo os regulamentos impostos pelo Whatsapp, você pode encontrar eles [aqui.](https://github.com/WhatsApp/stickers/tree/master/Android#sticker-art-and-app-requirements)

Para exemplo, eu criei uma pasta chamada `tray-cup`, e dentro, coloquei dentro três figurinhas e o logo, encontradas na pasta `assets` do repositório de exemplo do próprio WhatsApp, que pode ser acessado [por aqui.](https://github.com/WhatsApp/stickers/tree/master/Android/app/src/main/assets)

A estrutura de pasta ficou assim: 

- assets
    - www
    - `tray-cup`
        - `01_Cuppy_smile.webp`
        - `02_Cuppy_lol.webp`
        - `03_Cuppy_rofl.webp`
        - `tray_Cuppy.png`

Agora, precisamos adicionar uma forma do WhatsApp saber que essas figurinhas podem ser encontradas. Para isso, mapeamos elas no arquivo `contents.json`. 

Crie agora, na dentro da pasta `assets`, o arquivo `contents.json`, e coloque o seguinte código:

```Json
{
  "sticker_packs": [
    {
      "android_play_store_link": "",
      "ios_app_store_link": "",
      "identifier": "tray-cup",
      "name": "Cuppy",
      "publisher": "Jane Doe",
      "tray_image_file": "tray_Cuppy.png",
      "publisher_email":"",
      "publisher_website": "",
      "privacy_policy_website": "",
      "image_data_version": "1",
      "avoid_cache": false,
      "license_agreement_website": "",
      "stickers": [
        {
          "image_file": "01_Cuppy_smile.webp",
          "emojis": ["☕","🙂"]
        },
        {
          "image_file": "02_Cuppy_lol.webp",
          "emojis": ["😄","😀"]
        },
        {
          "image_file": "03_Cuppy_rofl.webp",
          "emojis": ["😆","😂"]
        }
      ]
    }
  ]
}
```

Considerações sobre o conteúdo do `contents.json`:

- Em `identifier`, o valor precisa ser o MESMO do nome da pasta criada para esse pacote.
- Cada pacote, NECESSITA de um png no `tray_image_file`, esse será o logo do seu pacote de figurinhas no WhatsApp.
- Em `stickers`, adicione todos as figurinhas na pasta, e coloque ao menos um emoticon para evitar quaisquer problemas.

Com isso, salvamos esses arquivos, usando o comando: 

```
git add platforms/android/app/src/main/assets/tray-cup -f
git add platforms/android/app/src/main/assets/contents.json -f
git commit -m "add: files for one pack of stickers"
```

---
Pronto! Com isso, temos todos os arquivos das figurinhas necessários que queremos compartilhar. Agora, precisamos compartilhar essas figurinhas ao clicar em algum botão em alguma parte do aplicativo.

## Compartilhando as figurinhas

Para compartilhar, você primeiro precisa importar no seu `construtor` do componente a referência do plugin `WebIntent`:

```TypeScript
import { WebIntent } from '@ionic-native/web-intent';
...

export class HomePage {

  constructor(
    ...
    private webIntent: WebIntent,
  ) {}
```

Após adicionar a referência, use o seguinte trecho de código, em algum método, para compartilhar as figurinhas:

```TypeScript

/**
 * Método que é usado para compartilhar as figurinhas no WhatsApp
 */ 
public shareWhastAppStickers(): void {
    this.webIntent.startActivity({
            action: 'com.whatsapp.intent.action.ENABLE_STICKER_PACK',
            extras: {
                'sticker_pack_id': 'tray-cup', // A identificação do pacote a ser compartilhado.
                
                //'sticker_pack_authority': '{bundle_id}.stickercontentprovider', 
                // Substitua {bundle_id} pelo bundle id encontrado no config.xml.
                // Como o meu é io.ionic.starter, fica assim:
                'sticker_pack_authority': 'io.ionic.starter.stickercontentprovider', 
                
                'sticker_pack_name': 'Cuppy' // O nome do pacote, sempre coloque o mesmo que o colocado em contents.json
            }
        })
        .then(success => {
            // Esse código é chamado quando tudo ocorre sem problemas.
            console.log(success);
        })
        .catch(error => {
            // Caso ocorra algum erro, por exemplo, se o usuário não possui o WhatsApp instalado, esse código será chamado.
            console.log(error);
        });
}
```

---
Pronto! Com isso, você poderá compartilhar as figurinhas no Android. Agora basta executar o comando `ionic cordova run android`, com um celular conectado, que possua o WhatsApp, para testar.

## Considerações finais

Esse é um método onde, você edita os arquivos gerados automaticamente pelo cordova, então são configurações bem sensiveis e suscetiveis a quebrar caso você apague a pasta `platforms`.

Se você adicionou apenas os arquivos mencionados nesse tutorial, se por algum motivo não estiver conseguindo buildar o aplicativo, basta apagar a pasta `platforms`, e executar o comando `git checkout -- .`, para voltar apenas os arquivos alterados. Depois builde o aplicativo novamente com `ionic cordova build android`.

Ao adicionar novos pacotes, sempre adicione individualmente eles com `git caminho/para/o/arquivo/arquivo.algumacoisa -f` no GIT, para que, você possa versionar o seu código e não se preocupar tanto com os arquivos gerados automaticamente.

Quaisquer problemas ao compartihar, possivelmente ocorrerão com formatos do arquivo `.webp` ou outros mais estranhos. Para saber o que ocorre, você pode obter os logs do WhatsApp, para isso, abra o WhatsApp, vá em Configurações, entre em Ajuda, adicione um texto qualquer no campo de explicação e clique em avançar, clique no banner abaixo escrito "Isso não responde minha pergunta", ele pedirá para abrir algum aplicativo de e-mail, selecione algum e observe que em anexo há um zip com logs, é justamente isso que queremos saber para descobrir o possivel erro, troque agora o "Para", e remova o e-mail que estiver e coloque o seu próprio e-mail e envie. Com isso, você terá enviado os logs desse dispositivo para sí mesmo, depois, abra o zip e pegue o log do dia, e leia os logs para descobrir o que possivelmente o WhatsApp está rejeitando das suas figurinhas.
