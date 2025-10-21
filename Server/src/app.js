import express from "express";
import cors from "cors";
import helmet from "helmet";
import morgan from "morgan";
import createError from "http-errors";
import apiRouter from "./routes/index.js";
import path from "path";
import { fileURLToPath } from "url";
import { errorHandler } from "./middlewares/errorHandler.js";

const app = express();

// Middlewares
app.use(helmet());
app.use(cors());
app.use(express.json());
app.use(morgan("dev"));

// Static videos
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
app.use("/static/videos", express.static(path.join(__dirname, "./videos")));

// Routes
app.use("/api/v1", apiRouter);

// 404 handler
app.use((req, res, next) => {
  next(createError(404, "Route not found"));
});

// Error handler
app.use(errorHandler);

export default app;
