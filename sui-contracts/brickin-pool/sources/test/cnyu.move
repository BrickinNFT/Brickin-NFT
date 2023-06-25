module brickin::cnyu {
    use sui::coin::{Self, TreasuryCap, mint};
    use sui::transfer::{Self, public_transfer};
    use sui::tx_context::{TxContext, sender};

    use std:: option;
    use sui::object;
    use sui::object::ID;

    //Alipay DIGICCY, named CNYU
    struct CNYU has drop {}

    //Decimal of Coin
    const DECIMALS: u8 = 9;

    fun init(witness: CNYU, ctx: &mut TxContext) {
        let (treasury, metadata) = coin::create_currency(
            witness,
            DECIMALS,
            b"CNYU",
            b"Union bank DIGICCY",
            b"Alipay Digital Currency CNYU",
            option::none(),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_share_object(treasury);
    }

    public fun mint_coin(cap: &mut TreasuryCap<CNYU>, amount: u64, ctx: &mut TxContext): ID {
        let coin =  mint(cap, amount, ctx);
        let coin_id = object::id(&coin);
        public_transfer(coin, sender(ctx));
        coin_id
    }
}
