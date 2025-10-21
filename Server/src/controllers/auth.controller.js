import createError from "http-errors";
import { validationResult } from "express-validator";
import { User } from "../models/User.js";
import { hashPassword, comparePassword } from "../utils/password.js";
import { signToken } from "../utils/jwt.js";

export async function register(req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw createError(400, "Validation failed", { errors: errors.array() });
  }

  const { name, email, password } = req.body;

  const existing = await User.findOne({ email });
  if (existing) {
    throw createError(409, "Email already in use");
  }

  const passwordHash = await hashPassword(password);
  const user = await User.create({ name, email, passwordHash });

  const token = signToken({ sub: user._id.toString(), email: user.email });

  return res.status(201).json({ user: user.toSafeJSON(), token });
}

export async function login(req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    throw createError(400, "Validation failed", { errors: errors.array() });
  }

  const { email, password } = req.body;
  const user = await User.findOne({ email });
  if (!user) {
    throw createError(401, "Invalid credentials");
  }

  const ok = await comparePassword(password, user.passwordHash);
  if (!ok) {
    throw createError(401, "Invalid credentials");
  }

  const token = signToken({ sub: user._id.toString(), email: user.email });
  return res.json({ user: user.toSafeJSON(), token });
}
