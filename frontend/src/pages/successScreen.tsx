import React, { useState } from 'react'
import { history } from 'umi'
import Nav from '@/components/Nav'
import successScreenBg from '@/assets/successScreenBg.png'
export default function ProcessingScreen() {
  const [currentNav, setCurrentNav] = useState('Pool')
  return (
    <div className="flex justify-center items-center">
      <div className="flex-[3]">
        <Nav currentNav={currentNav}></Nav>
      </div>
      <div className="flex-[9]">
        <div className="flex items-center flex-col mt-[-50px]">
          <img src={successScreenBg} className="h-[340px]" alt="" />
          <div className="text-[40px] text-gray text-center font-bold mt-[-40px]">
            Congratulations, pool <br /> successfully created!
          </div>
          <div
            className="w-[520px] h-[186px] flex flex-col items-center
                    justify-evenly bg-[#fff] text-center rounded-[16px] mt-[15px] shadow-pool">
            <div className="font-bold text-[#7F56D9] text-[24px]">
              Syncing with the network right now <br />
              It may take a while for your pool to <br /> appear
            </div>
            <div
              className="w-[150px] h-[44px] bg-[#7F56D9] text-[#fff] text-center leading-[44px] cursor-pointer rounded-[8px]"
              onClick={() => history.push('/currentPool')}>
              View Your Pool
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
