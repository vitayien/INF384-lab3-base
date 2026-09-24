# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# defecto 1: Se usa una version latest - se corrige por una version fija
FROM public.ecr.aws/lambda/nodejs:20 AS Builder

# defecto 2 Se copia todo - se corrige copiando solo el manifiesto y el lock para que optimice el cache
COPY package.json package-lock.json ./

# defecto 3 se instalan todas las dependencias - se corrige instalando desde el lock
RUN npm ci
COPY . .

#se compila el codigo
RUN npm run build

FROM public.ecr.aws/lambda/nodejs:20

WORKDIR /var/task

# defecto 4 - se corrige eliminando la variable de entorno

# defecto 5 - se corrige eliminando instalaciones en la etapa final
#se copia el archivo generado por el build
COPY --from=builder /var/task/dist/handler.js ./dist/handler.js

CMD ["src/handler.handler"]
