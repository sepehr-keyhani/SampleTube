import "dotenv/config";
import http from "http";
import app from "./app.js";
import { connectDatabase } from "./config/db.js";

const PORT = process.env.PORT || 4000;
const MONGO_URI = process.env.MONGO_URI;

(async () => {
  try {
    await connectDatabase(MONGO_URI);

    const server = http.createServer(app);
    server.listen(PORT, () => {
      // eslint-disable-next-line no-console
      console.log(`Server listening on http://localhost:${PORT}`);
    });

    process.on("unhandledRejection", (reason) => {
      // eslint-disable-next-line no-console
      console.error("Unhandled Rejection:", reason);
    });

    process.on("uncaughtException", (err) => {
      // eslint-disable-next-line no-console
      console.error("Uncaught Exception:", err);
      process.exit(1);
    });
  } catch (err) {
    // eslint-disable-next-line no-console
    console.error("Failed to start server:", err);
    process.exit(1);
  }
})();
