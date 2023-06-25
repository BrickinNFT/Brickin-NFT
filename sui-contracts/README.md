## Command: Publish the smart contractors

### Publish

The publishing action can be done under the sui project package, executable command:

```bash
sui client publish --gas-budget 300000000
```

## Command: Preparatory Work

### Define the variables

Define the variables in `Terminal` for testing usage, below is sample, please update the correct information when
testing from your end.

```bash
# Package ID of `test` .
COINPKG="0x9a55590557ecc733ab5e7c4e68af95196da3d2fd030bfd4c704002667d8d4ed5"
CNYA="0x9a55590557ecc733ab5e7c4e68af95196da3d2fd030bfd4c704002667d8d4ed5::cnya::CNYA"
CNYACAP="0x5f08b2ff8ed285888696b0feab84fc247e74a39b24e327ea1fa9de323874c30a"
CNYU="0x9a55590557ecc733ab5e7c4e68af95196da3d2fd030bfd4c704002667d8d4ed5::cnyu::CNYU"
CNYUCAP="0x35b0d420e5b793dc4f831015b0d319b56e46789d8f338a79a853acd680bb8d11"
CNYW="0x9a55590557ecc733ab5e7c4e68af95196da3d2fd030bfd4c704002667d8d4ed5::cnyw::CNYW"
CNYWCAP="0x11cc17a6a2ac3c3994d735d76f6e4ffd9dc7c3e1471a35a94b7502bcb17c6b75"
NFTTYPE="0x9a55590557ecc733ab5e7c4e68af95196da3d2fd030bfd4c704002667d8d4ed5::nft_driver::NFT"
# Package ID of `brickin-pool`
SWAPPKG="0x83c7992590d3674d6b41ee4ece54400ad58f4c1129d847372f51bb031751fadd"
```

### Mint the coins

Calling the function `mint_coin` to mint the coins `CNYA`, `CNYU`, `CNYW`.

```rust
    /// Sample function from module cnya
    public entry fun mint_coin(
        cap: &mut TreasuryCap<CNYA>, 
        amount: u64, 
        ctx: &mut TxContext) 
```
sui client command:

```zsh
sui client call --package $COINPKG\
                --module cnyu \
                --function mint_coin \
                --gas-budget 100000000 \
                --args $CNYUCAP 1000000000000
```

### Mint one NFT

NFT can be minted from `mint_nft` in module `nft_driver`.

```rust
    public entry fun mint_nft(
        name: String, 
        url: String, 
        ctx: &mut TxContext)
```

sui client command:
```zsh
sui client call --package $COINPKG\
                --module nft_driver \
                --function mint_nft \
                --gas-budget 100000000 \
                --args 'NFT' "INITURL"
```

### Generate the Swap pool

Please pass the type arguments and required parameters to this function `create_pair_nft_trade_pool`

```rust
    public entry fun create_pair_nft_trade_pool<X, Y, Z>(
        account: address,
        collection: vector<u8>,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        ctx: &mut TxContext,
    )
```
sui client command:

```zsh
sui client call --package $SWAPPKG 
                --module brickin 
                --function create_pair_nft_trade_pool 
                --gas-budget 100000000 \
                --args 0x7ca598a4eb9a9aea07720bb18e3fad68581f6712ab5517b798cc12c9edcc303f "Collection" "1TO1" 1 100000000 25000000000\
                --type-args $CNYA $CNYU $CNYW
```

### Generate the Kiosk/NftHolderOwner

Kiosk is used to hold the NFT items, it is a shared objects.

```rust
    public fun create_kiosk(ctx: &mut TxContext):(ID, ID)
```
sui client command:
```zsh
sui client call --package $SWAPPKG \
                --module trading \
                --function create_kiosk \
                --gas-budget 100000000
```

NftHolderOwner is voucher transferred to the NFT owner who pledges the NFT.

```rust
    public fun init_nftholder(ctx: &mut TxContext) 
```
sui client command:
```zsh
sui client call --package $SWAPPKG \
                --module brickin \
                --function init_nftholder \
                --gas-budget 100000000 
```

### Define variables for IDs of pool, kiosk and NftHolderOwner

```zsh
POOLID="0xea12c7acbc160ddc420e6eda677480e162edda1d136cfb39af83e00138c57433"
HOLDERID="0x8a77b718ca0b92829142d007f155a2847cf3b71fc70bb7fd8181a6b5ad94ee42"
KIOSKID="0x8105ea6b6891e16fb3bdfcd531287c662b755f0cf35792cf7e5379562aa24262"
```

### Transfer balance to the Pool

Before execute the swap actions, please increase the balance from Coins you had minted.

```rust
    public fun update_balance<X, Y, Z>(
        trade_pool: &mut TradePool<X, Y, Z>,
        coin_x: Coin<X>,
        coin_y: Coin<Y>,
        coin_z: Coin<Z>,
        ctx: &mut TxContext): address
```
sui client command:
```zsh
sui client call --package $SWAPPKG \
                  --module brickin \
                  --function update_balance \
                  --gas-budget 100000000 \
                  --args $POOLID \
                         0xe05c44dbdc70149acfbd08de779804e2a23def958978223f2363ab7d40fcffd1 \
			             0x5f7b0fe8dbf0ecb1d6c876991c79993c050c780b8c99a327c772ae9d6c237e6a \
                         0xcfbc55f2976604dad0a1e2b76ed869732dae5b17ca07c243bef3ae85bd043339 \
                  --type-args $CNYA $CNYU $CNYW
```

## Command: SWAP NFT and Coins

### Deposit the NFT and swap coins

The function `swap_coin_for_nfts` required to pass 5 type arguments, except the three Coin types that was held in swap
pool with balance,
we need also pass the coin type as 4th argument that you want to swap from the pool, the last one is the NFT type you
want to deposit.

```rust
    public entry fun swap_coin_for_nfts<X, Y, Z, TCOIN, NFT: key + store>(
        trade_pool: &mut TradePool<X, Y, Z>,
        nft: NFT,sss
        kiosk: &mut Kiosk,
        amount: u64,
        payment: Coin<SUI>,
        nftholderOwner: NftHolderOwner,
        ctx: &mut TxContext): bool
```

```bash
sui client call --package $SWAPPKG \
                --module brickin \
                --function swap_coin_for_nfts \
                --gas-budget 100000000 \
                --args $POOLID \
                       0x19186d1a3568a7b26accba24f4cc8e5226ed96a8ea597c19dac49c3c866f3334 \
			           $KIOSKID 2000000000 \
                       0xe336efde9a74a096e4fbc83fb8f4456e7320ffe2daf5f19ea8ae96f7dc4aa310 $HOLDERID \
                --type-args $CNYA $CNYU $CNYW $CNYA $NFTTYPE
```

### Withdraw the NFT with coin

Three functions are provided to withdraw the NFT with corresponding coin type:
- `withdraw_nft_from_x`: withdraw the NFT by Coin X
- `withdraw_nft_from_y`: withdraw the NFT by Coin Y
- `withdraw_nft_from_z`: withdraw the NFT by Coin Z

Sample function:

```rust
    public fun withdraw_nft_from_x<X, Y, Z, NFT: key + store>(
        trade_pool: &mut TradePool<X, Y, Z>,
        nft_id: ID,
        kiosk: &mut Kiosk,
        amount: u64,
        payment: Coin<SUI>,
        coin_x: Coin<X>,
        nftholderOwner: NftHolderOwner,
        ctx: &mut TxContext): bool
```

sui client command:

```zsh
sui client call --package $SWAPPKG \
                  --module brickin \
                  --function withdraw_nft_from_y \
                  --gas-budget 100000000 \
                  --args $POOLID \
                         0x19186d1a3568a7b26accba24f4cc8e5226ed96a8ea597c19dac49c3c866f3334 \
			             $KIOSKID 3000000000 \
                         0xe336efde9a74a096e4fbc83fb8f4456e7320ffe2daf5f19ea8ae96f7dc4aa310 \
			             0x6ce1d7354d3fb5ed5b5b1e0ef0865274d0b915f370ea8d6fd1ecb89417a53b06 \
                         $HOLDERID \
                  --type-args $CNYA $CNYU $CNYW $NFTTYPE
```