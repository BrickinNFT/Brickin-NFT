module brickin::nft_driver {
    use sui::url::{Self, Url};
    use std::string;
    use sui::object::{Self, ID, UID};
    use sui::event;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// An example NFT that can be minted by anybody
    struct NFT has key, store {
        id: UID,
        name: string::String,
        /// Description of NFT
        description: string::String,
        /// URL for NFT
        url: Url,
    }


    struct NFTMinted has copy, drop {
        object_id: ID,
        creator: address,
        name: string::String,
    }

    /// Get the NFT's `name`
    public fun name(nft: &NFT): &string::String {
        &nft.name
    }

    /// Get the NFT's `description`
    public fun description(nft: &NFT): &string::String {
        &nft.description
    }

    /// Get the NFT's `url`
    public fun url(nft: &NFT): &Url {
        &nft.url
    }

    /// Create a new NFT
    public entry fun mint_to_sender(
        name: vector<u8>,
        description: vector<u8>,
        url: vector<u8>,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);
        let nft = NFT {
            id: object::new(ctx),
            name: string::utf8(name),
            description: string::utf8(description),
            url: url::new_unsafe_from_bytes(url)
        };

        event::emit(NFTMinted {
            object_id: object::id(&nft),
            creator: sender,
            name: nft.name,
        });

        transfer::public_transfer(nft, sender);
    }

    /// Transfer `nft` to `recipient`
    public entry fun transfer(
        nft: NFT, recipient: address, _ctx: &mut TxContext
    ) {
        transfer::public_transfer(nft, recipient)
    }

    /// Update the `description` of `nft` to `new_description`
    public entry fun update_description(
        nft: &mut NFT,
        new_description: vector<u8>,
        _ctx: &mut TxContext
    ) {
        nft.description = string::utf8(new_description)
    }

    /// Permanently delete `nft`
    public entry fun burn(nft: NFT, _ctx: &mut TxContext) {
        let NFT { id, name: _, description: _, url: _ } = nft;
        object::delete(id)
    }
}