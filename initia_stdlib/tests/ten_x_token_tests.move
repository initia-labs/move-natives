#[test_only]
module initia_std::ten_x_token_tests {
    use initia_std::fungible_asset::{Self, Metadata, TestToken};
    use initia_std::dispatchable_fungible_asset;
    use 0xcafe::ten_x_token;
    use initia_std::object;
    use std::option;

    #[test(creator = @0xcafe)]
    fun test_ten_x(creator: &signer) {
        let (creator_ref, token_object) = fungible_asset::create_test_token(creator);
        let (mint, _, _, _) = fungible_asset::init_test_metadata(&creator_ref);
        let metadata = object::convert<TestToken, Metadata>(token_object);

        let creator_store = fungible_asset::create_test_store(creator, metadata);

        ten_x_token::initialize(creator, &creator_ref);

        assert!(
            dispatchable_fungible_asset::derived_supply(metadata) == option::some(0), 2
        );
        // Mint
        let fa = fungible_asset::mint(&mint, 100);
        dispatchable_fungible_asset::deposit(creator_store, fa);

        // The derived value is 10x
        assert!(dispatchable_fungible_asset::derived_balance(creator_store) == 1000, 4);

        // The derived supply is 10x
        assert!(
            dispatchable_fungible_asset::derived_supply(metadata) == option::some(1000),
            5
        );
    }
}
