import React, { useEffect, useState } from 'react'
import { proxy, snapshot, useSnapshot, subscribe } from 'valtio'

import Nav from '@/components/Nav'
import PoolOne from '@/components/createPool/PoolOne'
import PoolTwo from '@/components/createPool/PoolTwo'
import PoolThree from '@/components/createPool/PoolThree'
import { poolInfo } from '@/models/createPool'

import { chainName, chainRpc, packageID, sharedObjectID } from '@/config/config.json'

import { useWallet, ConnectModal } from '@suiet/wallet-kit'
import { TransactionBlock, JsonRpcProvider, Connection } from '@mysten/sui.js'

const provider = new JsonRpcProvider(
  new Connection({
    fullnode: chainRpc,
  })
)
export default function currentPool() {
  const [currentNav, setCurrentNav] = useState('Pool')
  const poolInfoSnap = useSnapshot(poolInfo)
  const wallet = useWallet()
  const { connected } = wallet
  const [maxGasPrice, setMaxGasPrice] = useState(100_000_000) // 0.1Sui
  const [coin, setCoin] = useState(0)
  const handleExecuteMoveCall = async () => {
    if (!wallet.connected) {
      alert('please click connect wallet')
      return
    }
    try {
      const tx = new TransactionBlock()
      const [_coin] = tx.splitCoins(tx.gas, [tx.pure(coin)])
      tx.setGasBudget = 100_000_000 as any
      tx.moveCall({
        target: packageID as any,
        arguments: [tx.object(sharedObjectID as string), _coin, tx.pure('6')],
      })
      tx.transferObjects([_coin], tx.pure(wallet.address))
      const resData = await wallet.signAndExecuteTransactionBlock({
        transactionBlock: tx,
      })
      console.log('executeMoveCall success', resData)
    } catch (e) {
      console.error('executeMoveCall failed', e)
    }
  }

  useEffect(
    () =>
      subscribe(poolInfo, () => {
        console.log(poolInfo)
      }),
    [poolInfo]
  )

  return (
    <div className="flex justify-center items-center">
      <div className="flex-[3]">
        <Nav currentNav={currentNav}></Nav>
      </div>
      <div className="flex-[9]">
        {poolInfoSnap.step === 1 && <PoolOne></PoolOne>}
        {poolInfoSnap.step === 2 && <PoolTwo></PoolTwo>}
        {poolInfoSnap.step === 3 && <PoolThree></PoolThree>}
      </div>
    </div>
  )
}
