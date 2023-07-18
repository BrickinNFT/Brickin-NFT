module brickin::cnya {
    use sui::coin::{Self, TreasuryCap, mint};
    use sui::transfer::{Self, public_transfer};
    use sui::tx_context::{TxContext, sender};

    use std:: option;
    use sui::object::{Self, ID};

    ///Alipay DIGICCY, named CNYA
    struct CNYA has drop {}

    /// Store the CNYA Cap
    struct CNYACap has store, copy, drop{}

    ///Decimal of Coin
    const DECIMALS: u8 = 9;

    fun init(witness: CNYA, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            DECIMALS,
            b"CNYA",
            b"Alipay DIGICCY",
            b"Alipay Digital Currency CNYA",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public entry fun mint_coin(cap: &mut TreasuryCap<CNYA>, amount: u64, ctx: &mut TxContext): ID {
        let coin =  mint(cap, amount, ctx);
        let coin_id = object::id(&coin);
        public_transfer(coin, sender(ctx));
        coin_id
    }

}
