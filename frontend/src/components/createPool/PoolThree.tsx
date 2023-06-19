import React, { useState } from 'react'
import cn from 'classnames'

import chain_logo from '@/assets/chain_logo.png'
import step_3 from '@/assets/step_3.png'
import item_1 from '@/assets/item_1.png'
import item_2 from '@/assets/item_2.png'
import addNFTs from '@/assets/addNFTs.png'

export default function PoolOne() {
  const [bondingCurve, setBoudingCurve] = useState('Linear')
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
          <span className="font-bold">Step 3/3 : Select Pool Type</span>
          <button className="bg-pink rounded-lg px-4 py-2 text-[#fff] cursor-pointer">Confirm</button>
        </div>
        <img src={step_3} alt="" />
        <span className="font-bold text-[12px] mt-[-30px] w-2/3 flex justify-end">Step 3/3 : Select Pool Type</span>
      </div>
      <div className="flex justify-evenly w-full">
        <div className="flex flex-col item-center px-8 py-4 w-[360px] bg-white shadow-pool rounded-2xl text-purple">
          <div className="flex flex-col">
            <label htmlFor="" className="text-gray text-xs font-bold">
              Start Price
            </label>
            <input
              type="text"
              placeholder="Tokens @ SUI"
              className=" placeholder:text-placeholder text-sm border-input-border border border-solid rounded-md outline-none flex h-10 px-3 py-2 my-2"
            />
          </div>
          <div>
            <label htmlFor="" className="text-gray text-xs font-bold">
              Bonding Curve
            </label>
            <div className="my-2 w-full flex justify-between">
              <button
                className={cn('rounded-lg px-4 py-2 text-[#fff] cursor-pointer', {
                  'bg-purple': bondingCurve === 'Linear',
                  'bg-pink': bondingCurve === 'Exponential',
                })}
                onClick={() => setBoudingCurve('Linear')}>
                Linear
              </button>
              <button
                className={cn('rounded-lg px-4 py-2 text-[#fff] cursor-pointer', {
                  'bg-pink': bondingCurve === 'Linear',
                  'bg-purple': bondingCurve === 'Exponential',
                })}
                onClick={() => setBoudingCurve('Exponential')}>
                Exponential
              </button>
            </div>
          </div>
          {bondingCurve === 'Linear' ? (
            <div className="flex flex-col">
              <label htmlFor="" className="text-gray text-xs font-bold">
                Start Delta
              </label>
              <input
                type="text"
                placeholder="Tokens @ SUI"
                className=" placeholder:text-placeholder text-sm border-input-border border border-solid rounded-md outline-none flex h-10 px-3 py-2 my-2"
              />
            </div>
          ) : (
            <div className="flex flex-col">
              <label htmlFor="" className="text-gray text-xs font-bold">
                Start Delta
              </label>
              <input
                type="text"
                placeholder="%"
                className=" placeholder:text-placeholder text-sm border-input-border border border-solid rounded-md outline-none flex h-10 px-3 py-2 my-2"
              />
            </div>
          )}

          <div className="flex flex-col">
            <label htmlFor="" className="text-gray text-xs font-bold">
              Pool Trading Fee
            </label>
            <input
              type="text"
              placeholder="%"
              className="  placeholder:text-placeholder text-sm border-input-border border border-solid rounded-md outline-none flex h-10 px-3 py-2 my-2"
            />
          </div>
          <div className="flex flex-col">
            <label htmlFor="" className="text-gray text-xs font-bold">
              Max Purchase Volume
            </label>
            <input
              type="text"
              placeholder="NFTs"
              className="  placeholder:text-placeholder text-sm border-input-border border border-solid rounded-md outline-none flex h-10 px-3 py-2 my-2"
            />
          </div>
          <div>
            <label htmlFor="" className="text-gray text-xs font-bold">
              Max Amount : 10000
            </label>
          </div>
        </div>
        <div>
          <div className="w-[400px] h-[240px] bg-white shadow-pool rounded-md mb-4">
            <div className="text-gray text-xl font-bold flex flex-col justify-between py-4 px-8 h-full">
              <div>Add Items</div>
              <div className="flex justify-between">
                <img src={item_1} alt="" className="w-24 h-24" />
                <img src={item_2} alt="" className="w-24 h-24" />
                <img src={addNFTs} alt="" className="w-24 h-24" />
              </div>
            </div>
          </div>
          <div className="w-[400px] bg-white shadow-pool rounded-md">
            <div className="text-gray text-xl font-bold flex flex-col justify-between py-4 px-8 h-full">
              <div className="my-2">Pool Summary</div>
              <div className="flex flex-col justify-center items-center  text-sm">
                <div className=" text-gray">
                  <span>Selected NFTs : </span>
                  <span className=" text-purple">2</span>
                </div>
                <div className=" text-gray my-4">
                  <span>Deposit Amount : </span>
                  <span className=" text-purple">1000</span>
                </div>
                <div className="text-purple flex justify-center text-center">
                  If all NFTs you deposit into the pool are sold, you will receive 55 tokens
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
