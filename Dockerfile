# Stage 1: Build
FROM node:21-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install dependencies including Tailwind CSS
RUN npm install

# Copy the rest of the application files
COPY . .

# Build the SvelteKit app, including Tailwind CSS processing
RUN npm run build

# # Stage 2: Serve
FROM node:21-alpine AS serve

# # Set working directory
WORKDIR /app

# # Copy the built files from the build stage
COPY --from=build /app/build ./build
COPY --from=build /app/package.json ./package.json
COPY --from=build /app/package-lock.json ./package-lock.json

# RUN npm install
RUN npm install --production

EXPOSE 3000

ENV NODE_ENV=production

CMD [ "node", "build" ]