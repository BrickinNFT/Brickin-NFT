module test::cnyu {
    use sui::coin::{Self, TreasuryCap, mint_and_transfer};
    use sui::transfer;
    use sui::tx_context::{TxContext, sender};

    use std:: option;

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

    public entry fun mint_coin(cap: &mut TreasuryCap<CNYU>, amount: u64, ctx: &mut TxContext) {
        mint_and_transfer(cap, amount, sender(ctx), ctx);
    }
}
