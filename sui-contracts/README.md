## Mapping: Deapp and sui contracts

### Create the Kiosk

`Kiosk` is provided by standard sui, is a primitive for building open, zero-fee trading platforms with a high degree of customization over transfer policies.

### Create the Pool

Call function `create_pair_nft_trade_pool` to generate the Trading Pool, 5 type-args need to be passed:
- X, Y, Z: coin types held in the pool with balance
- T: transaction coin type
- NFT: NFT type

```rust
public entry fun create_pair_nft_trade_pool<X, Y, Z, T, NFT: key + store>(
        collection: &mut Kiosk,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        nft: NFT,
        ctx: &mut TxContext,
    ) :ID
```

#### 1. Click on `NFT Trade Pool`

![Create](images/create.png)

#### 2. Pass `Kiosk` ID and `Coin Type` to below fields:

![Collection and coin](images/Collection and Coin.png)

`NFT` filed matches `collection`, and `Coin` field matches type argument `T`.

#### 3. Confirm and Create the Pool

![Confirm](images/confirm.png)

Follow below mapping table to pass value to parameters:

| Page field         | Parameter    |
|:-------------------|:-------------|
| `Start Price`      | `init_price` |
| `Bonding Curve`    | `curve_type` |
| `Start Delta`      | `delta`      |
| `Pool Trading Fee` | `fee`        |
| `Add Items`        | `nft`        |

#### 4. Other Parameters

`X`, `Y`, `Z` and `NFT` must be passed when calling the function.

## Testing Cases

### Publish

The publishing action can be done under the sui project package, executable command:

```bash
sui client publish --gas-budget 300000000
```

### Define the variables

Define the variables, below are real testing cases:
定义变量，以下均为实际测试用例：

```shell
SWAPPKG="0x4069e2f456c6fe69bfc6c35bc33b6caee8a786a8f73e0878b7f8ae046655fc26"
CNYA="0x4069e2f456c6fe69bfc6c35bc33b6caee8a786a8f73e0878b7f8ae046655fc26::cnya::CNYA"
CNYACAP="0x97812260131455b0f588fcba4ec267537fc9dab04c9ebcef2fb194f689134455"
CNYU="0x4069e2f456c6fe69bfc6c35bc33b6caee8a786a8f73e0878b7f8ae046655fc26::cnyu::CNYU"
CNYUCAP="0xa05bdfca8fa35c35732fc0475fc3dbb5760b64f68cc493339d05af6078f50112"
CNYW="0x4069e2f456c6fe69bfc6c35bc33b6caee8a786a8f73e0878b7f8ae046655fc26::cnyw::CNYW"
CNYWCAP="0x62e876fd67e7fe6b296c6ce4b9144134e504110041cf654f3e99b3f8eca806ca"
NFTTYPE="0x4069e2f456c6fe69bfc6c35bc33b6caee8a786a8f73e0878b7f8ae046655fc26::nft_driver::NFT"
```

### Mint Coins for Pocket Address 给钱包地址 Mint 代币

All mint functions can return the Coin ID, so variable `COINID` could be defined.

#### Mint CNYA

```shell
sui client call --package $SWAPPKG\
		        --module cnya \
		        --function mint_coin \
		        --gas-budget 100000000 \
		        --args $CNYACAP 1000000000000
```

#### Mint CNYU

```shell
sui client call --package $SWAPPKG\
		        --module cnyu \
		        --function mint_coin \
	        	--gas-budget 100000000 \
	        	--args $CNYUCAP 1000000000000
```

#### Mint CNYW

```shell
sui client call --package $SWAPPKG\
		        --module cnyw \
		        --function mint_coin \
		        --gas-budget 100000000 \
		        --args $CNYWCAP 1000000000000
```

### Create Kiosk

Call function `initialize_account` to create the `Kiosk`, which is collection of NFTs.
This function can return `Kiosk` IDs after execution

**So it can define another variable `KIOSKID`**.

```shell
sui client call --package $SWAPPKG \
                --module brickin \
                --function initialize_account \
                --gas-budget 100000000 
```

```shell
KIOSKID="0x36bed25dffef21dfb525f022aa3380f68f6e5e06066331f8bcf50d343a71b4a7"
```

### Mint the NFT for pocket address.

Call function `mint_nft` in module `nft_driver` to mint one NFT for pocket address.
The function can return the NFT ID.

```shell
sui client call --package $SWAPPKG\
                --module nft_driver \
                --function mint_nft \
                --gas-budget 100000000 \
                --args 'NFT' "INITURL"
```
```shell
NFTID="0x9da2d45f9cb5127e6fce879a1e3d29f16e06f8561ad8cd257f370088e4bcec05"
```

### Generate the Trading Pool

Call function `create_pair_nft_trade_pool` to generate the Trading Pool, 5 type-args need to be passed:
- X, Y, Z: coin types held in the pool with balance
- T: transaction coin type
- NFT: NFT type

The function will return ID of trading pool.

```rust
public entry fun create_pair_nft_trade_pool<X, Y, Z, T, NFT: key + store>(
        collection: &mut Kiosk,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        nft: NFT,
        ctx: &mut TxContext,
    ) :ID
```

```shell
sui client call --package $SWAPPKG\
		        --module brickin \
                --function create_pair_nft_trade_pool \
                --gas-budget 100000000 \
                --args $KIOSKID "L" 1 100000000 25000000000 $NFTID\
                --type-args $CNYA $CNYU $CNYW 0x2::sui::SUI $NFTTYPE
```

```shell
POOLID="0x46da550175e79bc74f00d2f916eeb7ffb764d98a8f172e0f2ce785683634c2df"
```

### Deposit the NFT

Deposit the NFT without coin transactions.

```shell
sui client call --package $SWAPPKG\
                --module brickin \
                --function deposit_nft \
                --gas-budget 100000000\
                --args $KIOSKID $NFTID \
                --type-args $NFTTYPE
```

### Deposit the NFT and swap coins

Below are the functions to swap a NFT by depositing different coins:

- swap_sui_coin_for_nfts
- swap_stable_coin_for_nfts
- swap_self_coin_for_nfts

Let's take `swap_stable_coin_for_nfts` as an example, it required to pass 5 type arguments:
- X, Y, Z: coin types held in the pool with balance
- T: transaction Coin type
- NFT: NFT type.

```bash
sui client call --package $SWAPPKG \
                --module brickin \
                --function swap_stable_coin_for_nfts \
                --gas-budget 100000000 \
                --args $POOLID \
                       $KIOSKID $NFTID \
                       0x5e64e47f09b4d61af4f994d5d8206a159c938f1919cac1e7cd2bf10f80f544f6  \
                       0x2650f72b9667c67d7774c61bec52bf55fb8dd96ef8478ee718bc95ed40bd7130  \
                --type-args $CNYA $CNYU $CNYW 0x2::sui::SUI $NFTTYPE
```

### Withdraw the NFT with coin

`withdraw_coin` can withdraw the coin from trading pool by depositing the NFT.
6 type arguments:
- X, Y, Z: coin types held in the pool with balance
- T: transaction coin type
- TCOIN: coin type that swap out
- NFT: NFT type

```rust
public fun withdraw_coin<X, Y, Z, T, TCOIN, NFT: key + store>(
        trade_pool: &mut TradePool<X, Y, Z>,
        kiosk: &mut Kiosk,
        nft: NFT,
        payment: Coin<T>,
        ctx: &mut TxContext) 
```

sui client command:

```zsh
sui client call --package $SWAPPKG \
                  --module brickin \
                  --function withdraw_coin \
                  --gas-budget 100000000 \
                  --args $POOLID \
                         $KIOSKID 0x6f4ed64655d4c4b2a0df162931841cf37c89acebc652f0928540917794529ac8 \
                         0xe336efde9a74a096e4fbc83fb8f4456e7320ffe2daf5f19ea8ae96f7dc4aa310 \
                  --type-args $CNYA $CNYU $CNYW 0x2::sui::SUI $CNYU $NFTTYPE
```