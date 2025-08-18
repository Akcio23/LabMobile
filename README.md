# Projeto Node.js com Mongoose

Este projeto foi configurado com Node.js, Express e Mongoose para trabalhar com MongoDB.

## Estrutura do Projeto

```
trab_mobile/
├── config/
│   └── database.js     # Configuração da conexão com MongoDB
├── models/
│   └── User.js         # Modelo de exemplo (Schema do Mongoose)
├── .env               # Variáveis de ambiente
├── app.js             # Arquivo principal da aplicação
├── package.json       # Dependências e scripts
└── README.md          # Este arquivo
```

## Pré-requisitos

- Node.js instalado
- MongoDB instalado e rodando (local ou remoto)

## Como usar

1. **Instalar dependências** (se necessário):
   ```bash
   npm install
   ```

2. **Configurar MongoDB**:
   - Certifique-se que o MongoDB está rodando
   - Ajuste a URL no arquivo `.env` se necessário

3. **Executar o projeto**:
   ```bash
   # Produção
   npm start
   
   # Desenvolvimento (com auto-reload)
   npm run dev
   ```

4. **Testar a API**:
   - Acesse: http://localhost:3000
   - Criar usuário: POST http://localhost:3000/users
   - Listar usuários: GET http://localhost:3000/users

## Exemplo de uso da API

### Criar um usuário:
```json
POST http://localhost:3000/users
Content-Type: application/json

{
  "nome": "João Silva",
  "email": "joao@email.com",
  "idade": 25
}
```

### Listar usuários:
```
GET http://localhost:3000/users
```

## Dependências instaladas

- **express**: Framework web para Node.js
- **mongoose**: ODM para MongoDB
- **dotenv**: Carrega variáveis de ambiente
- **nodemon**: Auto-reload durante desenvolvimento (dev dependency)

## Configuração do MongoDB

A URL de conexão está no arquivo `.env`. Por padrão:
```
MONGODB_URI=mongodb://localhost:27017/trab_mobile
```

Você pode alterar para usar MongoDB Atlas ou outro serviço de nuvem.
