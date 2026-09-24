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

# defecto 4 - se corrige eliminando la variable de entorno

# defecto 5 - se corrige eliminando instalaciones en la etapa final


### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js

# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["src/handler.handler"]
