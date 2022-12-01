# Unsafe delegatecall vulnerability

delegatecall is a low level function that executes callee code within caller context. For using delegate call, you must keep in mind next two things:

    1. delegate call preserves caller context.
    2. storage layout must be the same for caller and callee.

For example, let's say we have 2 SC, A and B, and A uses delegatecall to call B:

    A --> B: Runs B's code inside A's context (storage, msg.sender, msg.value, msg.data, etc.)

## Reproduction

### 📜 Involves one smart contract.

    1. A vulnerable contract that makes unsafe delegatecalls and could get hijacked.

## How to prevent it

👁️ TBD
