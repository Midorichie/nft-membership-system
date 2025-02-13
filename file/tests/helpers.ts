export function generateMockNFTMember(id: number, name: string, membershipLevel: string) {
    return {
        id,
        name,
        membershipLevel,
        joinedAt: new Date().toISOString(),
    };
}

export function validateMembershipLevel(level: string): boolean {
    const validLevels = ["Silver", "Gold", "Platinum"];
    return validLevels.includes(level);
}

export function formatDate(date: Date): string {
    return date.toISOString().split("T")[0]; // Returns YYYY-MM-DD format
}
