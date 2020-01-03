# Instalação

Ao clonar o repositório, e entra na pasta example para compilar o projeto, você antes precisa ir em `example` e apagar a pasta `platforms`.

Depois, execute o comando `ionic cordova build android`, para primeiro gerar os arquivos necessários.
E a seguir, execute `git checkout -- .` para desfazer as mudanças no projeto que ocorreram ao apagar a pasta `platforms`.

Esses passos são necessários porque há modificação na pasta `platforms` que é gerada dinamicamente, então toda vez que você for clonar o projeto, será necessário essas etapas.

