import React from 'react'
import chain_logo from '@/assets/chain_logo.png'
import token from '@/assets/token.png'
import ntfs from '@/assets/nfts.png'
import step_1 from '@/assets/step_1.png'
import add from '@/assets/add.png'
import transfer from '@/assets/transfer.png'
export default function PoolOne() {
  return (
    <div className="w-full flex flex-col items-center">
      <div className="flex flex-col items-center">
        <img src={chain_logo} alt="" className="w-24" />
      </div>
      <div className="flex flex-col items-center text-[20px] text-gray my-4">
        <span>Currently Creating New NFT AMM Pool on</span>
        <span className="text-purple font-bold">SUI Network</span>
        <span className="text-[14px]">Create a pool to buy, sell, or trade your NFTs and earn trading fees now</span>
      </div>
      <div className="flex flex-col items-center text-[20px] text-gray mb-4">
        <span className="font-bold">Step 1/3 : Select Pool Type</span>
        <img src={step_1} alt="" />
        <span className="font-bold text-[12px] mt-[-30px] w-2/3 flex justify-start">Step 1/3 : Select Pool Type</span>
      </div>
      <div className="flex justify-evenly w-full">
        <div className="flex flex-col items-center p-6 gap-2 w-[300px] h-96 bg-white shadow-pool rounded-xl">
          <div className="w-full flex justify-center text-purple">Pool 1 : Trade NFTs</div>
          <div className="w-full flex justify-between px-2 my-2">
            <img src={token} alt="" className=" w-10" />
            <img src={ntfs} alt="" className="w-10" />
          </div>
          <div className="w-full flex justify-between text-purple items-center px-2 my-2">
            <span>Token</span>
            <img src={add} alt="" className="w-5 h-5" />
            <span>NFTs</span>
          </div>
          <div className="flex justify-center mt-2 mb-6">
            <button className="bg-purple rounded-lg px-4 py-2 text-[#fff] cursor-pointer">NFT Trade Pool</button>
          </div>
          <div className="flex justify-center text-gray font-bold items-center text-base text-center">
            Deposit NFTs plus tokens into the pool and earn trading fees when people have a transaction in your pool
          </div>
        </div>
        <div className="flex flex-col items-center p-6 gap-2 w-[300px] h-96 bg-white shadow-pool rounded-xl">
          <div className="w-full flex justify-center text-purple">Pool 2 : Buy NFTs</div>
          <div className="w-full flex justify-between px-2 my-2">
            <img src={token} alt="" className=" w-10" />
            <img src={ntfs} alt="" className="w-10" />
          </div>
          <div className="w-full flex justify-between text-purple items-center px-2 my-2">
            <span>Token</span>
            <img src={transfer} alt="" className="w-5 h-5" />
            <span>NFTs</span>
          </div>
          <div className="flex justify-center mt-2 mb-6">
            <button className="bg-purple rounded-lg px-4 py-2 text-[#fff] cursor-pointer">NFT Purchase Pool</button>
          </div>
          <div className="flex justify-center text-gray font-bold items-center text-base text-center">
            Purchase your NFTs in this pool, by swapping tokens in this pool
          </div>
        </div>
        <div className="flex flex-col items-center p-6 gap-2 w-[300px] h-96 bg-white shadow-pool rounded-xl">
          <div className="w-full flex justify-center text-purple">Pool 3 : Sell NFTs</div>
          <div className="w-full flex justify-between px-2 my-2">
            <img src={token} alt="" className=" w-10" />
            <img src={ntfs} alt="" className="w-10" />
          </div>
          <div className="w-full flex justify-between text-purple items-center px-2 my-2">
            <span>Token</span>
            <img src={transfer} alt="" className="w-5 h-5" />
            <span>NFTs</span>
          </div>
          <div className="flex justify-center mt-2 mb-6">
            <button className="bg-purple rounded-lg px-4 py-2 text-[#fff] cursor-pointer">NFT Sell Pool</button>
          </div>
          <div className="flex justify-center text-gray font-bold items-center text-base text-center">
            Sell your NFTs in the pool, and swap them for tokens
          </div>
        </div>
      </div>
    </div>
  )
}
