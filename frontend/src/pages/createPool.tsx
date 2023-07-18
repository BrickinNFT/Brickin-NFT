import React, { useEffect, useState } from 'react'
import { proxy, snapshot, useSnapshot, subscribe } from 'valtio'

import Nav from '@/components/Nav'
import PoolOne from '@/components/createPool/PoolOne'
import PoolTwo from '@/components/createPool/PoolTwo'
import PoolThree from '@/components/createPool/PoolThree'
import { poolInfo } from '@/models/createPool'

import { chainName, chainRpc, packageID, sharedObjectID, CNYA, CNYU, CNYW, NFTTYPE } from '@/config/config.json'

import { useWallet, ConnectModal } from '@suiet/wallet-kit'
import { TransactionBlock, JsonRpcProvider, Connection } from '@mysten/sui.js'
import { history } from 'umi'

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
  const [showModal, setShowModal] = useState(false)
  const [showDisconnected, setShowDisconnected] = useState(false)
  const [address, setAddress] = useState('')
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
        arguments: [
          tx.pure(poolInfo.nfts),
          tx.pure('1TO1'),
          tx.pure(poolInfo.delta),
          tx.pure(poolInfoSnap.fee),
          tx.pure(poolInfoSnap.startPrice),
          tx.pure(poolInfoSnap.nft),
        ],
        typeArguments: [CNYA, CNYU, CNYW, NFTTYPE],
      })
      tx.transferObjects([_coin], tx.pure(wallet.address))
      history.push('/processingScreen')
      const resData = await wallet.signAndExecuteTransactionBlock({
        transactionBlock: tx,
      })
      history.push('/successScreen')
      console.log('executeMoveCall success', resData)
    } catch (e) {
      console.error('executeMoveCall failed', e)
    }
  }

  const getCoin = async () => {
    if (address !== '') {
      const allCoins = await provider.getCoins({
        owner: address,
        coinType: '0x2::sui::SUI',
      })

      if (allCoins.data.length > 0) {
        const total = allCoins.data.reduce((acc, item) => acc + Number(item.balance), 0)
        setCoin(total - maxGasPrice)
      } else {
        setCoin(0)
      }
    }
  }

  useEffect(() => {
    if (wallet.connected) {
      setAddress(wallet.address as string)
    }
  }, [wallet])

  useEffect(() => {
    getCoin()
  }, [address])

  useEffect(
    () =>
      subscribe(poolInfo, () => {
        console.log(poolInfo)
      }),
    [poolInfo]
  )

  useEffect(() => {
    if (chainName && chainRpc && packageID) {
      console.log('chainName: ', chainName)
      console.log('chainRpc: ', chainRpc)
      console.log('packageID: ', packageID)
      console.log('sharedObjectID: ', sharedObjectID)
    } else {
      console.log('config file load failed')
    }
  }, [])

  return (
    <div className="flex justify-center items-center">
      <div className="flex-[3]">
        <Nav currentNav={currentNav}></Nav>
      </div>
      <div className="flex-[9]">
        {poolInfoSnap.step === 1 && <PoolOne></PoolOne>}
        {poolInfoSnap.step === 2 && <PoolTwo></PoolTwo>}
        {poolInfoSnap.step === 3 && <PoolThree createPool={handleExecuteMoveCall}></PoolThree>}
      </div>
      {/* <div className="" onClick={handleExecuteMoveCall}>
        button
      </div> */}
    </div>
  )
}
