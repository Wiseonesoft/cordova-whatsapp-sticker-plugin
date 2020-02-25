# Installation

First, clone this repository with `git clone https://github.com/H4ad/cordova-whatsapp-sticker-plugin.git`.

Then enter the repository folder, enter on `example`, and then on `whatsapp` and remove the `platforms` folder.

After removal, run `npm i` to install dependencies, run the `ionic cordova build android` command to first generate the default files for `platforms` folder. And after successfully generating the apk, run `git checkout -- .`, to undo changes by deleting the `platforms` folder. And in the end, rerun `ionic cordova build android`, and now the apk includes the `platforms` folder modifications needed for stickers sharing.

These steps are necessary because there is a modification to the `platforms` folder, which is dinamically generated; therefore, every time you clone the project, you will need these steps.

Command sequence ( running in Linux ):
```bash
git clone https://github.com/H4ad/cordova-whatsapp-sticker-plugin.git
cd cordova-whatsapp-sticker-plugin/example/whatsapp
rm -r -f platforms
npm i
ionic cordova build android
git checkout -- .
ionic cordova build android
```

# Instalação

Primeiro, clone o projeto usando `git clone https://github.com/H4ad/cordova-whatsapp-sticker-plugin.git`.

Depois, entre na pasta pasta do projeto, entre em `example`, depois em `whatsapp` e apague a pasta `platforms`.

Depois de remover, execute `npm i` para instalar as dependências, execute o comando `ionic cordova build android`, para primeiro gerar os arquivos necessários para a pasta `platforms`.
E após gerar o apk com sucesso, execute `git checkout -- .` para desfazer as mudanças no projeto que ocorreram ao apagar a pasta `platforms`. E por fim, execute novamente `ionic cordova build android`, dessa vez, o apk incluirá as modificações na pasta `platforms` que faz funcionar o compartilhamento de stickers.

Esses passos são necessários porque há modificação na pasta `platforms` que é gerada dinamicamente, então toda vez que você for clonar o projeto, será necessário essas etapas.

Sequência de comandos ( rodados no Linux ):
```bash
git clone https://github.com/H4ad/cordova-whatsapp-sticker-plugin.git
cd cordova-whatsapp-sticker-plugin/example/whatsapp
rm -r -f platforms
npm i
ionic cordova build android
git checkout -- .
ionic cordova build android
```