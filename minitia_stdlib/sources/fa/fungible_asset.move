/// This defines the fungible asset module that can issue fungible asset of any `Metadata` object. The
/// metadata object can be any object that equipped with `Metadata` resource.
module minitia_std::fungible_asset {
    use minitia_std::event;
    use minitia_std::object::{Self, Object, ConstructorRef, DeleteRef, ExtendRef};
    use minitia_std::function_info::{Self, FunctionInfo};

    use std::error;
    use std::option::{Self, Option};
    use std::signer;
    use std::string::{Self, String};
    use std::account;

    friend minitia_std::primary_fungible_store;
    friend minitia_std::dispatchable_fungible_asset;

    /// The transfer ref and the fungible asset do not match.
    const ETRANSFER_REF_AND_FUNGIBLE_ASSET_MISMATCH: u64 = 2;
    /// Store is disabled from sending and receiving this fungible asset.
    const ESTORE_IS_FROZEN: u64 = 3;
    /// Insufficient balance to withdraw or transfer.
    const EINSUFFICIENT_BALANCE: u64 = 4;
    /// The fungible asset's supply has exceeded maximum.
    const EMAX_SUPPLY_EXCEEDED: u64 = 5;
    /// Fungible asset do not match when merging.
    const EFUNGIBLE_ASSET_MISMATCH: u64 = 6;
    /// The mint ref and the store do not match.
    const EMINT_REF_AND_STORE_MISMATCH: u64 = 7;
    /// Account is not the store's owner.
    const ENOT_STORE_OWNER: u64 = 8;
    /// Transfer ref and store do not match.
    const ETRANSFER_REF_AND_STORE_MISMATCH: u64 = 9;
    /// Burn ref and store do not match.
    const EBURN_REF_AND_STORE_MISMATCH: u64 = 10;
    /// Fungible asset and store do not match.
    const EFUNGIBLE_ASSET_AND_STORE_MISMATCH: u64 = 11;
    /// Cannot destroy non-empty fungible assets.
    const EAMOUNT_IS_NOT_ZERO: u64 = 12;
    /// Burn ref and fungible asset do not match.
    const EBURN_REF_AND_FUNGIBLE_ASSET_MISMATCH: u64 = 13;
    /// Cannot destroy fungible stores with a non-zero balance.
    const EBALANCE_IS_NOT_ZERO: u64 = 14;
    /// Name of the fungible asset metadata is too long
    const ENAME_TOO_LONG: u64 = 15;
    /// Symbol of the fungible asset metadata is too long
    const ESYMBOL_TOO_LONG: u64 = 16;
    /// Decimals is over the maximum of 32
    const EDECIMALS_TOO_LARGE: u64 = 17;
    /// Fungibility is only available for non-deletable objects.
    const EOBJECT_IS_DELETABLE: u64 = 18;
    /// URI for the icon of the fungible asset metadata is too long
    const EURI_TOO_LONG: u64 = 19;
    /// The fungible asset's supply will be negative which should be impossible.
    const ESUPPLY_UNDERFLOW: u64 = 20;
    /// Supply resource is not found for a metadata object.
    const ESUPPLY_NOT_FOUND: u64 = 21;
    /// Flag for the existence of fungible store.
    const EFUNGIBLE_STORE_EXISTENCE: u64 = 23;
    /// Account is not the owner of metadata object.
    const ENOT_METADATA_OWNER: u64 = 24;
    /// Provided withdraw function type doesn't meet the signature requirement.
    const EWITHDRAW_FUNCTION_SIGNATURE_MISMATCH: u64 = 25;
    /// Provided deposit function type doesn't meet the signature requirement.
    const EDEPOSIT_FUNCTION_SIGNATURE_MISMATCH: u64 = 26;
    /// Provided derived_balance function type doesn't meet the signature requirement.
    const EDERIVED_BALANCE_FUNCTION_SIGNATURE_MISMATCH: u64 = 27;
    /// Invalid withdraw/deposit on dispatchable token. The specified token has a dispatchable function hook.
    /// Need to invoke dispatchable_fungible_asset::withdraw/deposit to perform transfer.
    const EINVALID_DISPATCHABLE_OPERATIONS: u64 = 28;
    /// Trying to re-register dispatch hook on a fungible asset.
    const EALREADY_REGISTERED: u64 = 29;
    /// Fungible metadata does not exist on this account.
    const EFUNGIBLE_METADATA_EXISTENCE: u64 = 30;
    /// Cannot register dispatch hook for APT.
    const EAPT_NOT_DISPATCHABLE: u64 = 31;
    /// Provided derived_supply function type doesn't meet the signature requirement.
    const EDERIVED_SUPPLY_FUNCTION_SIGNATURE_MISMATCH: u64 = 33;
    /// Module account store cannot be manipulated.
    const ECONNOT_MANIPULATE_MODULE_ACCOUNT_STORE: u64 = 91;
    /// Deposit to a blocked account is not allowed._
    const ECANNOT_DEPOSIT_TO_BLOCKED_ACCOUNT: u64 = 92;

    //
    // Constants
    //

    /// Increase name length to 128 due to cosmos spec.
    const MAX_NAME_LENGTH: u64 = 128;
    /// Increase symbol length to 128 due to cosmos spec.
    const MAX_SYMBOL_LENGTH: u64 = 128;
    const MAX_DECIMALS: u8 = 32;
    const MAX_URI_LENGTH: u64 = 512;

    /// Maximum possible coin supply.
    const MAX_U128: u128 = 340282366920938463463374607431768211455;

    struct Supply has key {
        current: u128,
        // option::none() means unlimited supply.
        maximum: Option<u128>
    }

    /// Metadata of a Fungible asset
    struct Metadata has key, copy, drop {
        /// Name of the fungible metadata, i.e., "USDT".
        name: String,
        /// Symbol of the fungible metadata, usually a shorter version of the name.
        /// For example, Singapore Dollar is SGD.
        symbol: String,
        /// Number of decimals used for display purposes.
        /// For example, if `decimals` equals `2`, a balance of `505` coins should
        /// be displayed to a user as `5.05` (`505 / 10 ** 2`).
        decimals: u8,
        /// The Uniform Resource Identifier (uri) pointing to an image that can be used as the icon for this fungible
        /// asset.
        icon_uri: String,
        /// The Uniform Resource Identifier (uri) pointing to the website for the fungible asset.
        project_uri: String
    }

    /// Extra metadata of a Fungible asset
    /// @dev - this interface only exists in minitia_stdlib.
    struct ExtraMetadata has key, copy, drop {
        /// Name of the fungible metadata, i.e., "USDT".
        name: String,
        /// Symbol of the fungible metadata, usually a shorter version of the name.
        /// For example, Singapore Dollar is SGD.
        symbol: String,
        /// Number of decimals used for display purposes.
        /// For example, if `decimals` equals `2`, a balance of `505` coins should
        /// be displayed to a user as `5.05` (`505 / 10 ** 2`).
        decimals: u8,
        /// The Uniform Resource Identifier (uri) pointing to an image that can be used as the icon for this fungible
        /// asset.
        icon_uri: String,
        /// The Uniform Resource Identifier (uri) pointing to the website for the fungible asset.
        project_uri: String
    }

    /// The store object that holds fungible assets of a specific type associated with an account.
    struct FungibleStore has key {
        /// The address of the base metadata object.
        metadata: Object<Metadata>,
        /// The balance of the fungible metadata.
        balance: u64,
        /// If true, owner transfer is disabled that only `TransferRef` can move in/out from this store.
        frozen: bool
    }

    /// FungibleAsset can be passed into function for type safety and to guarantee a specific amount.
    /// FungibleAsset is ephemeral and cannot be stored directly. It must be deposited back into a store.
    struct FungibleAsset {
        metadata: Object<Metadata>,
        amount: u64
    }

    struct DispatchFunctionStore has key {
        withdraw_function: Option<FunctionInfo>,
        deposit_function: Option<FunctionInfo>,
        derived_balance_function: Option<FunctionInfo>
    }

    struct DeriveSupply has key {
        dispatch_function: Option<FunctionInfo>
    }

    /// MintRef can be used to mint the fungible asset into an account's store.
    struct MintRef has drop, store {
        metadata: Object<Metadata>
    }

    /// TransferRef can be used to allow or disallow the owner of fungible assets from transferring the asset
    /// and allow the holder of TransferRef to transfer fungible assets from any account.
    struct TransferRef has drop, store {
        metadata: Object<Metadata>
    }

    /// BurnRef can be used to burn fungible assets from a given holder account.
    struct BurnRef has drop, store {
        metadata: Object<Metadata>
    }

    /// MutateMetadataRef can be used to directly modify the fungible asset's Metadata.
    struct MutateMetadataRef has drop, store {
        metadata: Object<Metadata>
    }

    #[event]
    /// Emitted when fungible assets are deposited into a store.
    struct DepositEvent has drop, store {
        store_addr: address,
        metadata_addr: address,
        amount: u64
    }

    #[event]
    /// Emitted when fungible assets are deposited into a store.
    struct DepositOwnerEvent has drop {
        owner: address
    }

    #[event]
    /// Emitted when fungible assets are withdrawn from a store.
    struct WithdrawEvent has drop, store {
        store_addr: address,
        metadata_addr: address,
        amount: u64
    }

    #[event]
    /// Emitted when fungible assets are withdrawn from a store.
    struct WithdrawOwnerEvent has drop {
        owner: address
    }

    #[event]
    /// Emitted when a store's frozen status is updated.
    struct FrozenEvent has drop, store {
        store_addr: address,
        metadata_addr: address,
        frozen: bool
    }

    #[event]
    /// Emitted when fungible assets are burnt.
    struct BurnEvent has drop, store {
        metadata_addr: address,
        amount: u64
    }

    #[event]
    /// Emitted when fungible assets are minted.
    struct MintEvent has drop, store {
        metadata_addr: address,
        amount: u64
    }

    /// Make an existing object fungible by adding the Metadata resource.
    /// This returns the capabilities to mint, burn, and transfer.
    /// maximum_supply defines the behavior of maximum supply when monitoring:
    ///   - option::none(): Monitoring unlimited supply
    ///   - option::some(max): Monitoring fixed supply with `max` as the maximum supply.
    public fun add_fungibility(
        constructor_ref: &ConstructorRef,
        maximum_supply: Option<u128>,
        name: String,
        symbol: String,
        decimals: u8,
        icon_uri: String,
        project_uri: String
    ): Object<Metadata> {
        assert!(
            !object::can_generate_delete_ref(constructor_ref),
            error::invalid_argument(EOBJECT_IS_DELETABLE)
        );
        let metadata_object_signer = &object::generate_signer(constructor_ref);

        // metadata validations
        assert!(
            string::length(&name) <= MAX_NAME_LENGTH,
            error::out_of_range(ENAME_TOO_LONG)
        );
        assert!(
            string::length(&symbol) <= MAX_SYMBOL_LENGTH,
            error::out_of_range(ESYMBOL_TOO_LONG)
        );
        assert!(
            decimals <= MAX_DECIMALS,
            error::out_of_range(EDECIMALS_TOO_LARGE)
        );
        assert!(
            string::length(&icon_uri) <= MAX_URI_LENGTH,
            error::out_of_range(EURI_TOO_LONG)
        );
        assert!(
            string::length(&project_uri) <= MAX_URI_LENGTH,
            error::out_of_range(EURI_TOO_LONG)
        );

        // store metadata
        move_to(
            metadata_object_signer,
            Metadata { name, symbol, decimals, icon_uri, project_uri }
        );

        // store supply
        move_to(
            metadata_object_signer,
            Supply { current: 0, maximum: maximum_supply }
        );

        // return metadata object
        object::object_from_constructor_ref<Metadata>(constructor_ref)
    }

    /// Create a fungible asset store whose transfer rule would be overloaded by the provided function.
    public(friend) fun register_dispatch_functions(
        constructor_ref: &ConstructorRef,
        withdraw_function: Option<FunctionInfo>,
        deposit_function: Option<FunctionInfo>,
        derived_balance_function: Option<FunctionInfo>
    ) {
        // Verify that caller type matches callee type so wrongly typed function cannot be registered.
        option::for_each_ref(
            &withdraw_function,
            |withdraw_function| {
                let dispatcher_withdraw_function_info =
                    function_info::new_function_info_from_address(
                        @minitia_std,
                        string::utf8(b"dispatchable_fungible_asset"),
                        string::utf8(b"dispatchable_withdraw")
                    );

                assert!(
                    function_info::check_dispatch_type_compatibility(
                        &dispatcher_withdraw_function_info,
                        withdraw_function
                    ),
                    error::invalid_argument(EWITHDRAW_FUNCTION_SIGNATURE_MISMATCH)
                );
            }
        );

        option::for_each_ref(
            &deposit_function,
            |deposit_function| {
                let dispatcher_deposit_function_info =
                    function_info::new_function_info_from_address(
                        @minitia_std,
                        string::utf8(b"dispatchable_fungible_asset"),
                        string::utf8(b"dispatchable_deposit")
                    );
                // Verify that caller type matches callee type so wrongly typed function cannot be registered.
                assert!(
                    function_info::check_dispatch_type_compatibility(
                        &dispatcher_deposit_function_info,
                        deposit_function
                    ),
                    error::invalid_argument(EDEPOSIT_FUNCTION_SIGNATURE_MISMATCH)
                );
            }
        );

        option::for_each_ref(
            &derived_balance_function,
            |balance_function| {
                let dispatcher_derived_balance_function_info =
                    function_info::new_function_info_from_address(
                        @minitia_std,
                        string::utf8(b"dispatchable_fungible_asset"),
                        string::utf8(b"dispatchable_derived_balance")
                    );
                // Verify that caller type matches callee type so wrongly typed function cannot be registered.
                assert!(
                    function_info::check_dispatch_type_compatibility(
                        &dispatcher_derived_balance_function_info,
                        balance_function
                    ),
                    error::invalid_argument(
                        EDERIVED_BALANCE_FUNCTION_SIGNATURE_MISMATCH
                    )
                );
            }
        );
        register_dispatch_function_sanity_check(constructor_ref);
        assert!(
            !exists<DispatchFunctionStore>(
                object::address_from_constructor_ref(constructor_ref)
            ),
            error::already_exists(EALREADY_REGISTERED)
        );

        let store_obj = &object::generate_signer(constructor_ref);

        // Store the overload function hook.
        move_to<DispatchFunctionStore>(
            store_obj,
            DispatchFunctionStore {
                withdraw_function,
                deposit_function,
                derived_balance_function
            }
        );
    }

    /// Define the derived supply dispatch with the provided function.
    public(friend) fun register_derive_supply_dispatch_function(
        constructor_ref: &ConstructorRef, dispatch_function: Option<FunctionInfo>
    ) {
        // Verify that caller type matches callee type so wrongly typed function cannot be registered.
        option::for_each_ref(
            &dispatch_function,
            |supply_function| {
                let function_info =
                    function_info::new_function_info_from_address(
                        @minitia_std,
                        string::utf8(b"dispatchable_fungible_asset"),
                        string::utf8(b"dispatchable_derived_supply")
                    );
                // Verify that caller type matches callee type so wrongly typed function cannot be registered.
                assert!(
                    function_info::check_dispatch_type_compatibility(
                        &function_info, supply_function
                    ),
                    error::invalid_argument(
                        EDERIVED_SUPPLY_FUNCTION_SIGNATURE_MISMATCH
                    )
                );
            }
        );
        register_dispatch_function_sanity_check(constructor_ref);
        assert!(
            !exists<DeriveSupply>(
                object::address_from_constructor_ref(constructor_ref)
            ),
            error::already_exists(EALREADY_REGISTERED)
        );

        let store_obj = &object::generate_signer(constructor_ref);

        // Store the overload function hook.
        move_to<DeriveSupply>(store_obj, DeriveSupply { dispatch_function });
    }

    /// Check the requirements for registering a dispatchable function.
    inline fun register_dispatch_function_sanity_check(
        constructor_ref: &ConstructorRef
    ) {
        // Cannot register hook for APT.
        assert!(
            object::address_from_constructor_ref(constructor_ref) != @minitia_std,
            error::permission_denied(EAPT_NOT_DISPATCHABLE)
        );
        assert!(
            !object::can_generate_delete_ref(constructor_ref),
            error::invalid_argument(EOBJECT_IS_DELETABLE)
        );
        assert!(
            exists<Metadata>(object::address_from_constructor_ref(constructor_ref)),
            error::not_found(EFUNGIBLE_METADATA_EXISTENCE)
        );
    }

    /// Creates a mint ref that can be used to mint fungible assets from the given fungible object's constructor ref.
    /// This can only be called at object creation time as constructor_ref is only available then.
    public fun generate_mint_ref(constructor_ref: &ConstructorRef): MintRef {
        let metadata = object::object_from_constructor_ref<Metadata>(constructor_ref);
        MintRef { metadata }
    }

    /// Creates a burn ref that can be used to burn fungible assets from the given fungible object's constructor ref.
    /// This can only be called at object creation time as constructor_ref is only available then.
    public fun generate_burn_ref(constructor_ref: &ConstructorRef): BurnRef {
        let metadata = object::object_from_constructor_ref<Metadata>(constructor_ref);
        BurnRef { metadata }
    }

    /// Creates a transfer ref that can be used to freeze/unfreeze/transfer fungible assets from the given fungible
    /// object's constructor ref.
    /// This can only be called at object creation time as constructor_ref is only available then.
    public fun generate_transfer_ref(constructor_ref: &ConstructorRef): TransferRef {
        let metadata = object::object_from_constructor_ref<Metadata>(constructor_ref);
        TransferRef { metadata }
    }

    /// Creates a mutate metadata ref that can be used to change the metadata information of fungible assets from the
    /// given fungible object's constructor ref.
    /// This can only be called at object creation time as constructor_ref is only available then.
    public fun generate_mutate_metadata_ref(
        constructor_ref: &ConstructorRef
    ): MutateMetadataRef {
        let metadata = object::object_from_constructor_ref<Metadata>(constructor_ref);
        MutateMetadataRef { metadata }
    }

    /// Creates a mutate metadata ref that can be used to change the metadata information of fungible assets from the
    /// given mint ref.
    /// @dev - this interface only exists in minitia_stdlib.
    public fun generate_mutate_metadata_ref_from_mint_ref(
        mint_ref: &MintRef
    ): MutateMetadataRef {
        MutateMetadataRef { metadata: mint_ref.metadata }
    }

    #[view]
    /// Return true if given address has Metadata else return false
    public fun is_fungible_asset(metadata_addr: address): bool {
        exists<Metadata>(metadata_addr)
    }

    #[view]
    /// Get the current supply from the `metadata` object.
    ///
    /// Note: This function will abort on FAs with `derived_supply` hook set up.
    ///       Use `dispatchable_fungible_asset::supply` instead if you intend to work with those FAs.
    public fun supply<T: key>(metadata: Object<T>): Option<u128> acquires Supply {
        let metadata_address = object::object_address(&metadata);
        assert!(
            !has_supply_dispatch_function(metadata_address),
            error::invalid_argument(EINVALID_DISPATCHABLE_OPERATIONS)
        );
        if (exists<Supply>(metadata_address)) {
            let supply = borrow_global<Supply>(metadata_address);
            option::some(supply.current)
        } else {
            option::none()
        }
    }

    #[view]
    /// Get the current supply from the `metadata` object without sanity check.
    public fun supply_without_sanity_check<T: key>(metadata: Object<T>): Option<u128> acquires Supply {
        let metadata_address = object::object_address(&metadata);
        if (exists<Supply>(metadata_address)) {
            let supply = borrow_global<Supply>(metadata_address);
            option::some(supply.current)
        } else {
            option::none()
        }
    }

    #[view]
    /// Get the maximum supply from the `metadata` object.
    public fun maximum<T: key>(metadata: Object<T>): Option<u128> acquires Supply {
        let metadata_address = object::object_address(&metadata);
        if (exists<Supply>(metadata_address)) {
            let supply = borrow_global<Supply>(metadata_address);
            supply.maximum
        } else {
            option::none()
        }
    }

    #[view]
    /// Get the name of the fungible asset from the `metadata` object.
    public fun name<T: key>(metadata: Object<T>): String acquires Metadata, ExtraMetadata {
        if (exists<ExtraMetadata>(object::object_address(&metadata))) {
            return borrow_global<ExtraMetadata>(object::object_address(&metadata)).name
        };

        borrow_fungible_metadata(&metadata).name
    }

    #[view]
    /// Get the symbol of the fungible asset from the `metadata` object.
    public fun raw_symbol<T: key>(metadata: Object<T>): String acquires Metadata {
        borrow_fungible_metadata(&metadata).symbol
    }

    #[view]
    /// Get the symbol of the fungible asset from the `extra_metadata`, if not exists, get from the `metadata` object.
    public fun symbol<T: key>(metadata: Object<T>): String acquires Metadata, ExtraMetadata {
        if (exists<ExtraMetadata>(object::object_address(&metadata))) {
            return borrow_global<ExtraMetadata>(object::object_address(&metadata)).symbol
        };

        raw_symbol(metadata)
    }

    #[view]
    /// Get the icon uri from the `metadata` object.
    public fun icon_uri<T: key>(metadata: Object<T>): String acquires Metadata, ExtraMetadata {
        if (exists<ExtraMetadata>(object::object_address(&metadata))) {
            return borrow_global<ExtraMetadata>(object::object_address(&metadata)).icon_uri
        };

        borrow_fungible_metadata(&metadata).icon_uri
    }

    #[view]
    /// Get the project uri from the `metadata` object.
    public fun project_uri<T: key>(metadata: Object<T>): String acquires Metadata, ExtraMetadata {
        if (exists<ExtraMetadata>(object::object_address(&metadata))) {
            return borrow_global<ExtraMetadata>(object::object_address(&metadata)).project_uri
        };

        borrow_fungible_metadata(&metadata).project_uri
    }

    #[view]
    /// Get the metadata struct from the `metadata` object.
    public fun metadata<T: key>(metadata: Object<T>): Metadata acquires Metadata, ExtraMetadata {
        if (exists<ExtraMetadata>(object::object_address(&metadata))) {
            let extra_metadata =
                borrow_global<ExtraMetadata>(object::object_address(&metadata));
            return Metadata {
                name: extra_metadata.name,
                symbol: extra_metadata.symbol,
                decimals: extra_metadata.decimals,
                icon_uri: extra_metadata.icon_uri,
                project_uri: extra_metadata.project_uri
            }
        };

        *borrow_fungible_metadata(&metadata)
    }

    #[view]
    /// Get the decimals from the `metadata` object.
    public fun decimals<T: key>(metadata: Object<T>): u8 acquires Metadata, ExtraMetadata {
        if (exists<ExtraMetadata>(object::object_address(&metadata))) {
            return borrow_global<ExtraMetadata>(object::object_address(&metadata)).decimals
        };

        borrow_fungible_metadata(&metadata).decimals
    }

    #[view]
    /// Return whether the provided address has a store initialized.
    public fun store_exists(store: address): bool {
        exists<FungibleStore>(store)
    }

    /// Return the underlying metadata object
    public fun metadata_from_asset(fa: &FungibleAsset): Object<Metadata> {
        fa.metadata
    }

    #[view]
    /// Return the underlying metadata object.
    public fun store_metadata<T: key>(store: Object<T>): Object<Metadata> acquires FungibleStore {
        borrow_store_resource(&store).metadata
    }

    /// Return the `amount` of a given fungible asset.
    public fun amount(fa: &FungibleAsset): u64 {
        fa.amount
    }

    #[view]
    /// Get the balance of a given store.
    ///
    /// Note: This function will abort on FAs with `derived_balance` hook set up.
    ///       Use `dispatchable_fungible_asset::derived_balance` instead if you intend to work with those FAs.
    public fun balance<T: key>(store: Object<T>): u64 acquires FungibleStore, DispatchFunctionStore {
        if (store_exists(object::object_address(&store))) {
            let fa_store = borrow_store_resource(&store);
            assert!(
                !has_balance_dispatch_function(fa_store.metadata),
                error::invalid_argument(EINVALID_DISPATCHABLE_OPERATIONS)
            );
            fa_store.balance
        } else { 0 }
    }

    #[view]
    /// Get the balance of a given store without sanity check.
    public fun balance_without_sanity_check<T: key>(store: Object<T>): u64 acquires FungibleStore {
        if (store_exists(object::object_address(&store))) {
            borrow_store_resource(&store).balance
        } else { 0 }
    }

    #[view]
    /// Return whether a store is frozen.
    ///
    /// If the store has not been created, we default to returning false so deposits can be sent to it.
    public fun is_frozen<T: key>(store: Object<T>): bool acquires FungibleStore {
        store_exists(object::object_address(&store))
            && borrow_store_resource(&store).frozen
    }

    #[view]
    /// Return whether a fungible asset type is dispatchable.
    public fun is_store_dispatchable<T: key>(store: Object<T>): bool acquires FungibleStore {
        let fa_store = borrow_store_resource(&store);
        let metadata_addr = object::object_address(&fa_store.metadata);
        exists<DispatchFunctionStore>(metadata_addr)
    }

    public fun deposit_dispatch_function<T: key>(
        store: Object<T>
    ): Option<FunctionInfo> acquires FungibleStore, DispatchFunctionStore {
        let fa_store = borrow_store_resource(&store);
        let metadata_addr = object::object_address(&fa_store.metadata);
        if (exists<DispatchFunctionStore>(metadata_addr)) {
            borrow_global<DispatchFunctionStore>(metadata_addr).deposit_function
        } else {
            option::none()
        }
    }

    fun has_deposit_dispatch_function(
        metadata: Object<Metadata>
    ): bool acquires DispatchFunctionStore {
        let metadata_addr = object::object_address(&metadata);
        if (exists<DispatchFunctionStore>(metadata_addr)) {
            option::is_some(
                &borrow_global<DispatchFunctionStore>(metadata_addr).deposit_function
            )
        } else { false }
    }

    public fun withdraw_dispatch_function<T: key>(
        store: Object<T>
    ): Option<FunctionInfo> acquires FungibleStore, DispatchFunctionStore {
        let fa_store = borrow_store_resource(&store);
        let metadata_addr = object::object_address(&fa_store.metadata);
        if (exists<DispatchFunctionStore>(metadata_addr)) {
            borrow_global<DispatchFunctionStore>(metadata_addr).withdraw_function
        } else {
            option::none()
        }
    }

    fun has_withdraw_dispatch_function(
        metadata: Object<Metadata>
    ): bool acquires DispatchFunctionStore {
        let metadata_addr = object::object_address(&metadata);
        if (exists<DispatchFunctionStore>(metadata_addr)) {
            option::is_some(
                &borrow_global<DispatchFunctionStore>(metadata_addr).withdraw_function
            )
        } else { false }
    }

    fun has_balance_dispatch_function(
        metadata: Object<Metadata>
    ): bool acquires DispatchFunctionStore {
        let metadata_addr = object::object_address(&metadata);
        if (exists<DispatchFunctionStore>(metadata_addr)) {
            option::is_some(
                &borrow_global<DispatchFunctionStore>(metadata_addr).derived_balance_function
            )
        } else { false }
    }

    fun has_supply_dispatch_function(metadata_addr: address): bool {
        exists<DeriveSupply>(metadata_addr)
    }

    public(friend) fun derived_balance_dispatch_function<T: key>(
        store: Object<T>
    ): Option<FunctionInfo> acquires FungibleStore, DispatchFunctionStore {
        let fa_store = borrow_store_resource(&store);
        let metadata_addr = object::object_address(&fa_store.metadata);
        if (exists<DispatchFunctionStore>(metadata_addr)) {
            borrow_global<DispatchFunctionStore>(metadata_addr).derived_balance_function
        } else {
            option::none()
        }
    }

    public(friend) fun derived_supply_dispatch_function<T: key>(
        metadata: Object<T>
    ): Option<FunctionInfo> acquires DeriveSupply {
        let metadata_addr = object::object_address(&metadata);
        if (exists<DeriveSupply>(metadata_addr)) {
            borrow_global<DeriveSupply>(metadata_addr).dispatch_function
        } else {
            option::none()
        }
    }

    public fun asset_metadata(fa: &FungibleAsset): Object<Metadata> {
        fa.metadata
    }

    /// Get the underlying metadata object from the `MintRef`.
    public fun mint_ref_metadata(ref: &MintRef): Object<Metadata> {
        ref.metadata
    }

    /// Get the underlying metadata object from the `TransferRef`.
    public fun transfer_ref_metadata(ref: &TransferRef): Object<Metadata> {
        ref.metadata
    }

    /// Get the underlying metadata object from the `BurnRef`.
    public fun burn_ref_metadata(ref: &BurnRef): Object<Metadata> {
        ref.metadata
    }

    /// Get the underlying metadata object from the `MutateMetadataRef`.
    public fun object_from_metadata_ref(ref: &MutateMetadataRef): Object<Metadata> {
        ref.metadata
    }

    /// Transfer an `amount` of fungible asset from `from_store`, which should be owned by `sender`, to `receiver`.
    /// Note: it does not move the underlying object.
    public entry fun transfer<T: key>(
        sender: &signer,
        from: Object<T>,
        to: Object<T>,
        amount: u64
    ) acquires FungibleStore, DispatchFunctionStore {
        let fa = withdraw(sender, from, amount);
        deposit(to, fa);
    }

    /// Allow an object to hold a store for fungible assets.
    /// Applications can use this to create multiple stores for isolating fungible assets for different purposes.
    public fun create_store<T: key>(
        constructor_ref: &ConstructorRef, metadata: Object<T>
    ): Object<FungibleStore> {
        let store_obj = &object::generate_signer(constructor_ref);
        move_to(
            store_obj,
            FungibleStore { metadata: object::convert(metadata), balance: 0, frozen: false }
        );

        object::object_from_constructor_ref<FungibleStore>(constructor_ref)
    }

    /// Allow an object to hold a store for fungible assets.
    /// Applications can use this to create multiple stores for isolating fungible assets for different purposes.
    public fun create_store_with_extend_ref<T: key>(
        extend_ref: &ExtendRef, metadata: Object<T>
    ): Object<FungibleStore> {
        let store_obj = &object::generate_signer_for_extending(extend_ref);
        move_to(
            store_obj,
            FungibleStore { metadata: object::convert(metadata), balance: 0, frozen: false }
        );

        let obj_addr = object::address_from_extend_ref(extend_ref);
        object::address_to_object<FungibleStore>(obj_addr)
    }

    /// Used to delete a store.  Requires the store to be completely empty prior to removing it
    public fun remove_store(delete_ref: &DeleteRef) acquires FungibleStore {
        object::assert_deletable(delete_ref);

        let addr = object::address_from_delete_ref(delete_ref);
        let FungibleStore { metadata: _, balance, frozen: _ } =
            move_from<FungibleStore>(addr);
        assert!(
            balance == 0,
            error::permission_denied(EBALANCE_IS_NOT_ZERO)
        );
    }

    /// Check the permission for withdraw operation.
    public(friend) fun withdraw_sanity_check<T: key>(
        owner: &signer, store: Object<T>, abort_on_dispatch: bool
    ) acquires FungibleStore, DispatchFunctionStore {
        assert!(
            object::owns(store, signer::address_of(owner)),
            error::permission_denied(ENOT_STORE_OWNER)
        );
        let fa_store = borrow_store_resource(&store);
        assert!(
            !abort_on_dispatch || !has_withdraw_dispatch_function(fa_store.metadata),
            error::invalid_argument(EINVALID_DISPATCHABLE_OPERATIONS)
        );
        assert!(!fa_store.frozen, error::permission_denied(ESTORE_IS_FROZEN));
    }

    /// sanity check for deposit operation.
    public fun deposit_sanity_check<T: key>(
        store: Object<T>, abort_on_dispatch: bool
    ) acquires FungibleStore, DispatchFunctionStore {
        let fa_store = borrow_store_resource(&store);
        assert!(
            !abort_on_dispatch || !has_deposit_dispatch_function(fa_store.metadata),
            error::invalid_argument(EINVALID_DISPATCHABLE_OPERATIONS)
        );

        assert!(!fa_store.frozen, error::permission_denied(ESTORE_IS_FROZEN));

        // cannot deposit to blocked account
        let store_addr = object::object_address(&store);
        assert!(
            !is_blocked_store_addr(store_addr),
            error::invalid_argument(ECANNOT_DEPOSIT_TO_BLOCKED_ACCOUNT)
        );
    }

    /// sanity check for sudo deposit operation.
    public(friend) fun sudo_deposit_sanity_check<T: key>(
        store: Object<T>, abort_on_dispatch: bool
    ) acquires FungibleStore, DispatchFunctionStore {
        let fa_store = borrow_store_resource(&store);
        assert!(
            !abort_on_dispatch || !has_deposit_dispatch_function(fa_store.metadata),
            error::invalid_argument(EINVALID_DISPATCHABLE_OPERATIONS)
        );

        assert!(!fa_store.frozen, error::permission_denied(ESTORE_IS_FROZEN));
    }

    /// Withdraw `amount` of the fungible asset from `store` by the owner.
    public fun withdraw<T: key>(
        owner: &signer, store: Object<T>, amount: u64
    ): FungibleAsset acquires FungibleStore, DispatchFunctionStore {
        withdraw_sanity_check(owner, store, true);
        withdraw_internal(object::object_address(&store), amount)
    }

    /// Deposit `amount` of the fungible asset to `store`.
    public fun deposit<T: key>(
        store: Object<T>, fa: FungibleAsset
    ) acquires FungibleStore, DispatchFunctionStore {
        deposit_sanity_check(store, true);
        deposit_internal(object::object_address(&store), fa);
    }

    /// Mint the specified `amount` of the fungible asset.
    public fun mint(ref: &MintRef, amount: u64): FungibleAsset acquires Supply {
        let metadata = ref.metadata;
        if (amount == 0) return zero(metadata);

        increase_supply(metadata, amount);

        // emit event
        let metadata_addr = object::object_address(&metadata);
        event::emit(MintEvent { metadata_addr, amount });

        FungibleAsset { metadata, amount }
    }

    /// Mint the specified `amount` of the fungible asset to a destination store.
    public fun mint_to<T: key>(
        ref: &MintRef, store: Object<T>, amount: u64
    ) acquires FungibleStore, Supply, DispatchFunctionStore {
        deposit_sanity_check(store, false);
        deposit_internal(object::object_address(&store), mint(ref, amount));
    }

    /// Enable/disable a store's ability to do direct transfers of the fungible asset.
    public fun set_frozen_flag<T: key>(
        ref: &TransferRef, store: Object<T>, frozen: bool
    ) acquires FungibleStore {
        assert!(
            ref.metadata == store_metadata(store),
            error::invalid_argument(ETRANSFER_REF_AND_STORE_MISMATCH)
        );

        let metadata_addr = object::object_address(&ref.metadata);
        let store_addr = object::object_address(&store);

        // cannot freeze module account store
        assert!(
            !is_module_account_store_addr(store_addr),
            error::invalid_argument(ECONNOT_MANIPULATE_MODULE_ACCOUNT_STORE)
        );

        borrow_global_mut<FungibleStore>(store_addr).frozen = frozen;

        // emit event
        event::emit(FrozenEvent { store_addr, metadata_addr, frozen });
    }

    /// Burns a fungible asset
    public fun burn(ref: &BurnRef, fa: FungibleAsset) acquires Supply {
        let FungibleAsset { metadata, amount } = fa;
        assert!(
            &ref.metadata == &metadata,
            error::invalid_argument(EBURN_REF_AND_FUNGIBLE_ASSET_MISMATCH)
        );
        decrease_supply(metadata, amount);

        // emit event
        let metadata_addr = object::object_address(&metadata);
        event::emit(BurnEvent { metadata_addr, amount });
    }

    /// Burn the `amount` of the fungible asset from the given store.
    public fun burn_from<T: key>(
        ref: &BurnRef, store: Object<T>, amount: u64
    ) acquires FungibleStore, Supply {
        let metadata = ref.metadata;
        assert!(
            metadata == store_metadata(store),
            error::invalid_argument(EBURN_REF_AND_STORE_MISMATCH)
        );

        let store_addr = object::object_address(&store);

        // cannot burn module account funds
        assert!(
            !is_module_account_store_addr(store_addr),
            error::invalid_argument(ECONNOT_MANIPULATE_MODULE_ACCOUNT_STORE)
        );

        burn(ref, withdraw_internal(store_addr, amount));
    }

    /// Withdraw `amount` of the fungible asset from the `store` ignoring `frozen`.
    public fun withdraw_with_ref<T: key>(
        ref: &TransferRef, store: Object<T>, amount: u64
    ): FungibleAsset acquires FungibleStore {
        assert!(
            ref.metadata == store_metadata(store),
            error::invalid_argument(ETRANSFER_REF_AND_STORE_MISMATCH)
        );

        // cannot withdraw module account funds
        let store_addr = object::object_address(&store);
        assert!(
            !is_module_account_store_addr(store_addr),
            error::invalid_argument(ECONNOT_MANIPULATE_MODULE_ACCOUNT_STORE)
        );

        withdraw_internal(object::object_address(&store), amount)
    }

    /// Deposit the fungible asset into the `store` ignoring `frozen`.
    public fun deposit_with_ref<T: key>(
        ref: &TransferRef, store: Object<T>, fa: FungibleAsset
    ) acquires FungibleStore {
        assert!(
            ref.metadata == fa.metadata,
            error::invalid_argument(ETRANSFER_REF_AND_FUNGIBLE_ASSET_MISMATCH)
        );

        // cannot deposit to blocked account
        let store_addr = object::object_address(&store);
        assert!(
            !is_blocked_store_addr(store_addr),
            error::invalid_argument(ECANNOT_DEPOSIT_TO_BLOCKED_ACCOUNT)
        );

        deposit_internal(object::object_address(&store), fa);
    }

    /// Transfer `amount` of the fungible asset with `TransferRef` even it is frozen.
    public fun transfer_with_ref<T: key>(
        transfer_ref: &TransferRef,
        from: Object<T>,
        to: Object<T>,
        amount: u64
    ) acquires FungibleStore {
        let fa = withdraw_with_ref(transfer_ref, from, amount);
        deposit_with_ref(transfer_ref, to, fa);
    }

    /// Mutate specified fields of the fungible asset's `Metadata`.
    public fun mutate_metadata(
        metadata_ref: &MutateMetadataRef,
        name: Option<String>,
        symbol: Option<String>,
        decimals: Option<u8>,
        icon_uri: Option<String>,
        project_uri: Option<String>
    ) acquires Metadata, ExtraMetadata {
        let metadata_address = object::object_address(&metadata_ref.metadata);
        if (!exists<ExtraMetadata>(metadata_address)) {
            let metadata = borrow_global<Metadata>(metadata_address);
            move_to(
                &account::create_signer(metadata_address),
                ExtraMetadata {
                    name: metadata.name,
                    symbol: metadata.symbol,
                    decimals: metadata.decimals,
                    icon_uri: metadata.icon_uri,
                    project_uri: metadata.project_uri
                }
            );
        };

        let mutable_metadata = borrow_global_mut<ExtraMetadata>(metadata_address);
        if (option::is_some(&name)) {
            let name = option::extract(&mut name);
            assert!(
                string::length(&name) <= MAX_NAME_LENGTH,
                error::out_of_range(ENAME_TOO_LONG)
            );
            mutable_metadata.name = name;
        };
        if (option::is_some(&symbol)) {
            let symbol = option::extract(&mut symbol);
            assert!(
                string::length(&symbol) <= MAX_SYMBOL_LENGTH,
                error::out_of_range(ESYMBOL_TOO_LONG)
            );
            mutable_metadata.symbol = symbol;
        };
        if (option::is_some(&decimals)) {
            let decimals = option::extract(&mut decimals);
            assert!(decimals <= MAX_DECIMALS, error::out_of_range(EDECIMALS_TOO_LARGE));
            mutable_metadata.decimals = decimals;
        };
        if (option::is_some(&icon_uri)) {
            let icon_uri = option::extract(&mut icon_uri);
            assert!(
                string::length(&icon_uri) <= MAX_URI_LENGTH,
                error::out_of_range(EURI_TOO_LONG)
            );
            mutable_metadata.icon_uri = icon_uri;
        };
        if (option::is_some(&project_uri)) {
            let project_uri = option::extract(&mut project_uri);
            assert!(
                string::length(&project_uri) <= MAX_URI_LENGTH,
                error::out_of_range(EURI_TOO_LONG)
            );
            mutable_metadata.project_uri = project_uri;
        };
    }

    /// Transfer an `amount` of fungible asset from `from_store`, which should be owned by `sender`, to `receiver`.
    /// Note: it does not move the underlying object.
    ///
    /// This function is only callable by the chain.
    public(friend) fun sudo_transfer<T: key>(
        sender: &signer,
        from: Object<T>,
        to: Object<T>,
        amount: u64
    ) acquires FungibleStore, DispatchFunctionStore {
        let fa = withdraw(sender, from, amount);
        sudo_deposit(to, fa);
    }

    /// Deposit `amount` of the fungible asset to `store`.
    ///
    /// This function is only callable by the chain.
    public(friend) fun sudo_deposit<T: key>(
        store: Object<T>, fa: FungibleAsset
    ) acquires FungibleStore, DispatchFunctionStore {
        sudo_deposit_sanity_check(store, true);
        deposit_internal(object::object_address(&store), fa);
    }

    /// Create a fungible asset with zero amount.
    /// This can be useful when starting a series of computations where the initial value is 0.
    public fun zero<T: key>(metadata: Object<T>): FungibleAsset {
        FungibleAsset { metadata: object::convert(metadata), amount: 0 }
    }

    /// Extract a given amount from the given fungible asset and return a new one.
    public fun extract(fungible_asset: &mut FungibleAsset, amount: u64): FungibleAsset {
        assert!(
            fungible_asset.amount >= amount,
            error::invalid_argument(EINSUFFICIENT_BALANCE)
        );
        fungible_asset.amount = fungible_asset.amount - amount;
        FungibleAsset { metadata: fungible_asset.metadata, amount }
    }

    /// "Merges" the two given fungible assets. The fungible asset passed in as `dst_fungible_asset` will have a value
    /// equal to the sum of the two (`dst_fungible_asset` and `src_fungible_asset`).
    public fun merge(
        dst_fungible_asset: &mut FungibleAsset, src_fungible_asset: FungibleAsset
    ) {
        let FungibleAsset { metadata, amount } = src_fungible_asset;
        assert!(
            metadata == dst_fungible_asset.metadata,
            error::invalid_argument(EFUNGIBLE_ASSET_MISMATCH)
        );
        dst_fungible_asset.amount = dst_fungible_asset.amount + amount;
    }

    /// Destroy an empty fungible asset.
    public fun destroy_zero(fungible_asset: FungibleAsset) {
        let FungibleAsset { amount, metadata: _ } = fungible_asset;
        assert!(
            amount == 0,
            error::invalid_argument(EAMOUNT_IS_NOT_ZERO)
        );
    }

    public(friend) fun deposit_internal(
        store_addr: address, fa: FungibleAsset
    ) acquires FungibleStore {
        let FungibleAsset { metadata, amount } = fa;
        assert!(
            exists<FungibleStore>(store_addr),
            error::not_found(EFUNGIBLE_STORE_EXISTENCE)
        );
        let store = borrow_global_mut<FungibleStore>(store_addr);
        assert!(
            metadata == store.metadata,
            error::invalid_argument(EFUNGIBLE_ASSET_AND_STORE_MISMATCH)
        );

        if (amount == 0) return;

        store.balance = store.balance + amount;

        // emit event
        let metadata_addr = object::object_address(&metadata);
        event::emit(DepositEvent { store_addr, metadata_addr, amount });
        let fungible_store = object::address_to_object<FungibleStore>(store_addr);
        let owner_addr = object::owner(fungible_store);
        event::emit(DepositOwnerEvent { owner: owner_addr });
    }

    /// Extract `amount` of the fungible asset from `store`.
    public(friend) fun withdraw_internal(
        store_addr: address, amount: u64
    ): FungibleAsset acquires FungibleStore {
        let store = borrow_global_mut<FungibleStore>(store_addr);
        let metadata = store.metadata;
        if (amount == 0) return zero(metadata);

        assert!(
            store.balance >= amount,
            error::invalid_argument(EINSUFFICIENT_BALANCE)
        );
        store.balance = store.balance - amount;

        // emit event
        let metadata_addr = object::object_address(&metadata);
        event::emit(WithdrawEvent { store_addr, metadata_addr, amount });
        let fungible_store = object::address_to_object<FungibleStore>(store_addr);
        let owner_addr = object::owner(fungible_store);
        event::emit(WithdrawOwnerEvent { owner: owner_addr });

        FungibleAsset { metadata, amount }
    }

    /// Increase the supply of a fungible asset by minting.
    fun increase_supply<T: key>(metadata: Object<T>, amount: u64) acquires Supply {
        if (amount == 0) return;

        let metadata_address = object::object_address(&metadata);
        assert!(
            exists<Supply>(metadata_address),
            error::not_found(ESUPPLY_NOT_FOUND)
        );
        let supply = borrow_global_mut<Supply>(metadata_address);
        if (option::is_some(&supply.maximum)) {
            let max = *option::borrow_mut(&mut supply.maximum);
            assert!(
                max - supply.current >= (amount as u128),
                error::out_of_range(EMAX_SUPPLY_EXCEEDED)
            )
        };
        supply.current = supply.current + (amount as u128);
    }

    /// Decrease the supply of a fungible asset by burning.
    fun decrease_supply<T: key>(metadata: Object<T>, amount: u64) acquires Supply {
        if (amount == 0) return;

        let metadata_address = object::object_address(&metadata);
        assert!(
            exists<Supply>(metadata_address),
            error::not_found(ESUPPLY_NOT_FOUND)
        );
        let supply = borrow_global_mut<Supply>(metadata_address);
        assert!(
            supply.current >= (amount as u128),
            error::invalid_state(ESUPPLY_UNDERFLOW)
        );
        supply.current = supply.current - (amount as u128);
    }

    fun is_module_account_store_addr(store_addr: address): bool {
        let fungible_store = object::address_to_object<FungibleStore>(store_addr);
        let owner_addr = object::owner(fungible_store);
        let (found, info) = account::get_account_info(owner_addr);
        found && account::is_module_account_with_info(&info)
    }

    fun is_blocked_store_addr(store_addr: address): bool {
        let fungible_store = object::address_to_object<FungibleStore>(store_addr);
        let owner_addr = object::owner(fungible_store);
        let (found, info) = account::get_account_info(owner_addr);
        found && account::is_blocked_with_info(&info)
    }

    inline fun borrow_fungible_metadata<T: key>(metadata: &Object<T>): &Metadata acquires Metadata {
        let addr = object::object_address(metadata);
        borrow_global<Metadata>(addr)
    }

    inline fun borrow_fungible_metadata_mut<T: key>(
        metadata: &Object<T>
    ): &mut Metadata acquires Metadata {
        let addr = object::object_address(metadata);
        borrow_global_mut<Metadata>(addr)
    }

    inline fun borrow_store_resource<T: key>(
        store: &Object<T>
    ): &FungibleStore acquires FungibleStore {
        borrow_global<FungibleStore>(object::object_address(store))
    }

    #[test_only]
    struct TestToken has key {}

    #[test_only]
    public fun create_test_token(creator: &signer): (ConstructorRef, Object<TestToken>) {
        let creator_ref = object::create_named_object(creator, b"TEST");
        let object_signer = object::generate_signer(&creator_ref);
        move_to(&object_signer, TestToken {});

        let token = object::object_from_constructor_ref<TestToken>(&creator_ref);
        (creator_ref, token)
    }

    #[test_only]
    public fun init_test_metadata(
        constructor_ref: &ConstructorRef
    ): (MintRef, TransferRef, BurnRef, MutateMetadataRef) {
        add_fungibility(
            constructor_ref,
            option::some(100) /* max supply */,
            string::utf8(b"TEST"),
            string::utf8(b"@@"),
            0,
            string::utf8(b"http://www.example.com/favicon.ico"),
            string::utf8(b"http://www.example.com")
        );
        let mint_ref = generate_mint_ref(constructor_ref);
        let burn_ref = generate_burn_ref(constructor_ref);
        let transfer_ref = generate_transfer_ref(constructor_ref);
        let mutate_metadata_ref = generate_mutate_metadata_ref(constructor_ref);
        (mint_ref, transfer_ref, burn_ref, mutate_metadata_ref)
    }

    #[test_only]
    public fun create_fungible_asset(
        creator: &signer
    ): (MintRef, TransferRef, BurnRef, MutateMetadataRef, Object<Metadata>) {
        let (creator_ref, token_object) = create_test_token(creator);
        let (mint, transfer, burn, mutate_metadata) = init_test_metadata(&creator_ref);
        (mint, transfer, burn, mutate_metadata, object::convert(token_object))
    }

    #[test_only]
    public fun create_test_store<T: key>(
        owner: &signer, metadata: Object<T>
    ): Object<FungibleStore> {
        let owner_addr = signer::address_of(owner);
        create_store(
            &object::create_object(owner_addr, true),
            metadata
        )
    }

    #[test(creator = @0xcafe)]
    fun test_metadata_basic_flow(creator: &signer) acquires Metadata, Supply, ExtraMetadata {
        let (creator_ref, metadata) = create_test_token(creator);
        init_test_metadata(&creator_ref);
        assert!(supply(metadata) == option::some(0), 1);
        assert!(maximum(metadata) == option::some(100), 2);
        assert!(name(metadata) == string::utf8(b"TEST"), 3);
        assert!(symbol(metadata) == string::utf8(b"@@"), 4);
        assert!(decimals(metadata) == 0, 5);

        increase_supply(metadata, 50);
        assert!(supply(metadata) == option::some(50), 6);
        decrease_supply(metadata, 30);
        assert!(supply(metadata) == option::some(20), 7);
    }

    #[test(creator = @0xcafe)]
    #[expected_failure(abort_code = 0x20005, location = Self)]
    fun test_supply_overflow(creator: &signer) acquires Supply {
        let (creator_ref, metadata) = create_test_token(creator);
        init_test_metadata(&creator_ref);
        increase_supply(metadata, 101);
    }

    #[test(creator = @0xcafe)]
    fun test_create_and_remove_store(creator: &signer) acquires FungibleStore {
        let (_, _, _, _, metadata) = create_fungible_asset(creator);
        let creator_ref = object::create_object(signer::address_of(creator), true);
        create_store(&creator_ref, metadata);
        let delete_ref = object::generate_delete_ref(&creator_ref);
        remove_store(&delete_ref);
    }

    #[test(creator = @0xcafe, aaron = @0xface)]
    fun test_e2e_basic_flow(
        creator: &signer, aaron: &signer
    ) acquires FungibleStore, Supply, DispatchFunctionStore, Metadata, ExtraMetadata {
        let (mint_ref, transfer_ref, burn_ref, mutate_metadata_ref, test_token) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;
        let creator_store = create_test_store(creator, metadata);
        let aaron_store = create_test_store(aaron, metadata);

        assert!(supply(test_token) == option::some(0), 1);
        // Mint
        let fa = mint(&mint_ref, 100);
        assert!(supply(test_token) == option::some(100), 2);
        // Deposit
        deposit(creator_store, fa);
        // Withdraw
        let fa = withdraw(creator, creator_store, 80);
        assert!(supply(test_token) == option::some(100), 3);
        deposit(aaron_store, fa);
        // Burn
        burn_from(&burn_ref, aaron_store, 30);
        assert!(supply(test_token) == option::some(70), 4);
        // Transfer
        transfer(creator, creator_store, aaron_store, 10);
        assert!(balance(creator_store) == 10, 5);
        assert!(balance(aaron_store) == 60, 6);

        set_frozen_flag(&transfer_ref, aaron_store, true);
        assert!(is_frozen(aaron_store), 7);

        // Mutate Metadata
        mutate_metadata(
            &mutate_metadata_ref,
            option::some(string::utf8(b"mutated_name")),
            option::some(string::utf8(b"mutated_symbol")),
            option::none(),
            option::none(),
            option::none()
        );
        assert!(name(metadata) == string::utf8(b"mutated_name"), 8);
        assert!(symbol(metadata) == string::utf8(b"mutated_symbol"), 9);
        assert!(raw_symbol(metadata) == string::utf8(b"@@"), 10);
        assert!(decimals(metadata) == 0, 11);
        assert!(
            icon_uri(metadata) == string::utf8(b"http://www.example.com/favicon.ico"),
            12
        );
        assert!(
            project_uri(metadata) == string::utf8(b"http://www.example.com"),
            13
        );
    }

    #[test(creator = @0xcafe)]
    #[expected_failure(abort_code = 0x50003, location = Self)]
    fun test_frozen(creator: &signer) acquires FungibleStore, Supply, DispatchFunctionStore {
        let (mint_ref, transfer_ref, _burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);

        let creator_store = create_test_store(creator, mint_ref.metadata);
        let fa = mint(&mint_ref, 100);
        set_frozen_flag(&transfer_ref, creator_store, true);
        deposit(creator_store, fa);
    }

    #[test(creator = @0xcafe, aaron = @0xface)]
    fun test_transfer_with_ref(
        creator: &signer, aaron: &signer
    ) acquires FungibleStore, Supply, DispatchFunctionStore {
        let (mint_ref, transfer_ref, _burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;
        let creator_store = create_test_store(creator, metadata);
        let aaron_store = create_test_store(aaron, metadata);

        let fa = mint(&mint_ref, 100);
        set_frozen_flag(&transfer_ref, creator_store, true);
        set_frozen_flag(&transfer_ref, aaron_store, true);
        deposit_with_ref(&transfer_ref, creator_store, fa);
        transfer_with_ref(&transfer_ref, creator_store, aaron_store, 80);
        assert!(balance(creator_store) == 20, 1);
        assert!(balance(aaron_store) == 80, 2);
        assert!(!!is_frozen(creator_store), 3);
        assert!(!!is_frozen(aaron_store), 4);
    }

    #[test(creator = @0xcafe)]
    fun test_merge_and_exact(creator: &signer) acquires Supply {
        let (mint_ref, _transfer_ref, burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let fa = mint(&mint_ref, 100);
        let cash = extract(&mut fa, 80);
        assert!(fa.amount == 20, 1);
        assert!(cash.amount == 80, 2);
        let more_cash = extract(&mut fa, 20);
        destroy_zero(fa);
        merge(&mut cash, more_cash);
        assert!(cash.amount == 100, 3);
        burn(&burn_ref, cash);
    }

    #[test(creator = @0xcafe)]
    #[expected_failure(abort_code = 0x10012, location = Self)]
    fun test_add_fungibility_to_deletable_object(creator: &signer) {
        let creator_ref = &object::create_object(signer::address_of(creator), true);
        init_test_metadata(creator_ref);
    }

    #[test(creator = @0xcafe, aaron = @0xface)]
    #[expected_failure(abort_code = 0x10006, location = Self)]
    fun test_fungible_asset_mismatch_when_merge(
        creator: &signer, aaron: &signer
    ) {
        let (_, _, _, _, metadata1) = create_fungible_asset(creator);
        let (_, _, _, _, metadata2) = create_fungible_asset(aaron);
        let base = FungibleAsset { metadata: metadata1, amount: 1 };
        let addon = FungibleAsset { metadata: metadata2, amount: 1 };
        merge(&mut base, addon);
        let FungibleAsset { metadata: _, amount: _ } = base;
    }

    #[test(creator = @0xcafe, module_acc = @0x123)]
    #[expected_failure(abort_code = 0x1005B, location = Self)]
    fun test_freeze_module_account_store(
        creator: &signer, module_acc: &signer
    ) acquires FungibleStore {
        let (mint_ref, transfer_ref, _burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;

        let module_acc_store = create_test_store(module_acc, metadata);
        account::set_account_info(signer::address_of(module_acc), 10, 0, 3, false);

        set_frozen_flag(&transfer_ref, module_acc_store, true);
    }

    #[test(creator = @0xcafe, module_acc = @0x123)]
    #[expected_failure(abort_code = 0x1005B, location = Self)]
    fun test_burn_module_account_funds(
        creator: &signer, module_acc: &signer
    ) acquires FungibleStore, Supply, DispatchFunctionStore {
        let (mint_ref, _transfer_ref, burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;

        let module_acc_store = create_test_store(module_acc, metadata);
        account::set_account_info(signer::address_of(module_acc), 10, 0, 3, false);

        let fa = mint(&mint_ref, 100);
        deposit(module_acc_store, fa);
        burn_from(&burn_ref, module_acc_store, 30);
    }

    #[test(creator = @0xcafe, module_acc = @0x123)]
    #[expected_failure(abort_code = 0x1005B, location = Self)]
    fun test_withdraw_module_account_funds_with_ref(
        creator: &signer, module_acc: &signer
    ) acquires FungibleStore, Supply, DispatchFunctionStore {
        let (mint_ref, transfer_ref, _burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;

        let module_acc_store = create_test_store(module_acc, metadata);
        account::set_account_info(signer::address_of(module_acc), 10, 0, 3, false);

        let fa = mint(&mint_ref, 100);
        deposit(module_acc_store, fa);
        let fa = withdraw_with_ref(&transfer_ref, module_acc_store, 30);
        deposit(module_acc_store, fa);
    }

    #[test(creator = @0xcafe, blocked_acc = @0x123)]
    #[expected_failure(abort_code = 0x1005C, location = Self)]
    fun test_deposit_blocked_account(
        creator: &signer, blocked_acc: &signer
    ) acquires FungibleStore, Supply, DispatchFunctionStore {
        let (mint_ref, _transfer_ref, _burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;

        let blocked_acc_store = create_test_store(blocked_acc, metadata);
        account::set_account_info(signer::address_of(blocked_acc), 10, 0, 3, true);

        let fa = mint(&mint_ref, 100);
        deposit(blocked_acc_store, fa);
    }

    #[test(creator = @0xcafe, blocked_acc = @0x123)]
    #[expected_failure(abort_code = 0x1005C, location = Self)]
    fun test_deposit_blocked_account_with_ref(
        creator: &signer, blocked_acc: &signer
    ) acquires FungibleStore, Supply {
        let (mint_ref, transfer_ref, _burn_ref, _mutate_metadata_ref, _) =
            create_fungible_asset(creator);
        let metadata = mint_ref.metadata;

        let blocked_acc_store = create_test_store(blocked_acc, metadata);
        account::set_account_info(signer::address_of(blocked_acc), 10, 0, 3, true);

        let fa = mint(&mint_ref, 100);
        deposit_with_ref(&transfer_ref, blocked_acc_store, fa);
    }
}
