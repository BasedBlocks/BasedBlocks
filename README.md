# BasedBlocks

Welcome to the official documentation of **BasedBlocks**, a gamified DeFi mining experience built on the Base network.

## Introduction

**BasedBlocks** is an ERC-20 token (symbol: `BBSV`) that can only be mined using Proof of Work (PoW) on the Base network. The project is a satirical response to the over-abundance of inflationary tokens and aims to provide a nostalgic, fair mining mechanism, especially for those who missed the early days of Bitcoin faucets and mining.

### Core Concepts

- **Token Symbol:** `BBSV` (BasedBlocksSatoshi Vision)
- **Total Supply:** 210,000,000 BBSV
- **Initial Block Reward:** 500 BBSV per block
- **Halving Interval:** Every 210,000 blocks

The design is inspired by Bitcoin's economics:
- 1st halving: 500 → 250
- 2nd halving: 250 → 125
- Continues up to 64 halvings...

---

## Layer Structure

BasedBlocks has a two-layered mining structure:

1. **Virtual Blocks (Off-Chain Layer):**
   - Each miner receives unique data to solve (proof input).
   - Proofs are validated off-chain via relayers.
   - Only claimed blocks are committed on-chain.
   - Offers a fair mining experience with an element of gamification.

2. **Based Blocks (On-Chain Layer):**
   - When a virtual block is claimed, it becomes a real on-chain block.
   - Tokens are minted and sent to the miner.
   - The main chain is formed from these validated blocks.

---

## Token Emission & Halvings

The reward per block decreases by half every 210,000 blocks, just like Bitcoin. Here’s how it breaks down:

| Halving | Block Range         | Reward per Block | Total Issued BBSV     |
|---------|---------------------|------------------|------------------------|
| 1st     | 0 – 209,999         | 500 BBSV         | 210,000 × 500 = 105,000,000 |
| 2nd     | 210,000 – 419,999   | 250 BBSV         | 210,000 × 250 = 52,500,000 |
| 3rd     | 420,000 – 629,999   | 125 BBSV         | 210,000 × 125 = 26,250,000 |
| 4th     | 630,000 – 839,999   | 62.5 BBSV        | 210,000 × 62.5 = 13,125,000 |
| 5th     | 840,000 – 1,049,999 | 31.25 BBSV       | 210,000 × 31.25 = 6,562,500  |

> This halving model continues for 64 cycles, progressively reducing emissions.

---

## Mining Cost and Inflation Control

- Users can generate unlimited virtual blocks.
- A block becomes “real” only upon claim (approx. $0.10 cost per claim).
- This cost disincentivizes instant token selling and stabilizes inflation.
- Block reward: **500 BBSV** (base level)

---

## Referral System

A built-in referral tree tracks each miner’s inviter. Whenever your referral mines a block, you receive referral points that are periodically converted into ETH. This:
- Helps grow the community
- Rewards early adopters with ETH (not BBSV)
- Has no inflationary impact on the tokenomics

---

## Mining Power Boost

Default reward per block is 500 BBSV.

## 📌 Summary

- Fair Mining Process
- Inflation Control
- Viral Referral System
- Gamified Level Boost

> Proof of Work can be fun. Mine. Claim. Be Based. 🚀

## 🌐 Quick Links

- 🌍 [Website](https://basedblocks.xyz) *(placeholder, replace with actual link)*
- 📄 [Whitepaper](https://basedblocks.xyz/whitepaper.pdf) *(placeholder)*
- 📣 [Twitter](https://twitter.com/minebasedblocks) *(placeholder)*
- 📣 [Medium](https://medium.com/@basedblocks/introducing-basedblocks-a-new-era-of-fair-gamified-mining-on-base-0ed299340ddb) *(placeholder)*

## 📜 License

MIT © BasedBlocks

