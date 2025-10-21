import { Router } from "express";
import { body } from "express-validator";
import { asyncHandler } from "../utils/asyncHandler.js";
import { register, login } from "../controllers/auth.controller.js";

const router = Router();

router.post(
  "/register",
  [
    body("name").isString().isLength({ min: 2, max: 100 }).trim(),
    body("email").isEmail().normalizeEmail(),
    body("password").isString().isLength({ min: 6, max: 100 }),
  ],
  asyncHandler(register)
);

router.post(
  "/login",
  [
    body("email").isEmail().normalizeEmail(),
    body("password").isString().isLength({ min: 6, max: 100 }),
  ],
  asyncHandler(login)
);

export default router;
