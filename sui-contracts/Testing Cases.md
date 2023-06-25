## Testing Cases

### Define the variables

定义下面变量，以下均为实际测试用例：

```shell
SWAPPKG="0xcb89165d37f7285f02031d29da95351cc096939484a492ea6e796d7df00101c7"
CNYA="0xcb89165d37f7285f02031d29da95351cc096939484a492ea6e796d7df00101c7::cnya::CNYA"
CNYACAP="0xd23d5987b9c93a1348cca68b99d1635685b8645f26865c68d1205c756b9b5f47"
CNYU="0xcb89165d37f7285f02031d29da95351cc096939484a492ea6e796d7df00101c7::cnyu::CNYU"
CNYUCAP="0xc0b994df490b97ba639e81b30ee322d77458fcaeaf4aa06436de7d7aca0cf5bd"
CNYW="0xcb89165d37f7285f02031d29da95351cc096939484a492ea6e796d7df00101c7::cnyw::CNYW"
CNYWCAP="0x7715bad3286d98e498a730341e830707a3839e499205bbd7cc071b0a2927006d"
NFTTYPE="0xcb89165d37f7285f02031d29da95351cc096939484a492ea6e796d7df00101c7::nft_driver::NFT"
POOLID="0x768cf12322100bfa4f95502d89cceacfe82b782e6b9dc5a0359a58cfb8a0fcf1"
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

### Create Kiosk/NftHolderOwner

Call function `initialize_account` to create the `Kiosk` and `NftHolderOwner` for pocket address.
This function can return 3 IDs after execution, the first ID is `Kiosk` ID and second one is `NftHolderOwner` ID.

**So it can define another two variables `KIOSKID` and `HOLDERID`.

```shell
sui client call --package $SWAPPKG \
                --module brickin \
                --function initialize_account \
                --gas-budget 100000000 
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
                       $NFTID $KIOSKID 2000000000 \
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
                         $NFTID $KIOSKID 3000000000 \
                         0xe336efde9a74a096e4fbc83fb8f4456e7320ffe2daf5f19ea8ae96f7dc4aa310 \
			             $COINCNYUID \
                         $HOLDERID \
                  --type-args $CNYA $CNYU $CNYW $NFTTYPE
```