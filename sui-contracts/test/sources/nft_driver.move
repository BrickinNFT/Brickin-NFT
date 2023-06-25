module test::nft_driver {
    use sui::object::{Self, UID};
    use std::string::String;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer::public_transfer;

    struct NFT has key, store {
        id: UID,
        name: String,
        url: String,
    }

    public entry fun mint_nft(name: String, url: String, ctx: &mut TxContext) {
        public_transfer(NFT{
            id: object::new(ctx),
            name,
            url
        }, sender(ctx));
    }
}
