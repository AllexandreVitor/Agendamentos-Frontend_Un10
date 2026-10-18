# ====
# Stage 1 - Etapa de compilação (Builder)
# ====
FROM node:22-alpine AS builder
# Definir pasta de trabalho
WORKDIR /app

# Configura a URL da API
ARG VITR_API_URL=http:localhost:3000
ENV VITE_API_URL=$VIT_API_URL