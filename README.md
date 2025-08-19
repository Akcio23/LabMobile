## Estrutura do Projeto

```
LabMobile/
├── src/
│   ├── server.js              # Servidor principal
│   ├── config/
│   │   └── database.js        # Configuração MongoDB
│   ├── controllers/
│   │   ├── controllerAuthentication.js
│   │   ├── controllerRegister.js
│   │   └── controllerUser.js
│   ├── middleware/
│   │   └── verifyAuth.js      # Middleware de autenticação JWT
│   ├── models/
│   │   └── User.js           # Modelo do usuário
│   └── router/
│       ├── routerAuthentication.js
│       ├── routerRegister.js
│       └── routerUser.js
├── .env                      # Variáveis de ambiente
└── package.json
```

## Instalação

1. **Clone o repositório e instale as dependências:**
   ```bash
   npm install
   ```

2. **Configure o arquivo `.env`:**
   ```env
   URI_BD=mongodb://localhost:27017/labmobile
   KEY=sua_chave_secreta_jwt
   PORT=3000
   ```

3. **Execute o servidor:**
   ```bash
   # Desenvolvimento
   npm run dev
   
   # Produção
   npm start
   ```

## Rotas da API

### 1. **Registro de Usuário**

**Endpoint:** `POST /register`

**Descrição:** Registra um novo usuário no sistema.

**Body (JSON):**
```json
{
  "name": "João Silva",
  "email": "joao@email.com",
  "password": "minhasenha123"
}
```

**Respostas:**

✅ **Sucesso (200):**
```json
{
  "message": "User registered successfully"
}
```

❌ **Usuário já existe (409):**
```json
{
  "message": "User already exists"
}
```

---

### 2. **Login / Autenticação**

**Endpoint:** `POST /login`

**Descrição:** Autentica o usuário e retorna um token JWT.

**Body (JSON):**
```json
{
  "email": "joao@email.com",
  "password": "minhasenha123"
}
```

**Respostas:**

✅ **Sucesso (200):**
```json
{
  "message": "Login Successful",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

❌ **Usuário não encontrado (404):**
```json
{
  "message": "user not found"
}
```

❌ **Senha inválida (401):**
```json
{
  "message": "Invalid password"
}
```

---

### 3. **Consultar Dados do Usuário**

**Endpoint:** `POST /user`

**Descrição:** Retorna os dados do usuário (exceto a senha). **Requer autenticação.**

**Headers:**
```
Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
Content-Type: application/json
```

**Body (JSON):**
```json
{
  "email": "joao@email.com"
}
```

**Respostas:**

✅ **Sucesso (200):**
```json
{
  "user": {
    "_id": "507f1f77bcf86cd799439011",
    "name": "João Silva",
    "email": "joao@email.com",
    "__v": 0
  }
}
```

❌ **Usuário não encontrado (404):**
```json
{
  "message": "User not found"
}
```

❌ **Token inválido/ausente (401):**
```json
{
  "message": "Unauthorized"
}
```

---

### 4. **Health Check**

**Endpoint:** `GET /`

**Descrição:** Verifica se a API está funcionando.

**Resposta:**
```json
{
  "message": "API funcionando!",
  "mongoose": "Conectado com MongoDB via Mongoose"
}
```

## Autenticação JWT

A API utiliza JWT (JSON Web Token) para autenticação. O token é válido por **2 horas**.

### Como usar o token:

1. Faça login no endpoint `/login`
2. Copie o token retornado
3. Inclua o header `Authorization: Bearer <token>` nas rotas protegidas

### Exemplo com curl:
```bash
# Login
curl -X POST http://localhost:3000/login \
  -H "Content-Type: application/json" \
  -d '{"email":"joao@email.com","password":"minhasenha123"}'

# Usar o token para acessar dados do usuário
curl -X POST http://localhost:3000/user \
  -H "Authorization: Bearer SEU_TOKEN_AQUI" \
  -H "Content-Type: application/json" \
  -d '{"email":"joao@email.com"}'
```

## Modelo do Usuário

O modelo User possui os seguintes campos:

- **name**: String (obrigatório)
- **email**: String (obrigatório, único, formato de email)
- **password**: String (obrigatório, armazenado com hash bcrypt)

## Middleware de Segurança

- **Senhas**: Criptografadas com bcrypt (salt rounds: 10)
- **Autenticação**: JWT com expiração de 2 horas
- **Validação**: Verificação de email único e formato válido

## Dependências Principais

- **express**: Framework web
- **mongoose**: ODM para MongoDB
- **bcrypt**: Criptografia de senhas
- **jsonwebtoken**: Autenticação JWT
- **dotenv**: Variáveis de ambiente

## Tecnologias Utilizadas

- Node.js
- Express.js
- MongoDB
- Mongoose
- JWT (JSON Web Token)
- Bcrypt
- Dotenv
