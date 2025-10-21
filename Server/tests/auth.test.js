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

describe("Auth API", () => {
  beforeAll(async () => {
    // Connect to test database
    await mongoose.connect(
      process.env.MONGO_URI || "mongodb://127.0.0.1:27017/sampletube_test"
    );
  });

  afterAll(async () => {
    // Clean up and disconnect
    await User.deleteMany({});
    await mongoose.connection.close();
  });

  beforeEach(async () => {
    // Clear users before each test
    await User.deleteMany({});
  });

  describe("POST /api/v1/auth/register", () => {
    it("should register a new user successfully", async () => {
      const userData = {
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      };

      const response = await request(app)
        .post("/api/v1/auth/register")
        .send(userData)
        .expect(201);

      expect(response.body).toHaveProperty("user");
      expect(response.body).toHaveProperty("token");
      expect(response.body.user.email).toBe(userData.email);
      expect(response.body.user.name).toBe(userData.name);
      expect(response.body.user).not.toHaveProperty("passwordHash");
    });

    it("should reject registration with invalid email", async () => {
      const userData = {
        name: "John Doe",
        email: "invalid-email",
        password: "password123",
      };

      const response = await request(app)
        .post("/api/v1/auth/register")
        .send(userData)
        .expect(400);

      expect(response.body).toHaveProperty("error");
    });

    it("should reject registration with duplicate email", async () => {
      const userData = {
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      };

      // Register first user
      await request(app)
        .post("/api/v1/auth/register")
        .send(userData)
        .expect(201);

      // Try to register with same email
      const response = await request(app)
        .post("/api/v1/auth/register")
        .send(userData)
        .expect(409);

      expect(response.body).toHaveProperty("error");
    });

    it("should reject registration with short password", async () => {
      const userData = {
        name: "John Doe",
        email: "john@example.com",
        password: "123",
      };

      const response = await request(app)
        .post("/api/v1/auth/register")
        .send(userData)
        .expect(400);

      expect(response.body).toHaveProperty("error");
    });
  });

  describe("POST /api/v1/auth/login", () => {
    beforeEach(async () => {
      // Create a test user
      const userData = {
        name: "John Doe",
        email: "john@example.com",
        password: "password123",
      };
      await request(app).post("/api/v1/auth/register").send(userData);
    });

    it("should login with valid credentials", async () => {
      const loginData = {
        email: "john@example.com",
        password: "password123",
      };

      const response = await request(app)
        .post("/api/v1/auth/login")
        .send(loginData)
        .expect(200);

      expect(response.body).toHaveProperty("user");
      expect(response.body).toHaveProperty("token");
      expect(response.body.user.email).toBe(loginData.email);
    });

    it("should reject login with invalid email", async () => {
      const loginData = {
        email: "nonexistent@example.com",
        password: "password123",
      };

      const response = await request(app)
        .post("/api/v1/auth/login")
        .send(loginData)
        .expect(401);

      expect(response.body).toHaveProperty("error");
    });

    it("should reject login with invalid password", async () => {
      const loginData = {
        email: "john@example.com",
        password: "wrongpassword",
      };

      const response = await request(app)
        .post("/api/v1/auth/login")
        .send(loginData)
        .expect(401);

      expect(response.body).toHaveProperty("error");
    });
  });
});
