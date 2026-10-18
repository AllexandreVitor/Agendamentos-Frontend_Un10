# ====
# Stage 1 - Etapa de compilação (Builder)
# ====
FROM node:22-alpine AS builder
# Definir pasta de trabalho
WORKDIR /app

# Configura a URL da API
ARG VITE_API_URL=http:localhost:3000
ENV VITE_API_URL=$VITE_API_URL

# Copiar os arquivos de dependências
COPY package*.json ./

# Instalar dependências
RUN npm ci

# Copiar o código-fonte respeitando o .dockerignore
COPY . .

# Executa a compilação do TypeScript e empacotamento do Vite
RUN npm run build

# ====
# Stage 2 - Etapa de execução (Nginx)
# ====

# Usar o Nginx como imagem final
FROM nginx:alpine

# Remover a configuração padrão do Nginx
RUN rm -rf /etc/nginx/conf.d/*

# Copiar a configuração personalizada
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar apenas os arquivos compilados
COPY --from=builder /app/dist /usr/share/nginx/html

# Declarar a porta HTTP
EXPOSE 80

# Configurar o helath check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost/healthz || exit 1

# Iniciar o Nginx
CMD ["nginx", "-g", "daemon off;"]