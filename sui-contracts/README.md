1.接口名: create_pair_nft_trade_pool
参数:
account: &signer - 交易的发送方的账户引用。
collection: vector<u8> - 表示NFT集合的字节向量。
curve_type: vector<u8> - 表示交易池使用的曲线类型的字节向量。
delta: u64 - 可能用于定价逻辑的参数。
fee: u64 - 交易费用。
init_price: u64 - NFT的初始价格。
nft_num: u64 - 交易池中的NFT数量。
注释: 该函数用于创建一个新的交易池，并将其与账户关联。

2.接口名: deposit_nft
参数:
trade_pool_address: address - 交易池的地址。
object_id_list: vector<vector<u8>> - 要存入交易池的NFT的ID列表。
注释: 允许将NFT存入交易池。

3.接口名: swap_stable_coin_for_nfts
参数:
buyer: &signer - 交易的购买者的账户引用。
amount_of_coins: u64 - 要交换的稳定币数量。
trade_pool_address: address - 交易池的地址。
注释: 使用稳定币从交易池购买NFT。

4.接口名: withdraw_nft
参数:
requester: &signer - 请求提款的账户引用。
trade_pool_address: address - 交易池的地址。
object_id_list: vector<vector<u8>> -
要从交易池中取出的NFT的ID列表。

注释: 允许从交易池中取出NFT。

5.接口名: withdraw_coin
参数:
requester: &signer - 请求提款的账户引用。
trade_pool_address: address - 交易池的地址。
object_id: vector<u8> - 要取出的代币的ID。
注释: 允许从交易池中取出代币。

6.接口名: register_coin
参数:
requester: &signer - 请求注册的账户引用。
trade_pool_address: address - 交易池的地址。
object_id: vector<u8> - 要注册的代币的ID。
注释: 允许在交易池中注册新的代币。

7.接口名: swap_stable_coin_for_nfts
参数:
requester: &signer - 交易的购买者的账户引用。
trade_pool_address: address - 交易池的地址。
stable_coin_amount: u64 - 要交换的稳定币数量。
desired_nft_ids: vector<vector<u8>> - 用户想要购买的NFT的ID列表。
注释: 使用稳定币从交易池购买指定的NFT。

8.接口名: swap_any_coin_for_nfts
参数:
requester: &signer - 交易的购买者的账户引用。
trade_pool_address: address - 交易池的地址。
any_coin_amount: u64 - 要交换的任意代币的数量。
coin_type: vector<u8> - 要交换的代币的类型。
desired_nft_ids: vector<vector<u8>> - 用户想要购买的NFT的ID列表。
注释: 使用任意类型的代币从交易池购买指定的NFT。

9.接口名: swap_nfts_for_sui
参数:
requester: &signer - 交易的发送方的账户引用。
trade_pool_address: address - 交易池的地址。
nft_ids: vector<vector<u8>> - 要交换的NFT的ID列表。
注释: 使用NFT从交易池购买SUI代币。

10.接口名: swap_nfts_for_stable_coin
参数:
requester: &signer - 交易的发送方的账户引用。
trade_pool_address: address - 交易池的地址。
nft_ids: vector<vector<u8>> - 要交换的NFT的ID列表。
注释: 使用NFT从交易池购买稳定币。