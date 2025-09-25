Lista de Tarefas Flutter + Firebase

Este é um projeto de atividade prática desenvolvido em **Flutter** integrado com **Firebase Firestore**, que permite:

- Adicionar novas tarefas;
- Visualizar tarefas cadastradas em tempo real;
- Deletar tarefas.

## Tecnologias utilizadas

- **Flutter** (framework mobile e web)
- **Firebase Firestore** (banco de dados em tempo real)
- **Firebase Core** (configuração e inicialização do Firebase)

## Como rodar o projeto

1. Clone o repositório:  
   ```bash
   git clone https://github.com/Sampaiodx/firebase-listatarefas.git
   cd firebase-listatarefas
   flutter pub get
   flutter run -d chrome

## Funcionalidades

O app inicializa o Firebase corretamente.
Permite adicionar tarefas com status padrão pendente.
Atualiza a lista em tempo real usando StreamBuilder.

Permite deletar tarefas existentes.

Banco Firestore protegido com regras básicas para leitura/escrita.
