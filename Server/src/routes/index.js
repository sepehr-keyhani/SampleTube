import { Router } from "express";
import authRoutes from "./auth.routes.js";
import videoRoutes from "./video.routes.js";

const router = Router();

router.use("/auth", authRoutes);
router.use("/videos", videoRoutes);

export default router;
