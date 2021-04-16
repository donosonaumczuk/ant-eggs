# ant-eggs

- A game in which anyone can buy Ant Eggs with ETH. Eggs are non-divisible transferable ERC20 tokens (1 EGG == 0.01 ETH).
- An egg can be used to create an Ant. Ants should be transferable ERC721 tokens (NFTs).
- 1 Ant can create at most 1 Egg every 10 minutes.
- There is a luck factor when an Ant hatches that determines how many eggs can that ant produce (in this implementation that number can go from 0 to 99, calculated as current block hash modulus 100).
- Ants have a % of chance of dying when creating eggs (in this implementation the ant dies if the last two digits of block number are equals to the last two digits of the ant id).