import React, { useState } from 'react'
import Nav from '@/components/Nav'
import processScreenBg from '@/assets/processScreenBg.png'
export default function ProcessingScreen() {
  const [currentNav, setCurrentNav] = useState('Collecions')
  return (
    <div className="flex justify-center items-center">
      <div className="flex-[3]">
        <Nav currentNav={currentNav}></Nav>
      </div>
      <div className="flex-[9]">
        <div className="flex items-center flex-col">
          <img src={processScreenBg} alt="" />
          <div className="text-[60px] text-gray text-center font-bold">
            Hang on a minute, we
            <br />
            are processing...
          </div>
        </div>
      </div>
    </div>
  )
}
