import { describe, it, expect } from "vitest";
import { generateMockNFTMember, validateMembershipLevel, formatDate } from "./helpers";

describe("NFT Membership Helpers", () => {
    it("should generate a mock NFT member with valid properties", () => {
        const member = generateMockNFTMember(1, "Alice", "Gold");

        expect(member).toHaveProperty("id", 1);
        expect(member).toHaveProperty("name", "Alice");
        expect(member).toHaveProperty("membershipLevel", "Gold");
        expect(member).toHaveProperty("joinedAt");
    });

    it("should validate correct membership levels", () => {
        expect(validateMembershipLevel("Gold")).toBe(true);
        expect(validateMembershipLevel("Silver")).toBe(true);
        expect(validateMembershipLevel("Platinum")).toBe(true);
    });

    it("should reject invalid membership levels", () => {
        expect(validateMembershipLevel("Bronze")).toBe(false);
        expect(validateMembershipLevel("Diamond")).toBe(false);
    });

    it("should format date correctly", () => {
        const date = new Date("2024-06-15T12:00:00Z");
        expect(formatDate(date)).toBe("2024-06-15");
    });
});
