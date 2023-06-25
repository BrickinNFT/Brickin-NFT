module brickin::brickin {
    use std::ascii::into_bytes;
    use std::string::{Self, String, append_utf8};
    use std::type_name::{get, into_string};

    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::kiosk::Kiosk;
    use sui::object::{Self, UID, ID};
    use sui::sui::SUI;
    use sui::table::{Self, Table};
    use sui::transfer::{Self, transfer, public_transfer};
    use sui::tx_context::{TxContext, sender};

    use brickin::trading;

    const ENotEnoughFeeToPay: u64 = 1001;
    const ETransactionCoinNotInPool: u64 = 1002;
    const ENotEnoughCoinX: u64 = 1003;
    const ENotEnoughCoinY: u64 = 1004;
    const ENotEnoughCoinZ: u64 = 1005;
    const ENotEnoughTrsanctionCoin: u64 = 1006;

    struct NftHolder has store, drop {
        nft_id: ID,
        kiosk_id: ID,
        pool_id: ID,
        transaction_amount: u64,
        transaction_coin: String,
    }

    struct NftHolderOwner has key, store {
        id: UID,
        nftholder: Table<ID, ID>
    }

    struct TradePool<phantom X, phantom Y, phantom Z> has key, store {
        id: UID,
        account: address,
        collection: vector<u8>,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        nft_num: u64,
        coin_sui: Balance<X>,
        coin_stable: Balance<Y>,
        coin_self: Balance<Z>,
        nfts: Table<ID, NftHolder>,
    }

    public entry fun create_pair_nft_trade_pool<X, Y, Z>(
        account: address,
        collection: vector<u8>,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        ctx: &mut TxContext,
    ) {
        let new_pool = TradePool<X, Y, Z> {
            id: object::new(ctx),
            account,
            collection,
            curve_type,
            delta,
            fee,
            init_price,
            nft_num: 0,
            coin_sui: balance::zero(),
            coin_stable: balance::zero(),
            coin_self: balance::zero(),
            nfts: table::new(ctx),
        };
        transfer::share_object(new_pool);
    }

    public fun init_nftholder(ctx: &mut TxContext) {
        let nftholderOwner = NftHolderOwner {
            id: object::new(ctx),
            nftholder: table::new<ID, ID>(ctx),
        };
        transfer(nftholderOwner, sender(ctx));
    }

    public fun update_balance<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>,
                                       coin_x: Coin<X>,
                                       coin_y: Coin<Y>,
                                       coin_z: Coin<Z>,
                                       ctx: &mut TxContext): address {
        coin::put(&mut trade_pool.coin_sui, coin_x);
        coin::put(&mut trade_pool.coin_stable, coin_y);
        coin::put(&mut trade_pool.coin_self, coin_z);
        let addr = sender(ctx);
        addr
    }


    public entry fun swap_coin_for_nfts<X, Y, Z, TCOIN, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                                          nft: NFT,
                                                                          kiosk: &mut Kiosk,
                                                                          amount: u64,
                                                                          payment: Coin<SUI>,
                                                                          nftholderOwner: NftHolderOwner,
                                                                          ctx: &mut TxContext): bool {
        assert!(coin::value(&payment) >= trade_pool.fee, ENotEnoughFeeToPay);
        assert!(
            get<TCOIN>() == get<X>() || get<TCOIN>() == get<Y>() || get<TCOIN>() == get<Y>(),
            ETransactionCoinNotInPool
        );
        public_transfer(coin::split(&mut payment, trade_pool.fee, ctx), trade_pool.account);
        public_transfer(payment, sender(ctx));
        let nft_id = object::id(&nft);
        let kiosk_id = object::id(kiosk);
        let pool_id = object::id(trade_pool);
        let coin_str = string::utf8(b"");
        append_utf8(&mut coin_str, into_bytes(into_string(get<TCOIN>())));
        table::add(&mut nftholderOwner.nftholder, nft_id, pool_id);
        transfer(nftholderOwner, sender(ctx));
        table::add(&mut trade_pool.nfts, nft_id, NftHolder {
            nft_id,
            kiosk_id,
            pool_id,
            transaction_amount: amount,
            transaction_coin: coin_str
        });
        let nft_num = &mut trade_pool.nft_num;
        *nft_num = *nft_num + 1;
        trading::deposit_nft<NFT>(kiosk, nft, ctx);
        if (get<TCOIN>() == get<X>()) {
            assert!(balance::value(&trade_pool.coin_sui) >= amount, ENotEnoughCoinX);
            let coin_x = coin::zero<X>(ctx);
            coin::join(&mut coin_x, coin::take<X>(&mut trade_pool.coin_sui, amount, ctx));
            public_transfer(coin_x, sender(ctx));
        };
        if (get<TCOIN>() == get<Y>()) {
            assert!(balance::value(&trade_pool.coin_sui) >= amount, ENotEnoughCoinX);
            let coin_y = coin::zero<Y>(ctx);
            coin::join(&mut coin_y, coin::take<Y>(&mut trade_pool.coin_stable, amount, ctx));
            public_transfer(coin_y, sender(ctx));
        };
        if (get<TCOIN>() == get<Z>()) {
            assert!(balance::value(&trade_pool.coin_sui) >= amount, ENotEnoughCoinX);
            let coin_z = coin::zero<Z>(ctx);
            coin::join(&mut coin_z, coin::take<Z>(&mut trade_pool.coin_self, amount, ctx));
            public_transfer(coin_z, sender(ctx));
        };
        true
    }

    /*
    public entry fun swap_sui_for_nfts<X, Y, Z>(
        trade_pool: &mut TradePool<X, Y, Z>,
        coin_sui: &mut Coin<X>,
        ctx: &mut TxContext
    ): bool {
        // let pool = borrow_global_mut<TradePool>(trade_pool_address);
        // let price_per_nft = pool.init_price;
        // let nft_amount_to_buy = amount_of_coins / price_per_nft;

        // let nfts_in_pool = Vector::length(&pool.nfts);


        // if (nft_amount_to_buy > nfts_in_pool) {
        //     return false;
        // }

        // let mut i = 0;
        // while (i < nft_amount_to_buy) {
        //     let nft = Vector::pop_back(&mut pool.nfts);
        //     i = i + 1;
        // }

        true
    }

    public entry fun swap_stable_coin_for_nfts<X, Y, Z>(
        trade_pool: &mut TradePool<X, Y, Z>,
        coin_stable: &mut Coin<Y>,
        ctx: &mut TxContext
    ): bool {
        // let pool = borrow_global_mut<TradePool>(trade_pool_address);
        // let price_per_nft = pool.init_price;
        // let nft_amount_to_buy = amount_of_coins / price_per_nft;

        // let nfts_in_pool = Vector::length(&pool.nfts);


        // if (nft_amount_to_buy > nfts_in_pool) {
        //     return false;
        // }

        // let mut i = 0;
        // while (i < nft_amount_to_buy) {
        //     let nft = Vector::pop_back(&mut pool.nfts);
        //     i = i + 1;
        // }

        true
    }

    public entry fun swap_self_coin_for_nfts<X, Y, Z>(
        trade_pool: &mut TradePool<X, Y, Z>,
        coin_self: &mut Coin<Z>,
        ctx: &mut TxContext
    ): bool {
        // let pool = borrow_global_mut<TradePool>(trade_pool_address);
        // let price_per_nft = pool.init_price;
        // let nft_amount_to_buy = amount_of_coins / price_per_nft;

        // let nfts_in_pool = Vector::length(&pool.nfts);


        // if (nft_amount_to_buy > nfts_in_pool) {
        //     return false;
        // }

        // let mut i = 0;
        // while (i < nft_amount_to_buy) {
        //     let nft = Vector::pop_back(&mut pool.nfts);
        //     i = i + 1;
        // }

        true
    }


    */
    // TODO: swap NFT for three types.

    fun increase_pool_balance<T>(self: &mut Balance<T>,
                                 balance: Balance<T>) {
        balance::join(self, balance);
    }

    // Only Owner
    public fun withdraw_nft_from_x<X, Y, Z, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                              nft_id: ID,
                                                              kiosk: &mut Kiosk,
                                                              amount: u64,
                                                              payment: Coin<SUI>,
                                                              coin_x: Coin<X>,
                                                              nftholderOwner: NftHolderOwner,
                                                              ctx: &mut TxContext): bool {
        assert!(coin::value(&payment) >= trade_pool.fee, ENotEnoughFeeToPay);
        assert!(coin::value(&coin_x) >= amount, ENotEnoughTrsanctionCoin);
        public_transfer(coin::split(&mut payment, trade_pool.fee, ctx), trade_pool.account);
        public_transfer(payment, sender(ctx));
        let _pool_id = table::remove(&mut nftholderOwner.nftholder, nft_id);
        let _nftholder = table::remove(&mut trade_pool.nfts, nft_id);
        transfer(nftholderOwner, sender(ctx));
        let nft_num = &mut trade_pool.nft_num;
        *nft_num = *nft_num - 1;
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
        let coin_x_in = coin::split<X>(&mut coin_x, amount, ctx);
        coin::put(&mut trade_pool.coin_sui, coin_x_in);
        public_transfer(coin_x, sender(ctx));
        true
    }

    public fun withdraw_nft_from_y<X, Y, Z, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                              nft_id: ID,
                                                              kiosk: &mut Kiosk,
                                                              amount: u64,
                                                              payment: Coin<SUI>,
                                                              coin_y: Coin<Y>,
                                                              nftholderOwner: NftHolderOwner,
                                                              ctx: &mut TxContext): bool {
        assert!(coin::value(&payment) >= trade_pool.fee, ENotEnoughFeeToPay);
        assert!(coin::value(&coin_y) >= amount, ENotEnoughTrsanctionCoin);
        public_transfer(coin::split(&mut payment, trade_pool.fee, ctx), trade_pool.account);
        public_transfer(payment, sender(ctx));
        let _pool_id = table::remove(&mut nftholderOwner.nftholder, nft_id);
        let _nftholder = table::remove(&mut trade_pool.nfts, nft_id);
        transfer(nftholderOwner, sender(ctx));
        let nft_num = &mut trade_pool.nft_num;
        *nft_num = *nft_num - 1;
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
        let coin_y_in = coin::split<Y>(&mut coin_y, amount, ctx);
        coin::put(&mut trade_pool.coin_stable, coin_y_in);
        public_transfer(coin_y, sender(ctx));
        true
    }

    public fun withdraw_nft_from_z<X, Y, Z, NFT: key + store>(trade_pool: &mut TradePool<X, Y, Z>,
                                                              nft_id: ID,
                                                              kiosk: &mut Kiosk,
                                                              amount: u64,
                                                              payment: Coin<SUI>,
                                                              coin_z: Coin<Z>,
                                                              nftholderOwner: NftHolderOwner,
                                                              ctx: &mut TxContext): bool {
        assert!(coin::value(&payment) >= trade_pool.fee, ENotEnoughFeeToPay);
        assert!(coin::value(&coin_z) >= amount, ENotEnoughTrsanctionCoin);
        public_transfer(coin::split(&mut payment, trade_pool.fee, ctx), trade_pool.account);
        public_transfer(payment, sender(ctx));
        let _pool_id = table::remove(&mut nftholderOwner.nftholder, nft_id);
        let _nftholder = table::remove(&mut trade_pool.nfts, nft_id);
        transfer(nftholderOwner, sender(ctx));
        let nft_num = &mut trade_pool.nft_num;
        *nft_num = *nft_num - 1;
        trading::withdraw_nft<NFT>(kiosk, nft_id, ctx);
        let coin_z_in = coin::split<Z>(&mut coin_z, amount, ctx);
        coin::put(&mut trade_pool.coin_self, coin_z_in);
        public_transfer(coin_z, sender(ctx));
        true
    }
    /*
    // Only Owner
    public fun withdraw_coin<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, coin_type: u64, ctx: &mut TxContext): bool {
        true
    }*/
}