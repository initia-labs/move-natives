
<a id="0x1_minitswap"></a>

# Module `0x1::minitswap`



-  [Resource `ModuleStore`](#0x1_minitswap_ModuleStore)
-  [Resource `VirtualPool`](#0x1_minitswap_VirtualPool)
-  [Struct `ProvideEvent`](#0x1_minitswap_ProvideEvent)
-  [Struct `WithdrawEvent`](#0x1_minitswap_WithdrawEvent)
-  [Struct `SwapEvent`](#0x1_minitswap_SwapEvent)
-  [Struct `RebalanceEvent`](#0x1_minitswap_RebalanceEvent)
-  [Constants](#@Constants_0)
-  [Function `get_pool_amount`](#0x1_minitswap_get_pool_amount)
-  [Function `get_pool_amount_by_denom`](#0x1_minitswap_get_pool_amount_by_denom)
-  [Function `get_peg_keeper_balance`](#0x1_minitswap_get_peg_keeper_balance)
-  [Function `get_peg_keeper_balance_by_denom`](#0x1_minitswap_get_peg_keeper_balance_by_denom)
-  [Function `swap_simulation`](#0x1_minitswap_swap_simulation)
-  [Function `swap_simulation_by_denom`](#0x1_minitswap_swap_simulation_by_denom)
-  [Function `create_pool`](#0x1_minitswap_create_pool)
-  [Function `deactivate`](#0x1_minitswap_deactivate)
-  [Function `activate`](#0x1_minitswap_activate)
-  [Function `change_pool_size`](#0x1_minitswap_change_pool_size)
-  [Function `update_module_params`](#0x1_minitswap_update_module_params)
-  [Function `update_pool_params`](#0x1_minitswap_update_pool_params)
-  [Function `provide`](#0x1_minitswap_provide)
-  [Function `withdraw`](#0x1_minitswap_withdraw)
-  [Function `swap`](#0x1_minitswap_swap)
-  [Function `rebalance`](#0x1_minitswap_rebalance)
-  [Function `provide_internal`](#0x1_minitswap_provide_internal)
-  [Function `withdraw_internal`](#0x1_minitswap_withdraw_internal)
-  [Function `swap_internal`](#0x1_minitswap_swap_internal)
-  [Function `rebalance_internal`](#0x1_minitswap_rebalance_internal)


<pre><code><b>use</b> <a href="block.md#0x1_block">0x1::block</a>;
<b>use</b> <a href="coin.md#0x1_coin">0x1::coin</a>;
<b>use</b> <a href="decimal128.md#0x1_decimal128">0x1::decimal128</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error">0x1::error</a>;
<b>use</b> <a href="event.md#0x1_event">0x1::event</a>;
<b>use</b> <a href="fungible_asset.md#0x1_fungible_asset">0x1::fungible_asset</a>;
<b>use</b> <a href="object.md#0x1_object">0x1::object</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option">0x1::option</a>;
<b>use</b> <a href="primary_fungible_store.md#0x1_primary_fungible_store">0x1::primary_fungible_store</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">0x1::signer</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string">0x1::string</a>;
<b>use</b> <a href="table.md#0x1_table">0x1::table</a>;
</code></pre>



<a id="0x1_minitswap_ModuleStore"></a>

## Resource `ModuleStore`



<pre><code><b>struct</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> <b>has</b> key
</code></pre>



##### Fields


<dl>
<dt>
<code>extend_ref: <a href="object.md#0x1_object_ExtendRef">object::ExtendRef</a></code>
</dt>
<dd>
 Extend reference
</dd>
<dt>
<code>pools: <a href="table.md#0x1_table_Table">table::Table</a>&lt;<a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="minitswap.md#0x1_minitswap_VirtualPool">minitswap::VirtualPool</a>&gt;&gt;</code>
</dt>
<dd>
 List of pools
</dd>
<dt>
<code>l1_init_amount: u64</code>
</dt>
<dd>
 Not real balance, the amount for shares
</dd>
<dt>
<code>swap_fee_rate: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a></code>
</dt>
<dd>
 Swap fee rate
</dd>
<dt>
<code>max_change_rate: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a></code>
</dt>
<dd>
 Max pool size change rate
</dd>
<dt>
<code>mint_cap: <a href="coin.md#0x1_coin_MintCapability">coin::MintCapability</a></code>
</dt>
<dd>
 mint capability of liquidity token
</dd>
<dt>
<code>burn_cap: <a href="coin.md#0x1_coin_BurnCapability">coin::BurnCapability</a></code>
</dt>
<dd>
 burn capability of liquidity token
</dd>
</dl>


<a id="0x1_minitswap_VirtualPool"></a>

## Resource `VirtualPool`



<pre><code><b>struct</b> <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> <b>has</b> key
</code></pre>



##### Fields


<dl>
<dt>
<code>extend_ref: <a href="object.md#0x1_object_ExtendRef">object::ExtendRef</a></code>
</dt>
<dd>
 Extend reference
</dd>
<dt>
<code>pool_size: u64</code>
</dt>
<dd>
 Z. Virtual pool size
</dd>
<dt>
<code>recover_velocity: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a></code>
</dt>
<dd>
 V. Recover velocity. Real recover amount = Vt
</dd>
<dt>
<code>max_ratio: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a></code>
</dt>
<dd>
 R_max max recover ratio
</dd>
<dt>
<code>recover_param: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a></code>
</dt>
<dd>
 f. Flexibility
</dd>
<dt>
<code>l1_pool_amount: u64</code>
</dt>
<dd>
 Virtual pool amount of L1 INIT
</dd>
<dt>
<code>l2_pool_amount: u64</code>
</dt>
<dd>
 Virtual pool amount of L2 INIT
</dd>
<dt>
<code>last_recovered_timestamp: u64</code>
</dt>
<dd>
 last recovered timestamp
</dd>
<dt>
<code>virtual_l1_balance: u64</code>
</dt>
<dd>
 L1 INIT balance of peg keeper (negative value)
</dd>
<dt>
<code>virtual_l2_balance: u64</code>
</dt>
<dd>
 L2 INIT balance of peg keeper
</dd>
<dt>
<code>ann: u64</code>
</dt>
<dd>
 ANN
</dd>
<dt>
<code>active: bool</code>
</dt>
<dd>
 Is pool in active
</dd>
</dl>


<a id="0x1_minitswap_ProvideEvent"></a>

## Struct `ProvideEvent`

Event emitted when provide.


<pre><code>#[<a href="event.md#0x1_event">event</a>]
<b>struct</b> <a href="minitswap.md#0x1_minitswap_ProvideEvent">ProvideEvent</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>provide_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>share_amount: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_minitswap_WithdrawEvent"></a>

## Struct `WithdrawEvent`

Event emitted when withdraw.


<pre><code>#[<a href="event.md#0x1_event">event</a>]
<b>struct</b> <a href="minitswap.md#0x1_minitswap_WithdrawEvent">WithdrawEvent</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>withdraw_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>share_amount: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_minitswap_SwapEvent"></a>

## Struct `SwapEvent`

Event emitted when swap token.


<pre><code>#[<a href="event.md#0x1_event">event</a>]
<b>struct</b> <a href="minitswap.md#0x1_minitswap_SwapEvent">SwapEvent</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>offer_coin: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>return_coin: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>peg_keeper_offer_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>peg_keeper_return_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>offer_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>return_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>fee_amount: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_minitswap_RebalanceEvent"></a>

## Struct `RebalanceEvent`

Event emitted when rebalance peg keeper's balances.


<pre><code>#[<a href="event.md#0x1_event">event</a>]
<b>struct</b> <a href="minitswap.md#0x1_minitswap_RebalanceEvent">RebalanceEvent</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>offer_coin: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>return_coin: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>offer_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>return_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>fee_amount: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="@Constants_0"></a>

## Constants


<a id="0x1_minitswap_EMIN_RETURN"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_EMIN_RETURN">EMIN_RETURN</a>: u64 = 9;
</code></pre>



<a id="0x1_minitswap_A_PRECISION"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_A_PRECISION">A_PRECISION</a>: u256 = 100;
</code></pre>



<a id="0x1_minitswap_EINACTIVE"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_EINACTIVE">EINACTIVE</a>: u64 = 5;
</code></pre>



<a id="0x1_minitswap_EL2_PRICE_TOO_LOW"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_EL2_PRICE_TOO_LOW">EL2_PRICE_TOO_LOW</a>: u64 = 7;
</code></pre>



<a id="0x1_minitswap_EMAX_CHANGE"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_EMAX_CHANGE">EMAX_CHANGE</a>: u64 = 8;
</code></pre>



<a id="0x1_minitswap_ENOT_CHAIN"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_ENOT_CHAIN">ENOT_CHAIN</a>: u64 = 1;
</code></pre>



<a id="0x1_minitswap_ENOT_ENOUGH_BALANCE"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_ENOT_ENOUGH_BALANCE">ENOT_ENOUGH_BALANCE</a>: u64 = 4;
</code></pre>



<a id="0x1_minitswap_ENOT_L1_INIT"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_ENOT_L1_INIT">ENOT_L1_INIT</a>: u64 = 3;
</code></pre>



<a id="0x1_minitswap_ENOT_SHARE_TOKEN"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_ENOT_SHARE_TOKEN">ENOT_SHARE_TOKEN</a>: u64 = 6;
</code></pre>



<a id="0x1_minitswap_EPOOL_NOT_FOUND"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_EPOOL_NOT_FOUND">EPOOL_NOT_FOUND</a>: u64 = 2;
</code></pre>



<a id="0x1_minitswap_EPOOL_SIZE"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_EPOOL_SIZE">EPOOL_SIZE</a>: u64 = 10;
</code></pre>



<a id="0x1_minitswap_SYMBOL"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_SYMBOL">SYMBOL</a>: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt; = [109, 105, 110, 105, 116, 115, 119, 97, 112, 95, 108, 112];
</code></pre>



<a id="0x1_minitswap_U64_MAX"></a>



<pre><code><b>const</b> <a href="minitswap.md#0x1_minitswap_U64_MAX">U64_MAX</a>: u128 = 18446744073709551615;
</code></pre>



<a id="0x1_minitswap_get_pool_amount"></a>

## Function `get_pool_amount`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_pool_amount">get_pool_amount</a>(l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, after_peg_keeper_swap: bool): (u64, u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_pool_amount">get_pool_amount</a>(
    l2_init_metadata: Object&lt;Metadata&gt;,
    after_peg_keeper_swap: bool,
): (u64, u64) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> (_, pool) = <a href="minitswap.md#0x1_minitswap_borrow_all">borrow_all</a>(l2_init_metadata);
    <b>assert</b>!(pool.active, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="minitswap.md#0x1_minitswap_EINACTIVE">EINACTIVE</a>));
    <b>let</b> (swap_amount, return_amount) = <b>if</b> (after_peg_keeper_swap) {
        <a href="minitswap.md#0x1_minitswap_calc_peg_keeper_swap">calc_peg_keeper_swap</a>(pool)
    } <b>else</b> {
        (0, 0)
    };
    <b>return</b> (pool.l1_pool_amount + swap_amount, pool.l2_pool_amount - return_amount)
}
</code></pre>



<a id="0x1_minitswap_get_pool_amount_by_denom"></a>

## Function `get_pool_amount_by_denom`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_pool_amount_by_denom">get_pool_amount_by_denom</a>(l2_init_denom: <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>, after_peg_keeper_swap: bool): (u64, u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_pool_amount_by_denom">get_pool_amount_by_denom</a>(
    l2_init_denom: String,
    after_peg_keeper_swap: bool,
): (u64, u64) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> l2_init_metadata = <a href="coin.md#0x1_coin_denom_to_metadata">coin::denom_to_metadata</a>(l2_init_denom);
    <a href="minitswap.md#0x1_minitswap_get_pool_amount">get_pool_amount</a>(l2_init_metadata, after_peg_keeper_swap)
}
</code></pre>



<a id="0x1_minitswap_get_peg_keeper_balance"></a>

## Function `get_peg_keeper_balance`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_peg_keeper_balance">get_peg_keeper_balance</a>(l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, after_peg_keeper_swap: bool): (u64, u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_peg_keeper_balance">get_peg_keeper_balance</a>(
    l2_init_metadata: Object&lt;Metadata&gt;,
    after_peg_keeper_swap: bool,
): (u64, u64) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> (_, pool) = <a href="minitswap.md#0x1_minitswap_borrow_all">borrow_all</a>(l2_init_metadata);
    <b>assert</b>!(pool.active, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="minitswap.md#0x1_minitswap_EINACTIVE">EINACTIVE</a>));
    <b>let</b> (swap_amount, return_amount) = <b>if</b> (after_peg_keeper_swap) {
        <a href="minitswap.md#0x1_minitswap_calc_peg_keeper_swap">calc_peg_keeper_swap</a>(pool)
    } <b>else</b> {
        (0, 0)
    };

    <b>return</b> (pool.virtual_l1_balance + swap_amount, pool.virtual_l2_balance + return_amount)
}
</code></pre>



<a id="0x1_minitswap_get_peg_keeper_balance_by_denom"></a>

## Function `get_peg_keeper_balance_by_denom`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_peg_keeper_balance_by_denom">get_peg_keeper_balance_by_denom</a>(l2_init_denom: <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>, after_peg_keeper_swap: bool): (u64, u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_get_peg_keeper_balance_by_denom">get_peg_keeper_balance_by_denom</a>(
    l2_init_denom: String,
    after_peg_keeper_swap: bool,
): (u64, u64) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> l2_init_metadata = <a href="coin.md#0x1_coin_denom_to_metadata">coin::denom_to_metadata</a>(l2_init_denom);
    <a href="minitswap.md#0x1_minitswap_get_peg_keeper_balance">get_peg_keeper_balance</a>(l2_init_metadata, after_peg_keeper_swap)
}
</code></pre>



<a id="0x1_minitswap_swap_simulation"></a>

## Function `swap_simulation`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap_simulation">swap_simulation</a>(offer_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, return_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, offer_amount: u64): (u64, u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap_simulation">swap_simulation</a>(
    offer_metadata: Object&lt;Metadata&gt;,
    return_metadata: Object&lt;Metadata&gt;,
    offer_amount: u64,
): (u64, u64) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> is_l1_init_offered = <a href="minitswap.md#0x1_minitswap_is_l1_init_metadata">is_l1_init_metadata</a>(offer_metadata);
    <b>let</b> l2_init_metadata = <b>if</b>(is_l1_init_offered) {
        return_metadata
    } <b>else</b> {
        offer_metadata
    };

    <b>let</b> (_, pool) = <a href="minitswap.md#0x1_minitswap_borrow_all">borrow_all</a>(l2_init_metadata);
    <b>let</b> (peg_keeper_offer_amount, peg_keeper_return_amount) = <a href="minitswap.md#0x1_minitswap_calc_peg_keeper_swap">calc_peg_keeper_swap</a>(pool);

    <b>let</b> (l1_pool_amount, l2_pool_amount) = <a href="minitswap.md#0x1_minitswap_get_pool_amount">get_pool_amount</a>(l2_init_metadata, <b>true</b>);
    l1_pool_amount = l1_pool_amount + peg_keeper_offer_amount;
    l2_pool_amount = l2_pool_amount - peg_keeper_return_amount;

    <b>let</b> (module_store, pool) = <a href="minitswap.md#0x1_minitswap_borrow_all">borrow_all</a>(l2_init_metadata);
    <b>let</b> fee_amount = 0;
    <b>let</b> return_amount = <b>if</b> (is_l1_init_offered) {
        // 0 fee for L1 &gt; L2
        <b>let</b> return_amount = <a href="minitswap.md#0x1_minitswap_get_return_amount">get_return_amount</a>(offer_amount, l1_pool_amount, l2_pool_amount, pool.pool_size, pool.ann);
        <b>assert</b>!(
            l2_pool_amount &gt;= pool.pool_size && l1_pool_amount &lt;= pool.pool_size,
            <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="minitswap.md#0x1_minitswap_EL2_PRICE_TOO_LOW">EL2_PRICE_TOO_LOW</a>),
        );
        return_amount
    } <b>else</b> {
        <b>let</b> return_amount = <a href="minitswap.md#0x1_minitswap_get_return_amount">get_return_amount</a>(offer_amount, l2_pool_amount, l1_pool_amount, pool.pool_size, pool.ann);
        fee_amount = <a href="decimal128.md#0x1_decimal128_mul_u64">decimal128::mul_u64</a>(&module_store.swap_fee_rate, return_amount);
        <b>let</b> return_amount = return_amount - fee_amount;
        return_amount
    };

    (return_amount, fee_amount)
}
</code></pre>



<a id="0x1_minitswap_swap_simulation_by_denom"></a>

## Function `swap_simulation_by_denom`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap_simulation_by_denom">swap_simulation_by_denom</a>(offer_denom: <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>, return_denom: <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>, offer_amount: u64): (u64, u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap_simulation_by_denom">swap_simulation_by_denom</a>(
    offer_denom: String,
    return_denom: String,
    offer_amount: u64,
): (u64, u64) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> offer_metadata = <a href="coin.md#0x1_coin_denom_to_metadata">coin::denom_to_metadata</a>(offer_denom);
    <b>let</b> return_metadata = <a href="coin.md#0x1_coin_denom_to_metadata">coin::denom_to_metadata</a>(return_denom);
    <a href="minitswap.md#0x1_minitswap_swap_simulation">swap_simulation</a>(offer_metadata, return_metadata, offer_amount)
}
</code></pre>



<a id="0x1_minitswap_create_pool"></a>

## Function `create_pool`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_create_pool">create_pool</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, recover_velocity: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>, pool_size: u64, ann: u64, max_ratio: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>, recover_param: <a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_create_pool">create_pool</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    l2_init_metadata: Object&lt;Metadata&gt;,
    recover_velocity: Decimal128,
    pool_size: u64,
    ann: u64,
    max_ratio: Decimal128,
    recover_param: Decimal128,
) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> {
    <a href="minitswap.md#0x1_minitswap_assert_is_chain">assert_is_chain</a>(chain);
    <b>assert</b>!(pool_size &gt; 0, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_EPOOL_SIZE">EPOOL_SIZE</a>));
    <b>let</b> constructor_ref = <a href="object.md#0x1_object_create_object">object::create_object</a>(@initia_std, <b>false</b>);
    <b>let</b> extend_ref = <a href="object.md#0x1_object_generate_extend_ref">object::generate_extend_ref</a>(&constructor_ref);
    <b>let</b> pool_signer = <a href="object.md#0x1_object_generate_signer">object::generate_signer</a>(&constructor_ref);
    <b>let</b> (_, timestamp) = <a href="block.md#0x1_block_get_block_info">block::get_block_info</a>();

    <b>move_to</b>(
        &pool_signer,
        <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
            extend_ref,
            recover_velocity,
            pool_size,
            max_ratio,
            recover_param,
            l1_pool_amount: pool_size,
            l2_pool_amount: pool_size,
            last_recovered_timestamp: timestamp,
            virtual_l1_balance: 0,
            virtual_l2_balance: 0,
            ann,
            active: <b>true</b>,
        }
    );

    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <a href="table.md#0x1_table_add">table::add</a>(&<b>mut</b> module_store.pools, l2_init_metadata, <a href="object.md#0x1_object_object_from_constructor_ref">object::object_from_constructor_ref</a>&lt;<a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a>&gt;(&constructor_ref));
}
</code></pre>



<a id="0x1_minitswap_deactivate"></a>

## Function `deactivate`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_deactivate">deactivate</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_deactivate">deactivate</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: Object&lt;Metadata&gt;) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <a href="minitswap.md#0x1_minitswap_assert_is_chain">assert_is_chain</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> pool_obj = <a href="table.md#0x1_table_borrow">table::borrow</a>(&<b>mut</b> module_store.pools, l2_init_metadata);
    <b>let</b> pool = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a>&gt;(<a href="object.md#0x1_object_object_address">object::object_address</a>(*pool_obj));
    pool.active = <b>false</b>
}
</code></pre>



<a id="0x1_minitswap_activate"></a>

## Function `activate`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_activate">activate</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_activate">activate</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: Object&lt;Metadata&gt;) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <a href="minitswap.md#0x1_minitswap_assert_is_chain">assert_is_chain</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> pool_obj = <a href="table.md#0x1_table_borrow">table::borrow</a>(&<b>mut</b> module_store.pools, l2_init_metadata);
    <b>let</b> pool = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a>&gt;(<a href="object.md#0x1_object_object_address">object::object_address</a>(*pool_obj));
    pool.active = <b>true</b>
}
</code></pre>



<a id="0x1_minitswap_change_pool_size"></a>

## Function `change_pool_size`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_change_pool_size">change_pool_size</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, new_pool_size: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_change_pool_size">change_pool_size</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    l2_init_metadata: Object&lt;Metadata&gt;,
    new_pool_size: u64
) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <a href="minitswap.md#0x1_minitswap_assert_is_chain">assert_is_chain</a>(chain);
    <b>assert</b>!(new_pool_size &gt; 0, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_EPOOL_SIZE">EPOOL_SIZE</a>));
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> pool_obj = <a href="table.md#0x1_table_borrow">table::borrow</a>(&<b>mut</b> module_store.pools, l2_init_metadata);
    <b>let</b> pool = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a>&gt;(<a href="object.md#0x1_object_object_address">object::object_address</a>(*pool_obj));

    <b>let</b> change_rate = <b>if</b> (new_pool_size &gt; pool.pool_size) {
        <a href="decimal128.md#0x1_decimal128_from_ratio_u64">decimal128::from_ratio_u64</a>(new_pool_size - pool.pool_size, pool.pool_size)
    } <b>else</b> {
        <a href="decimal128.md#0x1_decimal128_from_ratio_u64">decimal128::from_ratio_u64</a>(pool.pool_size - new_pool_size, pool.pool_size)
    };

    <b>assert</b>!(<a href="decimal128.md#0x1_decimal128_val">decimal128::val</a>(&module_store.max_change_rate) &gt;= <a href="decimal128.md#0x1_decimal128_val">decimal128::val</a>(&change_rate), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_EMAX_CHANGE">EMAX_CHANGE</a>));

    <b>if</b> (new_pool_size &lt; pool.pool_size) {
        /*
            Decrease size process
            1. Change pool amount <b>as</b> ratio
            2. Calculate diff, <b>update</b> peg keeper's balances

            Net Effect
            This action is same <b>with</b> swap L1 &gt; L2 until pool ratio <b>to</b> be 5:5,
            change pool size and sell some portion of L2 at same price
            - L1 and L2 balances of peg keepers -&gt; L1 decrease L2 increase,
                but L1 decreased amount is smaller than L2 increased amount.
            - Pool ratio doesn't change (= price not change)
        */
        <b>let</b> current_l1_delta = pool.pool_size - pool.l1_pool_amount;
        <b>let</b> current_l2_delta = pool.l2_pool_amount - pool.pool_size;

        <b>let</b> ratio = <a href="decimal128.md#0x1_decimal128_from_ratio_u64">decimal128::from_ratio_u64</a>(new_pool_size, pool.pool_size);
        pool.l1_pool_amount = <a href="decimal128.md#0x1_decimal128_mul_u64">decimal128::mul_u64</a>(&ratio, pool.l1_pool_amount);
        pool.l2_pool_amount = <a href="decimal128.md#0x1_decimal128_mul_u64">decimal128::mul_u64</a>(&ratio, pool.l2_pool_amount);
        pool.pool_size = new_pool_size;

        <b>let</b> l1_delta = pool.pool_size - pool.l1_pool_amount;
        <b>let</b> l2_delta = pool.l2_pool_amount - pool.pool_size;

        <b>let</b> net_l1_delta = current_l1_delta - l1_delta;
        <b>let</b> net_l2_delta = current_l2_delta - l2_delta;

        pool.virtual_l1_balance = pool.virtual_l1_balance + net_l1_delta;
        pool.virtual_l2_balance = pool.virtual_l2_balance + net_l2_delta;
    } <b>else</b> {
        /*
            Increase size process
            1. Swap L1 &gt; L2 <b>to</b> make 5:5
            2. Change pool size
            3. Swap back L2 &gt; L1
                a. If L1 init balance of peg keeper is greater than 0, <b>return</b> it <b>to</b> provider

            Net Effect
            - L1 and L2 balances of peg keepers -&gt; + for L1 and even for L2
            - Ratio of pool -&gt; L2 price decrease
        */

        // 1. swap <b>to</b> make 5:5
        <b>let</b> l1_swap_amount = pool.pool_size - pool.l1_pool_amount;
        <b>let</b> l2_return_amount =  pool.l2_pool_amount - pool.pool_size;
        // pool.l1_pool_amount = pool.pool_size;
        // pool.l2_pool_amount = pool.pool_size;
        pool.virtual_l1_balance = pool.virtual_l1_balance + l1_swap_amount;
        pool.virtual_l2_balance = pool.virtual_l2_balance + l2_return_amount;

        // 2. change pool size
        pool.l1_pool_amount = new_pool_size;
        pool.l2_pool_amount = new_pool_size;
        pool.pool_size = new_pool_size;

        // 3. swap back
        <b>let</b> return_amount = <a href="minitswap.md#0x1_minitswap_get_return_amount">get_return_amount</a>(l2_return_amount, pool.l2_pool_amount, pool.l1_pool_amount, pool.pool_size, pool.ann);
        pool.l2_pool_amount = pool.l2_pool_amount + l2_return_amount;
        pool.l1_pool_amount = pool.l1_pool_amount - return_amount;
        pool.virtual_l2_balance = pool.virtual_l2_balance - l2_return_amount;

        <b>if</b> (pool.virtual_l1_balance &lt; return_amount) {
            <b>let</b> remain = return_amount - pool.virtual_l1_balance;
            module_store.l1_init_amount = module_store.l1_init_amount + remain;
            pool.virtual_l1_balance = 0
        } <b>else</b> {
            pool.virtual_l1_balance = pool.virtual_l1_balance - return_amount;
        }
    }
}
</code></pre>



<a id="0x1_minitswap_update_module_params"></a>

## Function `update_module_params`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_update_module_params">update_module_params</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, swap_fee_rate: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;<a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>&gt;, max_change_rate: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;<a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_update_module_params">update_module_params</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    swap_fee_rate: Option&lt;Decimal128&gt;,
    max_change_rate: Option&lt;Decimal128&gt;,
) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> {
    <a href="minitswap.md#0x1_minitswap_assert_is_chain">assert_is_chain</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);

    <b>if</b> (<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_is_some">option::is_some</a>(&swap_fee_rate)) {
        module_store.swap_fee_rate = <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_extract">option::extract</a>(&<b>mut</b> swap_fee_rate);
    };

    <b>if</b> (<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_is_some">option::is_some</a>(&max_change_rate)) {
        module_store.max_change_rate = <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_extract">option::extract</a>(&<b>mut</b> max_change_rate);
    };
}
</code></pre>



<a id="0x1_minitswap_update_pool_params"></a>

## Function `update_pool_params`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_update_pool_params">update_pool_params</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, recover_velocity: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;<a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>&gt;, ann: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;, max_ratio: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;<a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>&gt;, recover_param: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;<a href="decimal128.md#0x1_decimal128_Decimal128">decimal128::Decimal128</a>&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_update_pool_params">update_pool_params</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    l2_init_metadata: Object&lt;Metadata&gt;,
    recover_velocity: Option&lt;Decimal128&gt;,
    ann: Option&lt;u64&gt;,
    max_ratio: Option&lt;Decimal128&gt;,
    recover_param: Option&lt;Decimal128&gt;,
) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <a href="minitswap.md#0x1_minitswap_assert_is_chain">assert_is_chain</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> pool_obj = <a href="table.md#0x1_table_borrow">table::borrow</a>(&<b>mut</b> module_store.pools, l2_init_metadata);
    <b>let</b> pool = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a>&gt;(<a href="object.md#0x1_object_object_address">object::object_address</a>(*pool_obj));

    <b>if</b> (<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_is_some">option::is_some</a>(&recover_velocity)) {
        pool.recover_velocity = <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_extract">option::extract</a>(&<b>mut</b> recover_velocity);
    };

    // It is okay <b>to</b> change ann immediately cause there are no real provider
    <b>if</b> (<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_is_some">option::is_some</a>(&ann)) {
        pool.ann = <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_extract">option::extract</a>(&<b>mut</b> ann);
    };

    <b>if</b> (<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_is_some">option::is_some</a>(&max_ratio)) {
        pool.max_ratio = <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_extract">option::extract</a>(&<b>mut</b> max_ratio);
    };

    <b>if</b> (<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_is_some">option::is_some</a>(&recover_param)) {
        pool.recover_param = <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_extract">option::extract</a>(&<b>mut</b> recover_param);
    };
}
</code></pre>



<a id="0x1_minitswap_provide"></a>

## Function `provide`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_provide">provide</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, amount: u64, min_return_amount: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_provide">provide</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, amount: u64, min_return_amount: Option&lt;u64&gt;) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> {
    <b>let</b> l1_init = <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(<a href="account.md#0x1_account">account</a>, <a href="minitswap.md#0x1_minitswap_l1_init_metadata">l1_init_metadata</a>(), amount);
    <b>let</b> share_token = <a href="minitswap.md#0x1_minitswap_provide_internal">provide_internal</a>(l1_init);
    <a href="minitswap.md#0x1_minitswap_assert_min_amount">assert_min_amount</a>(&share_token, min_return_amount);
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>), share_token);
}
</code></pre>



<a id="0x1_minitswap_withdraw"></a>

## Function `withdraw`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_withdraw">withdraw</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, amount: u64, min_return_amount: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_withdraw">withdraw</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, amount: u64, min_return_amount: Option&lt;u64&gt;) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> {
    <b>let</b> share_token = <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(<a href="account.md#0x1_account">account</a>, <a href="minitswap.md#0x1_minitswap_share_token_metadata">share_token_metadata</a>(), amount);
    <b>let</b> l1_init = <a href="minitswap.md#0x1_minitswap_withdraw_internal">withdraw_internal</a>(share_token);
    <a href="minitswap.md#0x1_minitswap_assert_min_amount">assert_min_amount</a>(&l1_init, min_return_amount);
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>), l1_init);
}
</code></pre>



<a id="0x1_minitswap_swap"></a>

## Function `swap`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap">swap</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, offer_asset_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, return_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, amount: u64, min_return_amount: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap">swap</a>(
    <a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    offer_asset_metadata: Object&lt;Metadata&gt;,
    return_metadata: Object&lt;Metadata&gt;,
    amount: u64,
    min_return_amount: Option&lt;u64&gt;
) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> offer_asset = <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(<a href="account.md#0x1_account">account</a>, offer_asset_metadata, amount);
    <b>let</b> return_asset = <a href="minitswap.md#0x1_minitswap_swap_internal">swap_internal</a>(offer_asset, return_metadata);
    <a href="minitswap.md#0x1_minitswap_assert_min_amount">assert_min_amount</a>(&return_asset, min_return_amount);
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>), return_asset);
}
</code></pre>



<a id="0x1_minitswap_rebalance"></a>

## Function `rebalance`



<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_rebalance">rebalance</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, l2_asset_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, amount: u64, min_return_amount: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="minitswap.md#0x1_minitswap_rebalance">rebalance</a>(
    <a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    l2_asset_metadata: Object&lt;Metadata&gt;,
    amount: u64,
    min_return_amount: Option&lt;u64&gt;
) <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> l1_init = <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(<a href="account.md#0x1_account">account</a>, <a href="minitswap.md#0x1_minitswap_l1_init_metadata">l1_init_metadata</a>(), amount);
    <b>let</b> l2_init = <a href="minitswap.md#0x1_minitswap_rebalance_internal">rebalance_internal</a>(l1_init, l2_asset_metadata);
    <a href="minitswap.md#0x1_minitswap_assert_min_amount">assert_min_amount</a>(&l2_init, min_return_amount);
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>), l2_init);
}
</code></pre>



<a id="0x1_minitswap_provide_internal"></a>

## Function `provide_internal`



<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_provide_internal">provide_internal</a>(l1_init: <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>): <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_provide_internal">provide_internal</a>(l1_init: FungibleAsset): FungibleAsset <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> {
    <b>assert</b>!(<a href="minitswap.md#0x1_minitswap_is_l1_init">is_l1_init</a>(&l1_init), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_ENOT_L1_INIT">ENOT_L1_INIT</a>));
    <b>let</b> provide_amount = <a href="fungible_asset.md#0x1_fungible_asset_amount">fungible_asset::amount</a>(&l1_init);

    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> total_share = <a href="minitswap.md#0x1_minitswap_total_share">total_share</a>();
    <b>let</b> share_amount = <b>if</b> (total_share == 0) {
        provide_amount
    } <b>else</b> {
        <a href="minitswap.md#0x1_minitswap_mul_div">mul_div</a>(provide_amount, (total_share <b>as</b> u64), module_store.l1_init_amount)
    };
    module_store.l1_init_amount =  module_store.l1_init_amount + provide_amount;

    <b>let</b> module_addr = <a href="object.md#0x1_object_address_from_extend_ref">object::address_from_extend_ref</a>(&module_store.extend_ref);
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(module_addr, l1_init);
    <a href="event.md#0x1_event_emit">event::emit</a>&lt;<a href="minitswap.md#0x1_minitswap_ProvideEvent">ProvideEvent</a>&gt;(
        <a href="minitswap.md#0x1_minitswap_ProvideEvent">ProvideEvent</a> {
            provide_amount,
            share_amount,
        },
    );
    <a href="coin.md#0x1_coin_mint">coin::mint</a>(&module_store.mint_cap, share_amount)
}
</code></pre>



<a id="0x1_minitswap_withdraw_internal"></a>

## Function `withdraw_internal`



<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_withdraw_internal">withdraw_internal</a>(share_token: <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>): <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_withdraw_internal">withdraw_internal</a>(share_token: FungibleAsset): FungibleAsset <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> share_token_metadata = <a href="fungible_asset.md#0x1_fungible_asset_metadata_from_asset">fungible_asset::metadata_from_asset</a>(&share_token);
    <b>assert</b>!(share_token_metadata == <a href="minitswap.md#0x1_minitswap_share_token_metadata">share_token_metadata</a>(), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_ENOT_SHARE_TOKEN">ENOT_SHARE_TOKEN</a>));
    <b>let</b> share_amount = <a href="fungible_asset.md#0x1_fungible_asset_amount">fungible_asset::amount</a>(&share_token);
    <b>let</b> total_share = <a href="minitswap.md#0x1_minitswap_total_share">total_share</a>();
    <b>let</b> withdraw_amount = <a href="minitswap.md#0x1_minitswap_mul_div">mul_div</a>(share_amount, module_store.l1_init_amount, total_share);
    module_store.l1_init_amount =  module_store.l1_init_amount - withdraw_amount;

    <a href="coin.md#0x1_coin_burn">coin::burn</a>(&module_store.burn_cap, share_token);
    <b>let</b> module_signer = <a href="object.md#0x1_object_generate_signer_for_extending">object::generate_signer_for_extending</a>(&module_store.extend_ref);
    <a href="event.md#0x1_event_emit">event::emit</a>&lt;<a href="minitswap.md#0x1_minitswap_WithdrawEvent">WithdrawEvent</a>&gt;(
        <a href="minitswap.md#0x1_minitswap_WithdrawEvent">WithdrawEvent</a> {
            withdraw_amount,
            share_amount,
        },
    );
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(&module_signer, <a href="minitswap.md#0x1_minitswap_l1_init_metadata">l1_init_metadata</a>(), withdraw_amount)
}
</code></pre>



<a id="0x1_minitswap_swap_internal"></a>

## Function `swap_internal`



<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap_internal">swap_internal</a>(offer_asset: <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>, return_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;): <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_swap_internal">swap_internal</a>(
    offer_asset: FungibleAsset,
    return_metadata: Object&lt;Metadata&gt;,
): FungibleAsset <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>let</b> (_, timestamp) = <a href="block.md#0x1_block_get_block_info">block::get_block_info</a>();
    <b>let</b> is_l1_init_offered = <a href="minitswap.md#0x1_minitswap_is_l1_init">is_l1_init</a>(&offer_asset);
    <b>let</b> offer_metadata = <a href="fungible_asset.md#0x1_fungible_asset_metadata_from_asset">fungible_asset::metadata_from_asset</a>(&offer_asset);
    <b>let</b> (module_store, pool, module_signer, pool_signer) = <b>if</b>(is_l1_init_offered) {
        <a href="minitswap.md#0x1_minitswap_borrow_all_mut">borrow_all_mut</a>(return_metadata)
    } <b>else</b> {
        <a href="minitswap.md#0x1_minitswap_borrow_all_mut">borrow_all_mut</a>(offer_metadata)
    };
    <b>assert</b>!(pool.active, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="minitswap.md#0x1_minitswap_EINACTIVE">EINACTIVE</a>));

    <b>let</b> (peg_keeper_offer_amount, peg_keeper_return_amount) = <a href="minitswap.md#0x1_minitswap_calc_peg_keeper_swap">calc_peg_keeper_swap</a>(pool);
    pool.l1_pool_amount = pool.l1_pool_amount + peg_keeper_offer_amount;
    pool.l2_pool_amount = pool.l2_pool_amount - peg_keeper_return_amount;
    pool.virtual_l1_balance = pool.virtual_l1_balance + peg_keeper_offer_amount;
    pool.virtual_l2_balance = pool.virtual_l2_balance + peg_keeper_return_amount;
    pool.last_recovered_timestamp = timestamp;

    <b>let</b> module_addr = <a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(&module_signer);
    <b>let</b> pool_addr = <a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(&pool_signer);

    // user swap
    <b>let</b> offer_amount = <a href="fungible_asset.md#0x1_fungible_asset_amount">fungible_asset::amount</a>(&offer_asset);
    <b>let</b> fee_amount = 0;
    <b>let</b> return_asset = <b>if</b> (is_l1_init_offered) {
        <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(module_addr, offer_asset);
        // 0 fee for L1 &gt; L2
        <b>let</b> return_amount = <a href="minitswap.md#0x1_minitswap_get_return_amount">get_return_amount</a>(offer_amount, pool.l1_pool_amount, pool.l2_pool_amount, pool.pool_size, pool.ann);
        pool.l1_pool_amount = pool.l1_pool_amount + offer_amount;
        pool.l2_pool_amount = pool.l2_pool_amount - return_amount;
        <b>assert</b>!(
            pool.l2_pool_amount &gt;= pool.pool_size && pool.l1_pool_amount &lt;= pool.pool_size,
            <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="minitswap.md#0x1_minitswap_EL2_PRICE_TOO_LOW">EL2_PRICE_TOO_LOW</a>),
        );
        <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(&pool_signer, return_metadata, return_amount)
    } <b>else</b> {
        <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(pool_addr, offer_asset);
        <b>let</b> return_amount = <a href="minitswap.md#0x1_minitswap_get_return_amount">get_return_amount</a>(offer_amount, pool.l2_pool_amount, pool.l1_pool_amount, pool.pool_size, pool.ann);
        fee_amount = <a href="decimal128.md#0x1_decimal128_mul_u64">decimal128::mul_u64</a>(&module_store.swap_fee_rate, return_amount);
        module_store.l1_init_amount = module_store.l1_init_amount + fee_amount;
        pool.l1_pool_amount = pool.l1_pool_amount - return_amount;
        pool.l2_pool_amount = pool.l2_pool_amount + offer_amount;
        <b>let</b> return_amount = return_amount - fee_amount;
        <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(&module_signer, return_metadata, return_amount)
    };

    <a href="event.md#0x1_event_emit">event::emit</a>&lt;<a href="minitswap.md#0x1_minitswap_SwapEvent">SwapEvent</a>&gt;(
        <a href="minitswap.md#0x1_minitswap_SwapEvent">SwapEvent</a> {
            offer_coin: offer_metadata,
            return_coin: return_metadata,
            peg_keeper_offer_amount, // always l1 init
            peg_keeper_return_amount, // always l2 init
            offer_amount,
            return_amount: <a href="fungible_asset.md#0x1_fungible_asset_amount">fungible_asset::amount</a>(&return_asset),
            fee_amount, // always l1 init
        },
    );

    return_asset
}
</code></pre>



<a id="0x1_minitswap_rebalance_internal"></a>

## Function `rebalance_internal`



<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_rebalance_internal">rebalance_internal</a>(l1_init: <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>, l2_init_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;): <a href="fungible_asset.md#0x1_fungible_asset_FungibleAsset">fungible_asset::FungibleAsset</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="minitswap.md#0x1_minitswap_rebalance_internal">rebalance_internal</a>(
    l1_init: FungibleAsset,
    l2_init_metadata: Object&lt;Metadata&gt;,
): FungibleAsset <b>acquires</b> <a href="minitswap.md#0x1_minitswap_ModuleStore">ModuleStore</a>, <a href="minitswap.md#0x1_minitswap_VirtualPool">VirtualPool</a> {
    <b>assert</b>!(<a href="minitswap.md#0x1_minitswap_is_l1_init">is_l1_init</a>(&l1_init), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_ENOT_L1_INIT">ENOT_L1_INIT</a>));
    <b>let</b> (module_store, pool, module_signer, pool_signer) = <a href="minitswap.md#0x1_minitswap_borrow_all_mut">borrow_all_mut</a>(l2_init_metadata);
    <b>let</b> amount = <a href="fungible_asset.md#0x1_fungible_asset_amount">fungible_asset::amount</a>(&l1_init);
    <b>let</b> fee_amount = <a href="decimal128.md#0x1_decimal128_mul_u64">decimal128::mul_u64</a>(&module_store.swap_fee_rate, amount);
    module_store.l1_init_amount = module_store.l1_init_amount + fee_amount;
    <b>let</b> offer_amount = amount - fee_amount;
    <b>assert</b>!(offer_amount &lt;= pool.virtual_l1_balance, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="minitswap.md#0x1_minitswap_ENOT_ENOUGH_BALANCE">ENOT_ENOUGH_BALANCE</a>));
    <b>let</b> return_amount = <a href="minitswap.md#0x1_minitswap_mul_div">mul_div</a>(offer_amount, pool.virtual_l2_balance, pool.virtual_l1_balance);

    pool.virtual_l1_balance = pool.virtual_l1_balance - offer_amount;
    pool.virtual_l2_balance = pool.virtual_l2_balance - return_amount;
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_deposit">primary_fungible_store::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(&module_signer), l1_init);

    <a href="event.md#0x1_event_emit">event::emit</a>&lt;<a href="minitswap.md#0x1_minitswap_RebalanceEvent">RebalanceEvent</a>&gt;(
        <a href="minitswap.md#0x1_minitswap_RebalanceEvent">RebalanceEvent</a> {
            offer_coin: <a href="minitswap.md#0x1_minitswap_l1_init_metadata">l1_init_metadata</a>(), // always l1 init
            return_coin: l2_init_metadata, // always l2 init
            offer_amount: amount,
            return_amount,
            fee_amount,
        },
    );
    <a href="primary_fungible_store.md#0x1_primary_fungible_store_withdraw">primary_fungible_store::withdraw</a>(&pool_signer, l2_init_metadata, return_amount)
}
</code></pre>
