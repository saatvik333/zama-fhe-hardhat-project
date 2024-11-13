
# Zama FHEVM Hardhat Test

### Setup
Copy the example environment variables file and install the dependencies:

```bash
cp .env.example .env
pnpm install
```

### Run
Start a local fhEVM docker compose that inlcudes everything needed to deploy FHE encrypted smart contracts using:

```bash
pnpm fhe:start
```

### Stop
Stop the fhEVM docker compose:

```bash
pnpm fhe:stop
```
