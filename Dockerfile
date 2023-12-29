# # Use an official Node.js image as the base image
# FROM node:hydrogen-alpine3.19

# # Use an official Node.js image as the base image
# # FROM node:14

# # Set the working directory inside the container
# WORKDIR /usr/src/app

# # Copy package.json and package-lock.json to the working directory
# COPY package*.json ./

# # Install dependencies
# RUN npm install

# # Install Prisma CLI globally
# RUN npm install -g prisma

# # Copy the rest of the application code
# COPY . .

# # Generate Prisma client
# RUN npx prisma generate

# # Build the Next.js application
# RUN npm run build

# # Expose the port that the Next.js app will run on
# EXPOSE 3000

# # Set the command to run the application
# CMD ["npm", "start"]




# Stage 1: Build Stage
FROM node:hydrogen-alpine3.19 AS build
WORKDIR /usr/src/app

COPY package*.json ./
RUN npm install
COPY . .
RUN npx prisma generate
RUN npm run build

# Stage 2: Production Stage
FROM node:14-alpine
WORKDIR /usr/src/app

COPY --from=build /usr/src/app/package*.json ./
COPY --from=build /usr/src/app/.next ./.next
COPY --from=build /usr/src/app/public ./public
COPY --from=build /usr/src/app/node_modules ./node_modules
COPY --from=build /usr/src/app/prisma ./prisma
COPY --from=build /usr/src/app/next.config.js ./


EXPOSE 3000

CMD ["npm", "start"]
