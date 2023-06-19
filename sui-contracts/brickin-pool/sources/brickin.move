module brickin::brickin {
    use 0x1::vector;
    use sui::coin::{Self, Coin};
    use sui::object::{Self, UID};
    use sui::transfer;
    use sui::balance::{Self, Supply, Balance};
    use sui::object_bag::{Self, ObjectBag};
    use sui::tx_context::{TxContext, sender};

    struct TradePool<phantom X, phantom Y, phantom Z> has key, store {
        id:UID,
        collection: vector<u8>,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        init_price: u64,
        nft_num: u64,
        collection_id: u64,
        coin_sui: Balance<X>,
        coin_stable: Balance<Y>,
        coin_self: Balance<Z>, 
        nfts: ObjectBag,
    }

    public entry fun create_pair_nft_trade_pool<X, Y, Z>(
        collection: vector<u8>,
        curve_type: vector<u8>,
        delta: u64,
        fee: u64,
        collection_id: u64, 
        init_price: u64,
        nft_num: u64,
        ctx: &mut TxContext,
    ) {
        let new_pool = TradePool<X, Y, Z>{
            id: object::new(ctx),
            collection,
            curve_type,
            delta,
            fee,
            init_price,
            nft_num,
            collection_id,
            coin_sui: balance::zero(),
            coin_stable: balance::zero(),
            coin_self: balance::zero(),
            nfts: object_bag::new(ctx),
        };
        transfer::share_object(new_pool);
    }

    public entry fun deposit_nfts_bag<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, object_bag: &mut ObjectBag, ctx: &mut TxContext) : bool{
        // let pool = borrow_global_mut<TradePool>(trade_pool_address);
        // let nfts_vec_ref = &mut pool.nfts;
        // let len = Vector::length(&object_id_list);
        // let mut i = 0;
        // while (i < len) {
        //     Vector::push_back(nfts_vec_ref, Vector::borrow(&object_id_list, i));
        //     i = i + 1;
        // }
        true
    }


    public entry fun swap_sui_for_nfts<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, coin_sui: &mut Coin<X>, ctx: &mut TxContext) : bool{
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

    public entry fun swap_stable_coin_for_nfts<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, coin_stable: &mut Coin<Y>, ctx: &mut TxContext) : bool {
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

    public entry fun swap_self_coin_for_nfts<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, coin_self: &mut Coin<Z>, ctx: &mut TxContext) : bool {
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


    // TODO: swap NFT for three types.

    // Only Owner
    public fun withdraw_nft<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, nft_num: u64, ctx: &mut TxContext) : bool {
        true
    }

    // Only Owner
    public fun withdraw_coin<X, Y, Z>(trade_pool: &mut TradePool<X, Y, Z>, coin_type: u64, ctx: &mut TxContext) : bool {
        true
    }

}