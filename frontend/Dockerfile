# Use an official Node.js runtime as a base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY next/package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code to the working directory
COPY next .

# Build the Next.js app for production
RUN npm run build

# Copy the standalone build and static files
RUN cp -r .next/static .next/standalone/.next/static
RUN cp -r public .next/standalone/public

# Expose the port that the Next.js app will run on
EXPOSE 3000

# Start the Next.js app in production mode
CMD ["node", ".next/standalone/server.js"]