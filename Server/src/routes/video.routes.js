import { Router } from "express";
import { asyncHandler } from "../utils/asyncHandler.js";
import { requireAuth } from "../middlewares/auth.js";
import { listVideos, getVideoById } from "../controllers/video.controller.js";

const router = Router();

router.get("/", requireAuth, asyncHandler(listVideos));
router.get("/:id", asyncHandler(getVideoById));

export default router;
