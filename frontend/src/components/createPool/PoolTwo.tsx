import React from 'react'
import chain_logo from '@/assets/chain_logo.png'
import step_2 from '@/assets/step_2.png'
import search from '@/assets/search.png'

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
        <div className="w-full flex justify-evenly">
          <button className="bg-purple rounded-lg px-4 py-2 text-[#fff] cursor-pointer">Back</button>
          <span className="font-bold">Step 2/3 : Select Pool Type</span>
          <button className="bg-pink rounded-lg px-4 py-2 text-[#fff] cursor-pointer">Next</button>
        </div>
        <img src={step_2} alt="" />
        <span className="font-bold text-[12px] mt-[-30px] w-2/3 flex justify-center">Step 2/3 : Select Pool Type</span>
      </div>
      <div className="flex flex-col">
        <div className=" text-gray flex flex-col mb-2">
          <span className="font-bold">NFT</span>
          <div className="flex w-[450px] h-14  bg-white border-[1.34375px] border-gray-300 shadow-pol rounded-xl my-2">
            <img src={search} alt="" className="w-6 h-6 my-4 mx-5" />
            <input
              type="text"
              placeholder="Enter Collection or Address"
              className=" flex-grow h-full text-xl placeholder:text-xl text-gray border-0 outline-none rounded-xl"
            />
          </div>
          <span className="text-lg">Enter existing colletion or address to proceed</span>
        </div>
        <div className=" text-gray flex flex-col mb-2">
          <span className="font-bold">Tokens</span>
          <div className="flex w-[450px] h-14  bg-white border-[1.34375px] border-gray-300 shadow-pol rounded-xl my-2">
            <img src={search} alt="" className="w-6 h-6 my-4 mx-5" />
            <input
              type="text"
              placeholder="Enter Token or Address"
              className=" flex-grow h-full text-xl placeholder:text-xl text-gray border-0 outline-none rounded-xl"
            />
          </div>
          <span className="text-lg">Enter existing tokens or address to proceed</span>
        </div>
      </div>
    </div>
  )
}
