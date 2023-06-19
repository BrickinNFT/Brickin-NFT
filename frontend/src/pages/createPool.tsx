import React, { useState } from 'react'
import Nav from '@/components/Nav'
import PoolOne from '@/components/createPool/PoolOne'
import PoolTwo from '@/components/createPool/PoolTwo'
import PoolThree from '@/components/createPool/PoolThree'

export default function currentPool() {
  const [currentNav, setCurrentNav] = useState('Pool')
  const [step, setStep] = useState(3)
  return (
    <div className="flex justify-center items-center">
      <div className="flex-[3]">
        <Nav currentNav={currentNav}></Nav>
      </div>
      <div className="flex-[9]">
        {step === 1 && <PoolOne></PoolOne>}
        {step === 2 && <PoolTwo></PoolTwo>}
        {step === 3 && <PoolThree></PoolThree>}
      </div>
    </div>
  )
}
