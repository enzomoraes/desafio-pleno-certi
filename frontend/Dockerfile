#######################################################################
################# PREPARANDO ARQUIVOS DE PRODUÇÃO #####################
#######################################################################
FROM alpine:latest as angular

RUN apk add --update nodejs npm

# Variáveis de ambiente
ENV HOME=/app
# ENV apiURL="http:"

# Tudo será apontado para esta pasta inicialmente
WORKDIR $HOME

# Install apartir do package.json e colar na pasta de trabalho
COPY package*.json $HOME

# Roda a instalação dentro do container e somente ficará a pasta de nod_modules e o arquivo package.json
RUN npm ci --silent

# Copia o restante dos arquivos e copia para o $HOME automaticamente
COPY . .

# Aqui nós teremos todos os arquivos e a pasta dist dentro de $HOME
RUN npm run build


#################################################################
################# EXECUTANDO O SERVIDOR WEB #####################
#################################################################

FROM nginx:alpine

LABEL author="CERTI"

# Monta o volume para copiar os arquivos gerados para produção
VOLUME /var/cache/nginx

# Copia os arquivos gerados pelo build de produção para dentro do servidor web
COPY --from=angular app/dist /usr/share/nginx/html

RUN rm /usr/share/nginx/html/50x.html

# Com isso, o NGINX rodando padrão na porta 80 
COPY ./config/nginx.conf /etc/nginx/conf.d/default.conf

###################################################