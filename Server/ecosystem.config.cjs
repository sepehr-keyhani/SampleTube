module.exports = {
  apps: [
    {
      name: "sampletube-server",
      script: "src/server.js",
      cwd: "./Server",
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: "1G",
      env: {
        NODE_ENV: "development",
        PORT: 4000,
        MONGO_URI: "mongodb://127.0.0.1:27017/sampletube",
        JWT_SECRET: "dev_secret_change_me",
      },
      env_production: {
        NODE_ENV: "production",
        PORT: 4000,
        MONGO_URI: "mongodb://127.0.0.1:27017/sampletube",
        JWT_SECRET: "your_production_jwt_secret",
      },
    },
  ],
};
