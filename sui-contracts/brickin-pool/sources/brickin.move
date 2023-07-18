module brickin::brickin {
    use std::type_name::get;

    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin, into_balance};
    use sui::kiosk::Kiosk;
    use sui::object::{Self, UID, ID};
    use sui::sui::SUI;
    use sui::transfer::{Self, public_transfer};
    use sui::tx_context::{TxContext, sender};

    use brickin::trading;

    /// Error code for Not Enough payment
    const ENotEnoughFeeToPay: u64 = 1001;
    /// Error code for Not Enough Coin X
    const ENotEnoughCoinX: u64 = 1002;
    /// Error code for Not Enough Coin Y
    const ENotEnoughCoinY: u64 = 1003;
    /// Error code for Not Enough Coin Z
    const ENotEnoughCoinZ: u64 = 1004;
    /// Error code for Not Enough balance in pool to swap
    const ENotEnoughBalanceInPool: u64 = 1005;
    /// Kiosk not in Trading Pool
    const ECollectionNotInTradingPool: u64 = 1006;
    /// Error Code for not Enough Coin X to swap
    const ENotEnoughCoinXToSwap: u64 = 1007;
    /// Error Code for not Enough Coin Y to swap
    const ENotEnoughCoinYToSwap: u64 = 1008;
    /// Error Code for not Enough Coin Z to swap
    const ENotEnoughCoinZToSwap: u64 = 1009;
    /// Error Code for Transaction Coin Not in Pool
    const ETransactionCoinNotInPool: u64 = 1010;

    /// Trading Pool for swap
    /// account: the address to receive the fee paied by transaction maker
    /// collection: collection holds the NFT items
    /// curve_type
    /// delta: price delta
    /// fee: fee of transactions, transaction maker pays it and send to address
    /// init_price: NFT initialize price
    /// coin_sui, coin_stable, coin_self: balance of coin X,Y,Z
    /// SUI: 0x2::sui::SUI
    struct TradePool<phantom X, phantom Y, phantom Z> has key, store {
        id: UID,
        account: address,
        collection: ID,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        coin_sui: Balance<X>,
        coin_stable: Balance<Y>,
        coin_self: Balance<Z>,
    }

    /// generate the trading pool after deposit the NFTs
    public entry fun create_pair_nft_trade_pool<X, Y, Z, NFT: key + store>(
        collection: &mut Kiosk,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        nft: NFT,
        ctx: &mut TxContext,
    ): ID {
        deposit_nft(collection, nft, ctx);
        let new_pool = TradePool<X, Y, Z> {
            id: object::new(ctx),
            account: sender(ctx),
            collection: object::id(collection),
            curve_type,
            delta,
            fee,
            init_price,
            coin_sui: balance::zero(),
            coin_stable: balance::zero(),
            coin_self: balance::zero(),
        };
        let pool_id = object::id(&new_pool);
        transfer::share_object(new_pool);
        pool_id
    }

    /// Create Kiosk
    public entry fun generate_kiosk(ctx: &mut TxContext): ID {
        let kiosk_id = trading::create_kiosk(ctx);
        kiosk_id
    }

    /// Function to deposit the NFT to Kiosk
    public fun deposit_nft<NFT: key + store>(kiosk: &mut Kiosk,
                                             nft: NFT,
                                             ctx: &mut TxContext) {
        trading::deposit_nft(kiosk, nft, ctx);
    }

    /// Function to pay the fee
    fun pay<T>(payment: Coin<T>, amount: u64, reciptant: address, ctx: &mut TxContext) {
        assert!(coin::value(&payment) >= amount, ENotEnoughFeeToPay);
        public_transfer(coin::split(&mut payment, amount, ctx), reciptant);
        public_transfer(payment, sender(ctx));
    }

    /// Split the balance of `T` from Pool
    /// and send to transaction maker when swap the NFT in
    fun split_from_balance<T>(self: &mut Balance<T>, amount: u64, ctx: &mut TxContext) {
        assert!(balance::value(self) >= amount, ENotEnoughBalanceInPool);
        let coin_t = coin::zero<T>(ctx);
        coin::join(&mut coin_t, coin::take<T>(self, amount, ctx));
        public_transfer(coin_t, sender(ctx));
    }

    /// Add the balance of `T` into pool
    /// after swap the NFT out
    fun add_to_balance<T>(self: &mut Balance<T>, coin_t: Coin<T>, amount: u64, ctx: &mut TxContext) {
        let coin_self_in = coin::split(&mut coin_t, amount, ctx);
        coin::put(self, coin_self_in);
        public_transfer(coin_t, sender(ctx));
    }

    /// Swap Coin X by NFTs
    public entry fun swap_sui_for_nfts<X, Y, Z, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                                  kiosk: &mut Kiosk,
                                                                  nft_id: ID,
                                                                  payment: Coin<SUI>,
                                                                  coin_sui: Coin<X>,
                                                                  ctx: &mut TxContext
    ) {
        assert!(coin::value(&coin_sui) >= trade_pool.init_price, ENotEnoughCoinX);
        assert!(object::id(kiosk) == trade_pool.collection, ECollectionNotInTradingPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
        add_to_balance<X>(&mut trade_pool.coin_sui, coin_sui, trade_pool.init_price, ctx);
    }

    /// Swap Coin Y by NFTs
    public entry fun swap_stable_coin_for_nfts<X, Y, Z, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                                          kiosk: &mut Kiosk,
                                                                          nft_id: ID,
                                                                          payment: Coin<SUI>,
                                                                          coin_stable: Coin<Y>,
                                                                          ctx: &mut TxContext
    ) {
        assert!(coin::value(&coin_stable) >= trade_pool.init_price, ENotEnoughCoinX);
        assert!(object::id(kiosk) == trade_pool.collection, ECollectionNotInTradingPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
        add_to_balance<Y>(&mut trade_pool.coin_stable, coin_stable, trade_pool.init_price, ctx);
    }

    /// Swap Coin Z by NFTs
    public entry fun swap_self_coin_for_nfts<X, Y, Z, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                                        kiosk: &mut Kiosk,
                                                                        nft_id: ID,
                                                                        payment: Coin<SUI>,
                                                                        coin_self: Coin<Z>,
                                                                        ctx: &mut TxContext
    ) {
        assert!(coin::value(&coin_self) >= trade_pool.init_price, ENotEnoughCoinX);
        assert!(object::id(kiosk) == trade_pool.collection, ECollectionNotInTradingPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
        add_to_balance<Z>(&mut trade_pool.coin_self, coin_self, trade_pool.init_price, ctx);
    }

    /// Withdraw the NFT by the person who deposited it.
    public entry fun withdraw_nft<X, Y, Z, T, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                                kiosk: &mut Kiosk,
                                                                nft_id: ID,
                                                                ctx: &mut TxContext) {
        assert!(object::id(kiosk) == trade_pool.collection, ECollectionNotInTradingPool);
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
    }

    /// Swap the Coin X, Y, Z by deposit the NFT to pool
    public fun withdraw_coin<X, Y, Z, TCOIN, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                               kiosk: &mut Kiosk,
                                                               nft: NFT,
                                                               payment: Coin<SUI>,
                                                               ctx: &mut TxContext) {
        assert!(
            get<TCOIN>() == get<X>() || get<TCOIN>() == get<Y>() || get<TCOIN>() == get<Z>(),
            ETransactionCoinNotInPool
        );
        assert!(object::id(kiosk) == trade_pool.collection, ECollectionNotInTradingPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        deposit_nft<NFT>(kiosk, nft, ctx);
        if (get<TCOIN>() == get<X>()) {
            split_from_balance<X>(&mut trade_pool.coin_sui, trade_pool.init_price, ctx);
        };
        if (get<TCOIN>() == get<Y>()) {
            split_from_balance<Y>(&mut trade_pool.coin_stable, trade_pool.init_price, ctx);
        };
        if (get<TCOIN>() == get<Z>()) {
            split_from_balance<Z>(&mut trade_pool.coin_self, trade_pool.init_price, ctx);
        };
    }

    public entry fun swap_x_to_y<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                          payment: Coin<SUI>,
                                          coin_in: Coin<X>,
                                          amount: u64,
                                          ctx: &mut TxContext) {
        assert!(coin::value(&coin_in) >= amount, ENotEnoughCoinXToSwap);
        assert!(balance::value(&trade_pool.coin_stable) >= amount, ENotEnoughBalanceInPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        let coin_out_x = coin::split(&mut coin_in, amount, ctx);
        balance::join(&mut trade_pool.coin_sui, into_balance(coin_out_x));
        let bal_out = balance::split(&mut trade_pool.coin_stable, amount);
        let coin_out = coin::from_balance(bal_out, ctx);
        transfer::public_transfer(coin_in, sender(ctx));
        transfer::public_transfer(coin_out, sender(ctx));
    }
    public entry fun swap_x_to_z<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                          payment: Coin<SUI>,
                                          coin_in: Coin<X>,
                                          amount: u64,
                                          ctx: &mut TxContext) {
        assert!(coin::value(&coin_in) >= amount, ENotEnoughCoinXToSwap);
        assert!(balance::value(&trade_pool.coin_self) >= amount, ENotEnoughBalanceInPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        let coin_out_x = coin::split(&mut coin_in, amount, ctx);
        balance::join(&mut trade_pool.coin_sui, into_balance(coin_out_x));
        let bal_out = balance::split(&mut trade_pool.coin_self, amount);
        let coin_out = coin::from_balance(bal_out, ctx);
        transfer::public_transfer(coin_in, sender(ctx));
        transfer::public_transfer(coin_out, sender(ctx));
    }
    public entry fun swap_y_to_x<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                          payment: Coin<SUI>,
                                          coin_in: Coin<Y>,
                                          amount: u64,
                                          ctx: &mut TxContext) {
        assert!(coin::value(&coin_in) >= amount, ENotEnoughCoinYToSwap);
        assert!(balance::value(&trade_pool.coin_sui) >= amount, ENotEnoughBalanceInPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        let coin_out_y = coin::split(&mut coin_in, amount, ctx);
        balance::join(&mut trade_pool.coin_stable, into_balance(coin_out_y));
        let bal_out = balance::split(&mut trade_pool.coin_stable, amount);
        let coin_out = coin::from_balance(bal_out, ctx);
        transfer::public_transfer(coin_in, sender(ctx));
        transfer::public_transfer(coin_out, sender(ctx));
    }
    public entry fun swap_y_to_z<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                          payment: Coin<SUI>,
                                          coin_in: Coin<Y>,
                                          amount: u64,
                                          ctx: &mut TxContext) {
        assert!(coin::value(&coin_in) >= amount, ENotEnoughCoinYToSwap);
        assert!(balance::value(&trade_pool.coin_self) >= amount, ENotEnoughBalanceInPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        let coin_out_y = coin::split(&mut coin_in, amount, ctx);
        balance::join(&mut trade_pool.coin_stable, into_balance(coin_out_y));
        let bal_out = balance::split(&mut trade_pool.coin_self, amount);
        let coin_out = coin::from_balance(bal_out, ctx);
        transfer::public_transfer(coin_in, sender(ctx));
        transfer::public_transfer(coin_out, sender(ctx));
    }
    public entry fun swap_z_to_x<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                          payment: Coin<SUI>,
                                          coin_in: Coin<Z>,
                                          amount: u64,
                                          ctx: &mut TxContext) {
        assert!(coin::value(&coin_in) >= amount, ENotEnoughCoinZToSwap);
        assert!(balance::value(&trade_pool.coin_sui) >= amount, ENotEnoughBalanceInPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        let coin_out_z = coin::split(&mut coin_in, amount, ctx);
        balance::join(&mut trade_pool.coin_self, into_balance(coin_out_z));
        let bal_out = balance::split(&mut trade_pool.coin_sui, amount);
        let coin_out = coin::from_balance(bal_out, ctx);
        transfer::public_transfer(coin_in, sender(ctx));
        transfer::public_transfer(coin_out, sender(ctx));
    }
    public entry fun swap_z_to_y<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                          payment: Coin<SUI>,
                                          coin_in: Coin<Z>,
                                          amount: u64,
                                          ctx: &mut TxContext) {
        assert!(coin::value(&coin_in) >= amount, ENotEnoughCoinZToSwap);
        assert!(balance::value(&trade_pool.coin_stable) >= amount, ENotEnoughBalanceInPool);
        pay(payment, trade_pool.fee, trade_pool.account, ctx);
        let coin_out_z = coin::split(&mut coin_in, amount, ctx);
        balance::join(&mut trade_pool.coin_self, into_balance(coin_out_z));
        let bal_out = balance::split(&mut trade_pool.coin_stable, amount);
        let coin_out = coin::from_balance(bal_out, ctx);
        transfer::public_transfer(coin_in, sender(ctx));
        transfer::public_transfer(coin_out, sender(ctx));
    }

    public entry fun increase_balance<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                               coin_x: Coin<X>,
                                               coin_y: Coin<Y>,
                                               coin_z: Coin<Z>,
                                               _ctx: &mut TxContext){
        balance::join(&mut trade_pool.coin_sui, coin::into_balance(coin_x));
        balance::join(&mut trade_pool.coin_stable, coin::into_balance(coin_y));
        balance::join(&mut trade_pool.coin_self, coin::into_balance(coin_z));
    }
}