# ===== BUILD STAGE =====
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files first for layer caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build the app
RUN npm run build

# ===== PRODUCTION STAGE =====
FROM nginx:alpine AS serve

# Copy built assets from build stage
COPY --from=build /app/build /usr/share/nginx/html

# Copy custom nginx config (create this file too)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port
EXPOSE 80

# Set environment variables
ENV NODE_ENV=production

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]