module brickin::nft_driver {
    use sui::object::{Self, UID, ID};
    use std::string::String;
    use sui::tx_context::{TxContext, sender};
    use sui::transfer::public_transfer;

    struct NFT has key, store {
        id: UID,
        name: String,
        url: String,
    }

    public fun mint_nft(name: String, url: String, ctx: &mut TxContext):ID {
        let nft = NFT{
            id: object::new(ctx),
            name,
            url
        };
        let nft_id = object::id(&nft);
        public_transfer(nft, sender(ctx));
        nft_id
    }
}
