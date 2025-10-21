import { describe, it, expect } from "@jest/globals";
import { hashPassword, comparePassword } from "../src/utils/password.js";
import { signToken, verifyToken } from "../src/utils/jwt.js";

describe("Password Utils", () => {
  describe("hashPassword", () => {
    it("should hash password successfully", async () => {
      const password = "testpassword123";
      const hash = await hashPassword(password);

      expect(hash).toBeDefined();
      expect(hash).not.toBe(password);
      expect(hash.length).toBeGreaterThan(0);
    });

    it("should produce different hashes for same password", async () => {
      const password = "testpassword123";
      const hash1 = await hashPassword(password);
      const hash2 = await hashPassword(password);

      expect(hash1).not.toBe(hash2);
    });
  });

  describe("comparePassword", () => {
    it("should return true for correct password", async () => {
      const password = "testpassword123";
      const hash = await hashPassword(password);

      const isValid = await comparePassword(password, hash);
      expect(isValid).toBe(true);
    });

    it("should return false for incorrect password", async () => {
      const password = "testpassword123";
      const wrongPassword = "wrongpassword";
      const hash = await hashPassword(password);

      const isValid = await comparePassword(wrongPassword, hash);
      expect(isValid).toBe(false);
    });
  });
});

describe("JWT Utils", () => {
  describe("signToken", () => {
    it("should create a valid JWT token", () => {
      const payload = { sub: "user123", email: "test@example.com" };
      const token = signToken(payload);

      expect(token).toBeDefined();
      expect(typeof token).toBe("string");
      expect(token.split(".")).toHaveLength(3); // JWT has 3 parts
    });
  });

  describe("verifyToken", () => {
    it("should verify valid token", () => {
      const payload = { sub: "user123", email: "test@example.com" };
      const token = signToken(payload);

      const decoded = verifyToken(token);
      expect(decoded.sub).toBe(payload.sub);
      expect(decoded.email).toBe(payload.email);
    });

    it("should throw error for invalid token", () => {
      const invalidToken = "invalid.token.here";

      expect(() => {
        verifyToken(invalidToken);
      }).toThrow();
    });
  });
});
