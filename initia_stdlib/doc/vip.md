
<a id="0x1_vip"></a>

# Module `0x1::vip`



-  [Resource `ModuleStore`](#0x1_vip_ModuleStore)
-  [Struct `StageData`](#0x1_vip_StageData)
-  [Struct `Snapshot`](#0x1_vip_Snapshot)
-  [Struct `Bridge`](#0x1_vip_Bridge)
-  [Struct `RewardDistribution`](#0x1_vip_RewardDistribution)
-  [Struct `ModuleResponse`](#0x1_vip_ModuleResponse)
-  [Struct `StageDataResponse`](#0x1_vip_StageDataResponse)
-  [Struct `BridgeResponse`](#0x1_vip_BridgeResponse)
-  [Struct `FundEvent`](#0x1_vip_FundEvent)
-  [Struct `StageAdvanceEvent`](#0x1_vip_StageAdvanceEvent)
-  [Constants](#@Constants_0)
-  [Function `register`](#0x1_vip_register)
-  [Function `deregister`](#0x1_vip_deregister)
-  [Function `update_agent`](#0x1_vip_update_agent)
-  [Function `fund_reward_script`](#0x1_vip_fund_reward_script)
-  [Function `submit_snapshot`](#0x1_vip_submit_snapshot)
-  [Function `claim_operator_reward_script`](#0x1_vip_claim_operator_reward_script)
-  [Function `claim_user_reward_script`](#0x1_vip_claim_user_reward_script)
-  [Function `batch_claim_operator_reward_script`](#0x1_vip_batch_claim_operator_reward_script)
-  [Function `batch_claim_user_reward_script`](#0x1_vip_batch_claim_user_reward_script)
-  [Function `update_vip_weight`](#0x1_vip_update_vip_weight)
-  [Function `update_vesting_period`](#0x1_vip_update_vesting_period)
-  [Function `update_minimum_tvl`](#0x1_vip_update_minimum_tvl)
-  [Function `update_maximum_tvl`](#0x1_vip_update_maximum_tvl)
-  [Function `update_proportion`](#0x1_vip_update_proportion)
-  [Function `update_pool_split_ratio`](#0x1_vip_update_pool_split_ratio)
-  [Function `zapping_script`](#0x1_vip_zapping_script)
-  [Function `batch_zapping_script`](#0x1_vip_batch_zapping_script)
-  [Function `update_operator_commission`](#0x1_vip_update_operator_commission)
-  [Function `get_expected_reward`](#0x1_vip_get_expected_reward)
-  [Function `get_stage_data`](#0x1_vip_get_stage_data)
-  [Function `get_bridge_info`](#0x1_vip_get_bridge_info)
-  [Function `get_next_stage`](#0x1_vip_get_next_stage)
-  [Function `get_module_store`](#0x1_vip_get_module_store)


<pre><code><b>use</b> <a href="../../move_nursery/../move_stdlib/doc/bcs.md#0x1_bcs">0x1::bcs</a>;
<b>use</b> <a href="block.md#0x1_block">0x1::block</a>;
<b>use</b> <a href="coin.md#0x1_coin">0x1::coin</a>;
<b>use</b> <a href="decimal256.md#0x1_decimal256">0x1::decimal256</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error">0x1::error</a>;
<b>use</b> <a href="event.md#0x1_event">0x1::event</a>;
<b>use</b> <a href="fungible_asset.md#0x1_fungible_asset">0x1::fungible_asset</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/hash.md#0x1_hash">0x1::hash</a>;
<b>use</b> <a href="object.md#0x1_object">0x1::object</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option">0x1::option</a>;
<b>use</b> <a href="primary_fungible_store.md#0x1_primary_fungible_store">0x1::primary_fungible_store</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">0x1::signer</a>;
<b>use</b> <a href="simple_map.md#0x1_simple_map">0x1::simple_map</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string">0x1::string</a>;
<b>use</b> <a href="table.md#0x1_table">0x1::table</a>;
<b>use</b> <a href="table_key.md#0x1_table_key">0x1::table_key</a>;
<b>use</b> <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">0x1::vector</a>;
<b>use</b> <a href="operator.md#0x1_vip_operator">0x1::vip_operator</a>;
<b>use</b> <a href="reward.md#0x1_vip_reward">0x1::vip_reward</a>;
<b>use</b> <a href="vault.md#0x1_vip_vault">0x1::vip_vault</a>;
<b>use</b> <a href="vesting.md#0x1_vip_vesting">0x1::vip_vesting</a>;
<b>use</b> <a href="zapping.md#0x1_vip_zapping">0x1::vip_zapping</a>;
</code></pre>



<a id="0x1_vip_ModuleStore"></a>

## Resource `ModuleStore`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> <b>has</b> key
</code></pre>



##### Fields


<dl>
<dt>
<code>stage: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>agent: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>proportion: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>pool_split_ratio: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>maximum_tvl: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>minimum_tvl: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>stage_data: <a href="table.md#0x1_table_Table">table::Table</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, <a href="vip.md#0x1_vip_StageData">vip::StageData</a>&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>bridges: <a href="table.md#0x1_table_Table">table::Table</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, <a href="vip.md#0x1_vip_Bridge">vip::Bridge</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_StageData"></a>

## Struct `StageData`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_StageData">StageData</a> <b>has</b> store
</code></pre>



##### Fields


<dl>
<dt>
<code>pool_split_ratio: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>total_operator_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>total_user_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_release_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_release_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>proportion: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>snapshots: <a href="table.md#0x1_table_Table">table::Table</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, <a href="vip.md#0x1_vip_Snapshot">vip::Snapshot</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_Snapshot"></a>

## Struct `Snapshot`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_Snapshot">Snapshot</a> <b>has</b> store
</code></pre>



##### Fields


<dl>
<dt>
<code>merkle_root: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;</code>
</dt>
<dd>

</dd>
<dt>
<code>total_l2_score: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_Bridge"></a>

## Struct `Bridge`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_Bridge">Bridge</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>bridge_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>operator_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>vip_weight: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_reward_store_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>user_reward_store_addr: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_RewardDistribution"></a>

## Struct `RewardDistribution`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_RewardDistribution">RewardDistribution</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>bridge_id: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_reward_store_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>operator_reward_store_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>user_reward_amount: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_reward_amount: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_ModuleResponse"></a>

## Struct `ModuleResponse`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_ModuleResponse">ModuleResponse</a> <b>has</b> drop
</code></pre>



##### Fields


<dl>
<dt>
<code>stage: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>agent: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>proportion: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>pool_split_ratio: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>minimum_tvl: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>maximum_tvl: u64</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_StageDataResponse"></a>

## Struct `StageDataResponse`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_StageDataResponse">StageDataResponse</a> <b>has</b> drop
</code></pre>



##### Fields


<dl>
<dt>
<code>pool_split_ratio: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>total_operator_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>total_user_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_release_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_release_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>proportion: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_BridgeResponse"></a>

## Struct `BridgeResponse`



<pre><code><b>struct</b> <a href="vip.md#0x1_vip_BridgeResponse">BridgeResponse</a> <b>has</b> drop
</code></pre>



##### Fields


<dl>
<dt>
<code>bridge_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>operator_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>vip_weight: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_reward_store_addr: <b>address</b></code>
</dt>
<dd>

</dd>
<dt>
<code>operator_reward_store_addr: <b>address</b></code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_FundEvent"></a>

## Struct `FundEvent`



<pre><code>#[<a href="event.md#0x1_event">event</a>]
<b>struct</b> <a href="vip.md#0x1_vip_FundEvent">FundEvent</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>stage: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>total_operator_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>total_user_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>reward_distribution: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="vip.md#0x1_vip_RewardDistribution">vip::RewardDistribution</a>&gt;</code>
</dt>
<dd>

</dd>
</dl>


<a id="0x1_vip_StageAdvanceEvent"></a>

## Struct `StageAdvanceEvent`



<pre><code>#[<a href="event.md#0x1_event">event</a>]
<b>struct</b> <a href="vip.md#0x1_vip_StageAdvanceEvent">StageAdvanceEvent</a> <b>has</b> drop, store
</code></pre>



##### Fields


<dl>
<dt>
<code>stage: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>pool_split_ratio: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
<dt>
<code>total_operator_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>total_user_funded_reward: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_period: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>user_vesting_release_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>operator_vesting_release_time: u64</code>
</dt>
<dd>

</dd>
<dt>
<code>proportion: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a></code>
</dt>
<dd>

</dd>
</dl>


<a id="@Constants_0"></a>

## Constants


<a id="0x1_vip_EUNAUTHORIZED"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EUNAUTHORIZED">EUNAUTHORIZED</a>: u64 = 5;
</code></pre>



<a id="0x1_vip_REWARD_SYMBOL"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_REWARD_SYMBOL">REWARD_SYMBOL</a>: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt; = [117, 105, 110, 105, 116];
</code></pre>



<a id="0x1_vip_DEFAULT_MAXIMUM_TVL"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_MAXIMUM_TVL">DEFAULT_MAXIMUM_TVL</a>: u64 = 100000000000000000;
</code></pre>



<a id="0x1_vip_DEFAULT_MINIMUM_TVL"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_MINIMUM_TVL">DEFAULT_MINIMUM_TVL</a>: u64 = 0;
</code></pre>



<a id="0x1_vip_DEFAULT_OPERATOR_VESTING_PERIOD"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_OPERATOR_VESTING_PERIOD">DEFAULT_OPERATOR_VESTING_PERIOD</a>: u64 = 52;
</code></pre>



<a id="0x1_vip_DEFAULT_POOL_SPLIT_RATIO"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_POOL_SPLIT_RATIO">DEFAULT_POOL_SPLIT_RATIO</a>: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt; = [48, 46, 52];
</code></pre>



<a id="0x1_vip_DEFAULT_PROPORTION_RATIO"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_PROPORTION_RATIO">DEFAULT_PROPORTION_RATIO</a>: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt; = [48, 46, 53];
</code></pre>



<a id="0x1_vip_DEFAULT_USER_VESTING_PERIOD"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_USER_VESTING_PERIOD">DEFAULT_USER_VESTING_PERIOD</a>: u64 = 52;
</code></pre>



<a id="0x1_vip_DEFAULT_VIP_START_STAGE"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_DEFAULT_VIP_START_STAGE">DEFAULT_VIP_START_STAGE</a>: u64 = 1;
</code></pre>



<a id="0x1_vip_EALREADY_FUNDED"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EALREADY_FUNDED">EALREADY_FUNDED</a>: u64 = 10;
</code></pre>



<a id="0x1_vip_EALREADY_REGISTERED"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EALREADY_REGISTERED">EALREADY_REGISTERED</a>: u64 = 13;
</code></pre>



<a id="0x1_vip_EBRIDGE_NOT_FOUND"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EBRIDGE_NOT_FOUND">EBRIDGE_NOT_FOUND</a>: u64 = 14;
</code></pre>



<a id="0x1_vip_EINVALID_BATCH_ARGUMENT"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>: u64 = 17;
</code></pre>



<a id="0x1_vip_EINVALID_FUND_STAGE"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_FUND_STAGE">EINVALID_FUND_STAGE</a>: u64 = 11;
</code></pre>



<a id="0x1_vip_EINVALID_MAX_TVL"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_MAX_TVL">EINVALID_MAX_TVL</a>: u64 = 7;
</code></pre>



<a id="0x1_vip_EINVALID_MERKLE_PROOFS"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_MERKLE_PROOFS">EINVALID_MERKLE_PROOFS</a>: u64 = 2;
</code></pre>



<a id="0x1_vip_EINVALID_MIN_TVL"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_MIN_TVL">EINVALID_MIN_TVL</a>: u64 = 6;
</code></pre>



<a id="0x1_vip_EINVALID_PROOF_LENGTH"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_PROOF_LENGTH">EINVALID_PROOF_LENGTH</a>: u64 = 3;
</code></pre>



<a id="0x1_vip_EINVALID_PROPORTION"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_PROPORTION">EINVALID_PROPORTION</a>: u64 = 8;
</code></pre>



<a id="0x1_vip_EINVALID_TOTAL_REWARD"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_TOTAL_REWARD">EINVALID_TOTAL_REWARD</a>: u64 = 18;
</code></pre>



<a id="0x1_vip_EINVALID_TOTAL_SHARE"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_TOTAL_SHARE">EINVALID_TOTAL_SHARE</a>: u64 = 9;
</code></pre>



<a id="0x1_vip_EINVALID_VEST_PERIOD"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EINVALID_VEST_PERIOD">EINVALID_VEST_PERIOD</a>: u64 = 4;
</code></pre>



<a id="0x1_vip_ESNAPSHOT_ALREADY_EXISTS"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_ESNAPSHOT_ALREADY_EXISTS">ESNAPSHOT_ALREADY_EXISTS</a>: u64 = 16;
</code></pre>



<a id="0x1_vip_ESTAGE_DATA_NOT_FOUND"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_ESTAGE_DATA_NOT_FOUND">ESTAGE_DATA_NOT_FOUND</a>: u64 = 1;
</code></pre>



<a id="0x1_vip_EVESTING_IN_PROGRESS"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EVESTING_IN_PROGRESS">EVESTING_IN_PROGRESS</a>: u64 = 15;
</code></pre>



<a id="0x1_vip_EZAPPING_STAKELISTED_NOT_ENOUGH"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_EZAPPING_STAKELISTED_NOT_ENOUGH">EZAPPING_STAKELISTED_NOT_ENOUGH</a>: u64 = 12;
</code></pre>



<a id="0x1_vip_PROOF_LENGTH"></a>



<pre><code><b>const</b> <a href="vip.md#0x1_vip_PROOF_LENGTH">PROOF_LENGTH</a>: u64 = 32;
</code></pre>



<a id="0x1_vip_register"></a>

## Function `register`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_register">register</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, operator: <b>address</b>, bridge_id: u64, bridge_address: <b>address</b>, vip_weight: u64, operator_commission_max_rate: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a>, operator_commission_max_change_rate: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a>, operator_commission_rate: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a>)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_register">register</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    operator: <b>address</b>,
    bridge_id: u64,
    bridge_address: <b>address</b>,
    vip_weight: u64,
    operator_commission_max_rate: Decimal256,
    operator_commission_max_change_rate: Decimal256,
    operator_commission_rate: Decimal256,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);

    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(!<a href="table.md#0x1_table_contains">table::contains</a>(&module_store.bridges, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id)), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_already_exists">error::already_exists</a>(<a href="vip.md#0x1_vip_EALREADY_REGISTERED">EALREADY_REGISTERED</a>));

    // register chain stores
    <b>if</b> (!<a href="operator.md#0x1_vip_operator_is_operator_store_registered">vip_operator::is_operator_store_registered</a>(operator, bridge_id)) {
        <a href="operator.md#0x1_vip_operator_register_operator_store">vip_operator::register_operator_store</a>(
            chain,
            operator,
            bridge_id,
            module_store.stage,
            operator_commission_max_rate,
            operator_commission_max_change_rate,
            operator_commission_rate,
        );
    };
    <b>if</b> (!<a href="vesting.md#0x1_vip_vesting_is_operator_reward_store_registered">vip_vesting::is_operator_reward_store_registered</a>(bridge_id)) {
        <a href="vesting.md#0x1_vip_vesting_register_operator_reward_store">vip_vesting::register_operator_reward_store</a>(chain, bridge_id);
    };
    <b>if</b> (!<a href="vesting.md#0x1_vip_vesting_is_user_reward_store_registered">vip_vesting::is_user_reward_store_registered</a>(bridge_id)) {
        <a href="vesting.md#0x1_vip_vesting_register_user_reward_store">vip_vesting::register_user_reward_store</a>(chain, bridge_id);
    };

    // add bridge info
    <a href="table.md#0x1_table_add">table::add</a>(&<b>mut</b> module_store.bridges, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id), <a href="vip.md#0x1_vip_Bridge">Bridge</a> {
        bridge_addr: bridge_address,
        operator_addr: operator,
        vip_weight,
        user_reward_store_addr: <a href="vesting.md#0x1_vip_vesting_get_user_reward_store_address">vip_vesting::get_user_reward_store_address</a>(bridge_id),
        operator_reward_store_addr: <a href="vesting.md#0x1_vip_vesting_get_operator_reward_store_address">vip_vesting::get_operator_reward_store_address</a>(bridge_id),
    });
}
</code></pre>



<a id="0x1_vip_deregister"></a>

## Function `deregister`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_deregister">deregister</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_deregister">deregister</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(<a href="table.md#0x1_table_contains">table::contains</a>(&module_store.bridges, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id)), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_not_found">error::not_found</a>(<a href="vip.md#0x1_vip_EBRIDGE_NOT_FOUND">EBRIDGE_NOT_FOUND</a>));

    <a href="table.md#0x1_table_remove">table::remove</a>(&<b>mut</b> module_store.bridges, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id));
}
</code></pre>



<a id="0x1_vip_update_agent"></a>

## Function `update_agent`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_agent">update_agent</a>(old_agent: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, new_agent: <b>address</b>)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_agent">update_agent</a>(
    old_agent: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    new_agent: <b>address</b>,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_agent_permission">check_agent_permission</a>(old_agent);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    module_store.agent = new_agent;
}
</code></pre>



<a id="0x1_vip_fund_reward_script"></a>

## Function `fund_reward_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_fund_reward_script">fund_reward_script</a>(agent: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, stage: u64, user_vesting_release_time: u64, operator_vesting_release_time: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_fund_reward_script">fund_reward_script</a>(
    agent: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    stage: u64,
    user_vesting_release_time: u64,
    operator_vesting_release_time: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_agent_permission">check_agent_permission</a>(agent);

    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>assert</b>!(!<a href="table.md#0x1_table_contains">table::contains</a>(&<b>mut</b> module_store.stage_data, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(stage)), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_already_exists">error::already_exists</a>(<a href="vip.md#0x1_vip_EALREADY_FUNDED">EALREADY_FUNDED</a>));
    <b>assert</b>!(stage == module_store.stage, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_FUND_STAGE">EINVALID_FUND_STAGE</a>));

    <b>let</b> total_reward = <a href="vault.md#0x1_vip_vault_claim">vip_vault::claim</a>(stage);
    <b>let</b> (total_operator_funded_reward, total_user_funded_reward) = <a href="vip.md#0x1_vip_fund_reward">fund_reward</a>(
        module_store,
        stage,
        total_reward
    );

    // set stage data
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <a href="table.md#0x1_table_add">table::add</a>(&<b>mut</b> module_store.stage_data, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(stage), <a href="vip.md#0x1_vip_StageData">StageData</a> {
        pool_split_ratio: module_store.pool_split_ratio,
        total_operator_funded_reward,
        total_user_funded_reward,
        user_vesting_period: module_store.user_vesting_period,
        operator_vesting_period: module_store.operator_vesting_period,
        user_vesting_release_time: user_vesting_release_time,
        operator_vesting_release_time: operator_vesting_release_time,
        proportion: module_store.proportion,
        snapshots: <a href="table.md#0x1_table_new">table::new</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, <a href="vip.md#0x1_vip_Snapshot">Snapshot</a>&gt;(),
    });

    <a href="event.md#0x1_event_emit">event::emit</a>(
        <a href="vip.md#0x1_vip_StageAdvanceEvent">StageAdvanceEvent</a> {
            stage,
            pool_split_ratio: module_store.pool_split_ratio,
            total_operator_funded_reward,
            total_user_funded_reward,
            user_vesting_period: module_store.user_vesting_period,
            operator_vesting_period: module_store.operator_vesting_period,
            user_vesting_release_time,
            operator_vesting_release_time,
            proportion: module_store.proportion,
        }
    );

    module_store.stage = stage + 1;
}
</code></pre>



<a id="0x1_vip_submit_snapshot"></a>

## Function `submit_snapshot`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_submit_snapshot">submit_snapshot</a>(agent: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, stage: u64, merkle_root: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, total_l2_score: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_submit_snapshot">submit_snapshot</a>(
    agent: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    stage: u64,
    merkle_root: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;,
    total_l2_score: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_agent_permission">check_agent_permission</a>(agent);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>assert</b>!(<a href="table.md#0x1_table_contains">table::contains</a>(&module_store.stage_data, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(stage)), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_not_found">error::not_found</a>(<a href="vip.md#0x1_vip_ESTAGE_DATA_NOT_FOUND">ESTAGE_DATA_NOT_FOUND</a>));
    <b>let</b> stage_data = <a href="table.md#0x1_table_borrow_mut">table::borrow_mut</a>(&<b>mut</b> module_store.stage_data, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(stage));

    <b>assert</b>!(!<a href="table.md#0x1_table_contains">table::contains</a>(&stage_data.snapshots, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id)), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_already_exists">error::already_exists</a>(<a href="vip.md#0x1_vip_ESNAPSHOT_ALREADY_EXISTS">ESNAPSHOT_ALREADY_EXISTS</a>));
    <a href="table.md#0x1_table_add">table::add</a>(&<b>mut</b> stage_data.snapshots, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id), <a href="vip.md#0x1_vip_Snapshot">Snapshot</a> {
        merkle_root,
        total_l2_score,
    });
}
</code></pre>



<a id="0x1_vip_claim_operator_reward_script"></a>

## Function `claim_operator_reward_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_claim_operator_reward_script">claim_operator_reward_script</a>(operator: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, stage: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_claim_operator_reward_script">claim_operator_reward_script</a>(
    operator: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    stage: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>if</b> (!<a href="vesting.md#0x1_vip_vesting_is_operator_vesting_store_registered">vip_vesting::is_operator_vesting_store_registered</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(operator), bridge_id)) {
        <a href="vesting.md#0x1_vip_vesting_register_operator_vesting_store">vip_vesting::register_operator_vesting_store</a>(operator, bridge_id);
    };
    <b>let</b> vested_reward = <a href="vip.md#0x1_vip_claim_operator_reward">claim_operator_reward</a>(
        operator,
        bridge_id,
        stage,
    );

    <a href="coin.md#0x1_coin_deposit">coin::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(operator), vested_reward);
}
</code></pre>



<a id="0x1_vip_claim_user_reward_script"></a>

## Function `claim_user_reward_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_claim_user_reward_script">claim_user_reward_script</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, stage: u64, merkle_proofs: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;&gt;, l2_score: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_claim_user_reward_script">claim_user_reward_script</a> (
    <a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    stage: u64,
    merkle_proofs: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;&gt;,
    l2_score: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>if</b> (!<a href="vesting.md#0x1_vip_vesting_is_user_vesting_store_registered">vip_vesting::is_user_vesting_store_registered</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>), bridge_id)) {
        <a href="vesting.md#0x1_vip_vesting_register_user_vesting_store">vip_vesting::register_user_vesting_store</a>(<a href="account.md#0x1_account">account</a>, bridge_id);
    };

    <b>let</b> vested_reward = <a href="vip.md#0x1_vip_claim_user_reward">claim_user_reward</a>(
        <a href="account.md#0x1_account">account</a>,
        bridge_id,
        stage,
        merkle_proofs,
        l2_score,
    );

    <a href="coin.md#0x1_coin_deposit">coin::deposit</a>(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(<a href="account.md#0x1_account">account</a>), vested_reward);
}
</code></pre>



<a id="0x1_vip_batch_claim_operator_reward_script"></a>

## Function `batch_claim_operator_reward_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_batch_claim_operator_reward_script">batch_claim_operator_reward_script</a>(operator: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, stage: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_batch_claim_operator_reward_script">batch_claim_operator_reward_script</a>(
    operator: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    stage: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_enumerate_ref">vector::enumerate_ref</a>(&stage, |_i, s| {
        <a href="vip.md#0x1_vip_claim_operator_reward_script">claim_operator_reward_script</a>(
            operator,
            bridge_id,
            *s,
        );
    });
}
</code></pre>



<a id="0x1_vip_batch_claim_user_reward_script"></a>

## Function `batch_claim_user_reward_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_batch_claim_user_reward_script">batch_claim_user_reward_script</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, stage: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;, merkle_proofs: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;&gt;&gt;, l2_score: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_batch_claim_user_reward_script">batch_claim_user_reward_script</a> (
    <a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    stage: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;,
    merkle_proofs: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;&gt;&gt;,
    l2_score: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&stage) == <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&merkle_proofs) &&
        <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&merkle_proofs) == <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&l2_score), <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));

    <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_enumerate_ref">vector::enumerate_ref</a>(&stage, |i, s| {
        <a href="vip.md#0x1_vip_claim_user_reward_script">claim_user_reward_script</a>(
            <a href="account.md#0x1_account">account</a>,
            bridge_id,
            *s,
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&merkle_proofs, i),
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&l2_score, i),
        );
    });
}
</code></pre>



<a id="0x1_vip_update_vip_weight"></a>

## Function `update_vip_weight`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_vip_weight">update_vip_weight</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, weight: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_vip_weight">update_vip_weight</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    weight: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> bridge = <a href="vip.md#0x1_vip_load_bridge_mut">load_bridge_mut</a>(&<b>mut</b> module_store.bridges, bridge_id);
    bridge.vip_weight = weight;
}
</code></pre>



<a id="0x1_vip_update_vesting_period"></a>

## Function `update_vesting_period`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_vesting_period">update_vesting_period</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, user_vesting_period: u64, operator_vesting_period: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_vesting_period">update_vesting_period</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    user_vesting_period: u64,
    operator_vesting_period: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(user_vesting_period &gt; 0 && operator_vesting_period &gt; 0, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_VEST_PERIOD">EINVALID_VEST_PERIOD</a>));
    module_store.user_vesting_period = user_vesting_period;
    module_store.operator_vesting_period = operator_vesting_period;
}
</code></pre>



<a id="0x1_vip_update_minimum_tvl"></a>

## Function `update_minimum_tvl`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_minimum_tvl">update_minimum_tvl</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, minimum_tvl: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_minimum_tvl">update_minimum_tvl</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    minimum_tvl: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(minimum_tvl &gt;= 0,<a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_MIN_TVL">EINVALID_MIN_TVL</a>));
    module_store.minimum_tvl = minimum_tvl;
}
</code></pre>



<a id="0x1_vip_update_maximum_tvl"></a>

## Function `update_maximum_tvl`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_maximum_tvl">update_maximum_tvl</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, maximum_tvl: u64)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_maximum_tvl">update_maximum_tvl</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    maximum_tvl: u64,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(maximum_tvl &gt;= module_store.minimum_tvl,<a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_MAX_TVL">EINVALID_MAX_TVL</a>));
    module_store.maximum_tvl = maximum_tvl;
}
</code></pre>



<a id="0x1_vip_update_proportion"></a>

## Function `update_proportion`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_proportion">update_proportion</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, proportion: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a>)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_proportion">update_proportion</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    proportion: Decimal256,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(
        <a href="decimal256.md#0x1_decimal256_val">decimal256::val</a>(&proportion) &gt;= <a href="decimal256.md#0x1_decimal256_val">decimal256::val</a>(&<a href="decimal256.md#0x1_decimal256_zero">decimal256::zero</a>()),
        <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_PROPORTION">EINVALID_PROPORTION</a>)
    );

    module_store.proportion = proportion;
}
</code></pre>



<a id="0x1_vip_update_pool_split_ratio"></a>

## Function `update_pool_split_ratio`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_pool_split_ratio">update_pool_split_ratio</a>(chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, pool_split_ratio: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a>)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_pool_split_ratio">update_pool_split_ratio</a>(
    chain: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    pool_split_ratio: Decimal256,
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <a href="vip.md#0x1_vip_check_chain_permission">check_chain_permission</a>(chain);
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer_address_of">signer::address_of</a>(chain));
    <b>assert</b>!(
        <a href="decimal256.md#0x1_decimal256_val">decimal256::val</a>(&pool_split_ratio) &lt;= <a href="decimal256.md#0x1_decimal256_val">decimal256::val</a>(&<a href="decimal256.md#0x1_decimal256_one">decimal256::one</a>()),
        <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_PROPORTION">EINVALID_PROPORTION</a>)
    );

    module_store.pool_split_ratio = pool_split_ratio;
}
</code></pre>



<a id="0x1_vip_zapping_script"></a>

## Function `zapping_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_zapping_script">zapping_script</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, lp_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;, min_liquidity: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;, validator: <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>, stage: u64, zapping_amount: u64, stakelisted_amount: u64, stakelisted_metadata: <a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_zapping_script">zapping_script</a>(
    <a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    lp_metadata: Object&lt;Metadata&gt;,
    min_liquidity: <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;,
    validator: <a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>,
    stage: u64,
    zapping_amount: u64,
    stakelisted_amount: u64,
    stakelisted_metadata: Object&lt;Metadata&gt;,
) {
    <a href="vip.md#0x1_vip_zapping">zapping</a>(
        <a href="account.md#0x1_account">account</a>,
        bridge_id,
        lp_metadata,
        min_liquidity,
        validator,
        stage,
        zapping_amount,
        stakelisted_amount,
        stakelisted_metadata,
    );
}
</code></pre>



<a id="0x1_vip_batch_zapping_script"></a>

## Function `batch_zapping_script`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_batch_zapping_script">batch_zapping_script</a>(<a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, lp_metadata: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;&gt;, min_liquidity: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;&gt;, validator: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>&gt;, stage: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;, zapping_amount: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;, stakelisted_amount: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;, stakelisted_metadata: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="object.md#0x1_object_Object">object::Object</a>&lt;<a href="fungible_asset.md#0x1_fungible_asset_Metadata">fungible_asset::Metadata</a>&gt;&gt;)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_batch_zapping_script">batch_zapping_script</a>(
    <a href="account.md#0x1_account">account</a>: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    lp_metadata: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;Object&lt;Metadata&gt;&gt;,
    min_liquidity: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_Option">option::Option</a>&lt;u64&gt;&gt;,
    validator: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/string.md#0x1_string_String">string::String</a>&gt;,
    stage: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;,
    zapping_amount: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;,
    stakelisted_amount: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u64&gt;,
    stakelisted_metadata: <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;Object&lt;Metadata&gt;&gt;,
) {
    <b>let</b> batch_length = <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&stage);
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&lp_metadata) == batch_length, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&min_liquidity) == batch_length, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&validator) == batch_length, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&zapping_amount) == batch_length, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&stakelisted_amount) == batch_length, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));
    <b>assert</b>!(<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_length">vector::length</a>(&stakelisted_metadata) == batch_length, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_BATCH_ARGUMENT">EINVALID_BATCH_ARGUMENT</a>));

    <a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_enumerate_ref">vector::enumerate_ref</a>(&stage, |i, s| {
        <a href="vip.md#0x1_vip_zapping">zapping</a>(
            <a href="account.md#0x1_account">account</a>,
            bridge_id,
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&lp_metadata, i),
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&min_liquidity, i),
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&validator, i),
            *s,
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&zapping_amount, i),
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&stakelisted_amount, i),
            *<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector_borrow">vector::borrow</a>(&stakelisted_metadata, i),
        );
    });
}
</code></pre>



<a id="0x1_vip_update_operator_commission"></a>

## Function `update_operator_commission`



<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_operator_commission">update_operator_commission</a>(operator: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>, bridge_id: u64, commission_rate: <a href="decimal256.md#0x1_decimal256_Decimal256">decimal256::Decimal256</a>)
</code></pre>



##### Implementation


<pre><code><b>public</b> entry <b>fun</b> <a href="vip.md#0x1_vip_update_operator_commission">update_operator_commission</a>(
    operator: &<a href="../../move_nursery/../move_stdlib/doc/signer.md#0x1_signer">signer</a>,
    bridge_id: u64,
    commission_rate: Decimal256
) <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <a href="operator.md#0x1_vip_operator_update_operator_commission">vip_operator::update_operator_commission</a>(operator, bridge_id, module_store.stage, commission_rate);
}
</code></pre>



<a id="0x1_vip_get_expected_reward"></a>

## Function `get_expected_reward`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_expected_reward">get_expected_reward</a>(bridge_id: u64, fund_reward_amount: u64): u64
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_expected_reward">get_expected_reward</a>(bridge_id: u64, fund_reward_amount: u64): u64 <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> balance_shares = <a href="simple_map.md#0x1_simple_map_create">simple_map::create</a>&lt;u64, u64&gt;();
    <b>let</b> weight_shares = <a href="simple_map.md#0x1_simple_map_create">simple_map::create</a>&lt;u64, u64&gt;();

    <b>let</b> total_balance = <a href="vip.md#0x1_vip_calculate_balance_share">calculate_balance_share</a>(module_store, &<b>mut</b> balance_shares);
    <b>let</b> total_weight = <a href="vip.md#0x1_vip_calculate_weight_share">calculate_weight_share</a>(module_store, &<b>mut</b> weight_shares);

    <b>assert</b>!(fund_reward_amount &gt; 0, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_argument">error::invalid_argument</a>(<a href="vip.md#0x1_vip_EINVALID_TOTAL_REWARD">EINVALID_TOTAL_REWARD</a>));
    <b>assert</b>!(total_balance &gt; 0, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="vip.md#0x1_vip_EINVALID_TOTAL_SHARE">EINVALID_TOTAL_SHARE</a>));
    <b>assert</b>!(total_weight &gt; 0, <a href="../../move_nursery/../move_stdlib/doc/error.md#0x1_error_invalid_state">error::invalid_state</a>(<a href="vip.md#0x1_vip_EINVALID_TOTAL_SHARE">EINVALID_TOTAL_SHARE</a>));

    <b>let</b> weight_ratio = <a href="decimal256.md#0x1_decimal256_sub">decimal256::sub</a>(&<a href="decimal256.md#0x1_decimal256_one">decimal256::one</a>(), &module_store.pool_split_ratio);
    <b>let</b> balance_pool_reward_amount = <a href="decimal256.md#0x1_decimal256_mul_u64">decimal256::mul_u64</a>(&module_store.pool_split_ratio, fund_reward_amount);
    <b>let</b> weight_pool_reward_amount = <a href="decimal256.md#0x1_decimal256_mul_u64">decimal256::mul_u64</a>(&weight_ratio, fund_reward_amount);

    <b>let</b> balance_split_amount = <a href="vip.md#0x1_vip_split_reward_with_share_internal">split_reward_with_share_internal</a>(&balance_shares, bridge_id, total_balance, balance_pool_reward_amount);
    <b>let</b> weight_split_amount = <a href="vip.md#0x1_vip_split_reward_with_share_internal">split_reward_with_share_internal</a>(&weight_shares, bridge_id, total_weight, weight_pool_reward_amount);

    balance_split_amount + weight_split_amount
}
</code></pre>



<a id="0x1_vip_get_stage_data"></a>

## Function `get_stage_data`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_stage_data">get_stage_data</a>(stage: u64): <a href="vip.md#0x1_vip_StageDataResponse">vip::StageDataResponse</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_stage_data">get_stage_data</a>(stage: u64): <a href="vip.md#0x1_vip_StageDataResponse">StageDataResponse</a> <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> stage_data = <a href="table.md#0x1_table_borrow">table::borrow</a>(&module_store.stage_data, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(stage));

    <a href="vip.md#0x1_vip_StageDataResponse">StageDataResponse</a> {
        pool_split_ratio: stage_data.pool_split_ratio,
        total_operator_funded_reward: stage_data.total_operator_funded_reward,
        total_user_funded_reward: stage_data.total_user_funded_reward,
        user_vesting_period: stage_data.user_vesting_period,
        operator_vesting_period: stage_data.operator_vesting_period,
        user_vesting_release_time: stage_data.user_vesting_release_time,
        operator_vesting_release_time: stage_data.operator_vesting_release_time,
        proportion: stage_data.proportion,
    }
}
</code></pre>



<a id="0x1_vip_get_bridge_info"></a>

## Function `get_bridge_info`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_bridge_info">get_bridge_info</a>(bridge_id: u64): <a href="vip.md#0x1_vip_BridgeResponse">vip::BridgeResponse</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_bridge_info">get_bridge_info</a>(bridge_id: u64): <a href="vip.md#0x1_vip_BridgeResponse">BridgeResponse</a> <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);
    <b>let</b> bridge = <a href="vip.md#0x1_vip_load_bridge">load_bridge</a>(&module_store.bridges, bridge_id);

    <a href="vip.md#0x1_vip_BridgeResponse">BridgeResponse</a> {
        bridge_addr: bridge.bridge_addr,
        operator_addr: bridge.operator_addr,
        vip_weight: bridge.vip_weight,
        user_reward_store_addr: bridge.user_reward_store_addr,
        operator_reward_store_addr: bridge.operator_reward_store_addr,
    }
}
</code></pre>



<a id="0x1_vip_get_next_stage"></a>

## Function `get_next_stage`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_next_stage">get_next_stage</a>(bridge_id: u64): u64
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_next_stage">get_next_stage</a>(bridge_id: u64): u64 <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);

    <b>let</b> iter = <a href="table.md#0x1_table_iter">table::iter</a>(&module_store.stage_data, <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_none">option::none</a>(), <a href="../../move_nursery/../move_stdlib/doc/option.md#0x1_option_none">option::none</a>(), 2);
    <b>loop</b> {
        <b>if</b> (!<a href="table.md#0x1_table_prepare">table::prepare</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, <a href="vip.md#0x1_vip_StageData">StageData</a>&gt;(&<b>mut</b> iter)) {
            <b>break</b>
        };

        <b>let</b> (key, value) = <a href="table.md#0x1_table_next">table::next</a>&lt;<a href="../../move_nursery/../move_stdlib/doc/vector.md#0x1_vector">vector</a>&lt;u8&gt;, <a href="vip.md#0x1_vip_StageData">StageData</a>&gt;(&<b>mut</b> iter);
        <b>if</b> (<a href="table.md#0x1_table_contains">table::contains</a>(&value.snapshots, <a href="table_key.md#0x1_table_key_encode_u64">table_key::encode_u64</a>(bridge_id))) {
            <b>return</b> <a href="table_key.md#0x1_table_key_decode_u64">table_key::decode_u64</a>(key) + 1
        };
    };

    module_store.stage
}
</code></pre>



<a id="0x1_vip_get_module_store"></a>

## Function `get_module_store`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_module_store">get_module_store</a>(): <a href="vip.md#0x1_vip_ModuleResponse">vip::ModuleResponse</a>
</code></pre>



##### Implementation


<pre><code><b>public</b> <b>fun</b> <a href="vip.md#0x1_vip_get_module_store">get_module_store</a>(): <a href="vip.md#0x1_vip_ModuleResponse">ModuleResponse</a> <b>acquires</b> <a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a> {
    <b>let</b> module_store = <b>borrow_global_mut</b>&lt;<a href="vip.md#0x1_vip_ModuleStore">ModuleStore</a>&gt;(@initia_std);

    <a href="vip.md#0x1_vip_ModuleResponse">ModuleResponse</a> {
        stage: module_store.stage,
        agent: module_store.agent,
        proportion: module_store.proportion,
        pool_split_ratio: module_store.pool_split_ratio,
        user_vesting_period: module_store.user_vesting_period,
        operator_vesting_period: module_store.operator_vesting_period,
        minimum_tvl: module_store.minimum_tvl,
        maximum_tvl: module_store.maximum_tvl,
    }
}
</code></pre>
