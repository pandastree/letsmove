module nft::mynft {
    use sui::tx_context::{Self, TxContext};
    use sui::display;
    use sui::object::{Self, UID};
    use sui::package;
    use sui::transfer;
    use std::string::{String, utf8};

    struct MYNFT has drop {}

    struct Zeroc has key, store {
        id: UID,
        name: String,
        description: String,
    }

    fun init(otw: MYNFT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"description"),
            utf8(b"image_url")
        ];
        let values = vector[
            utf8(b"zeroc"),
            utf8(b"A sample NFT for zeroc"),
            utf8(b"https://img.zeroc0077.cn/avatar.png")
        ];
        let publisher = package::claim(otw, ctx);
        let display = display::new_with_fields<Zeroc>(&publisher, keys, values, ctx);
        display::update_version(&mut display);

        let deployer = tx_context::sender(ctx);
        transfer::public_transfer(publisher, deployer);
        transfer::public_transfer(display, deployer);
    }

    public entry fun mint(name: vector<u8>, description: vector<u8>, recipient: address, ctx: &mut TxContext) {
        let nft = Zeroc {
            id: object::new(ctx),
            name: utf8(name),
            description: utf8(description),
        };
        transfer::public_transfer(nft, recipient);
    }
}