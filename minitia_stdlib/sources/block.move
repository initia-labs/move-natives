module minitia_std::block {
    use std::string::{String};

    #[view]
    /// Return the chain ID of this instance.
    native public fun get_chain_id(): String;

    #[test_only]
    native public fun set_chain_id_for_test(chain_id: String);

    #[test_only]
    use std::string;

    #[test]
    public fun test_get_chain_id() {
        set_chain_id_for_test(string::utf8(b"minitia"));
        let chain_id = get_chain_id();
        assert!(chain_id == string::utf8(b"minitia"), 0);
    }

    native public fun get_block_info(): (u64, u64);

    #[test_only]
    native public fun set_block_info(height: u64, timestamp: u64);

    #[test]
    public fun test_get_block_info() {
        set_block_info(12321u64, 9999999u64);

        let (height, timestamp) = get_block_info();
        assert!(height == 12321u64, 0);
        assert!(timestamp == 9999999u64, 1);
    }

    // Functions for compatibility with the aptos

    #[view]
    public fun get_current_block_height(): u64 {
        let (height, _) = get_block_info();
        height
    }

    #[view]
    public fun get_current_block_timestamp(): u64 {
        let (_, timestamp) = get_block_info();
        timestamp
    }

    #[test_only]
    public fun initialize_for_test(
        _vm: &signer, _epoch_interval_microsecs: u64
    ) {
        // no-op
    }

    #[test_only]
    use minitia_std::signer;

    #[test_only]
    struct HasGenesisBlock has key {}

    #[test_only]
    public fun emit_writeset_block_event(
        vm: &signer, _fake_block_hash: address
    ) {
        if (!exists<HasGenesisBlock>(signer::address_of(vm))) {
            move_to(vm, HasGenesisBlock {});
            return
        };

        let (block_height, block_time) = get_block_info();
        set_block_info(block_height + 1, block_time);
    }
}
