import {
  describe,
  it,
  expect,
  beforeAll,
  afterAll,
  beforeEach,
} from "@jest/globals";
import request from "supertest";
import mongoose from "mongoose";
import app from "../src/app.js";
import { User } from "../src/models/User.js";
import { signToken } from "../src/utils/jwt.js";

describe("Videos API", () => {
  let authToken;

  beforeAll(async () => {
    await mongoose.connect(
      process.env.MONGO_URI || "mongodb://127.0.0.1:27017/sampletube_test"
    );
  });

  afterAll(async () => {
    await User.deleteMany({});
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    await User.deleteMany({});

    // Create a test user and get auth token
    const userData = {
      name: "John Doe",
      email: "john@example.com",
      password: "password123",
    };

    const registerResponse = await request(app)
      .post("/api/v1/auth/register")
      .send(userData);

    authToken = registerResponse.body.token;
  });

  describe("GET /api/v1/videos", () => {
    it("should return videos list for authenticated user", async () => {
      const response = await request(app)
        .get("/api/v1/videos")
        .set("Authorization", `Bearer ${authToken}`)
        .expect(200);

      expect(response.body).toHaveProperty("data");
      expect(response.body).toHaveProperty("page");
      expect(response.body).toHaveProperty("limit");
      expect(response.body).toHaveProperty("total");
      expect(Array.isArray(response.body.data)).toBe(true);
    });

    it("should reject request without authentication", async () => {
      const response = await request(app).get("/api/v1/videos").expect(401);

      expect(response.body).toHaveProperty("error");
    });

    it("should reject request with invalid token", async () => {
      const response = await request(app)
        .get("/api/v1/videos")
        .set("Authorization", "Bearer invalid-token")
        .expect(401);

      expect(response.body).toHaveProperty("error");
    });

    it("should support pagination parameters", async () => {
      const response = await request(app)
        .get("/api/v1/videos?page=1&limit=5")
        .set("Authorization", `Bearer ${authToken}`)
        .expect(200);

      expect(response.body.page).toBe(1);
      expect(response.body.limit).toBe(5);
    });

    it("should validate pagination limits", async () => {
      const response = await request(app)
        .get("/api/v1/videos?page=1&limit=200")
        .set("Authorization", `Bearer ${authToken}`)
        .expect(200);

      // Should cap at 100
      expect(response.body.limit).toBeLessThanOrEqual(100);
    });
  });

  describe("GET /api/v1/videos/:id", () => {
    it("should serve video file for valid ID", async () => {
      // This test assumes there's at least one video file
      const videosResponse = await request(app)
        .get("/api/v1/videos")
        .set("Authorization", `Bearer ${authToken}`)
        .expect(200);

      if (videosResponse.body.data.length > 0) {
        const videoId = videosResponse.body.data[0].id;

        const response = await request(app)
          .get(`/api/v1/videos/${videoId}`)
          .expect(200);

        expect(response.headers["content-type"]).toMatch(/video/);
      }
    });

    it("should return 404 for non-existent video", async () => {
      const response = await request(app)
        .get("/api/v1/videos/nonexistent.mp4")
        .expect(404);

      expect(response.body).toHaveProperty("error");
    });
  });
});
