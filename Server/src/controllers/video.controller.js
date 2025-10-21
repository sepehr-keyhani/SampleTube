import createError from "http-errors";
import fs from "fs/promises";
import path from "path";
import { fileURLToPath } from "url";

export async function listVideos(req, res) {
  const page = Math.max(parseInt(req.query.page, 10) || 1, 1);
  const limit = Math.min(Math.max(parseInt(req.query.limit, 10) || 20, 1), 100);
  const skip = (page - 1) * limit;

  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  const videosDir = path.join(__dirname, "../videos");

  const entries = await fs.readdir(videosDir, { withFileTypes: true });
  const files = entries
    .filter((e) => e.isFile() && e.name.toLowerCase().endsWith(".mp4"))
    .map((e) => e.name);
  const total = files.length;
  const pageSlice = files.slice(skip, skip + limit);
  const data = pageSlice.map((filename) => ({
    id: filename,
    title: filename,
    url: `/static/videos/${encodeURIComponent(filename)}`,
  }));
  return res.json({ data, page, limit, total });
}

export async function getVideoById(req, res) {
  const { id } = req.params;
  const __filename = fileURLToPath(import.meta.url);
  const __dirname = path.dirname(__filename);
  const filePath = path.join(__dirname, "../../Videos", id);
  try {
    await fs.access(filePath);
  } catch {
    throw createError(404, "Video not found");
  }
  return res.sendFile(filePath);
}
