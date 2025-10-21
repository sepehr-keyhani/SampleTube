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
        PORT: process.env.PORT || 4000,
        MONGO_URI:
          process.env.MONGO_URI || "mongodb://127.0.0.1:27017/sampletube",
        JWT_SECRET: process.env.JWT_SECRET || "123123",
      },
      env_production: {
        NODE_ENV: "production",
        PORT: process.env.PORT || 4000,
        MONGO_URI:
          process.env.MONGO_URI || "mongodb://127.0.0.1:27017/sampletube",
        JWT_SECRET: process.env.JWT_SECRET || "123123",
      },
    },
  ],
};
