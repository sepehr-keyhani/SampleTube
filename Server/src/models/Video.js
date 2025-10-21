import mongoose from "mongoose";

const videoSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    description: { type: String, default: "", trim: true },
    url: { type: String, required: true, trim: true },
    thumbnailUrl: { type: String, default: "", trim: true },
    durationSec: { type: Number, default: 0, min: 0 },
    publishedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

videoSchema.index({ title: "text", description: "text" });

export const Video = mongoose.model("Video", videoSchema);
