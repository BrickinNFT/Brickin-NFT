import { useEffect, useState } from 'react'
import { useWallet, ConnectModal } from '@suiet/wallet-kit'
import logo from '@/assets/logo.png'
const navList = [
  {
    name: 'Home',
    link: '#',
  },
  {
    name: 'API',
    link: '#',
  },
  {
    name: 'Pricing',
    link: '#',
  },
  {
    name: 'Our Team',
    link: '#',
  },
]
export default function Header() {
  const wallet = useWallet()
  const { connected } = wallet
  const [showModal, setShowModal] = useState(false)
  const [showDisconnected, setShowDisconnected] = useState(false)
  const [address, setAddress] = useState('')
  const dealAddress = (address: string | undefined) => {
    if (address) {
      return address.slice(0, 3) + '...' + address.slice(-3)
    }
    return address
  }
  return (
    <header className="h-[144px] flex justify-between items-center">
      <img src={logo} alt="logo" className="h-[144px]" />
      <div className="flex-1 flex justify-evenly cursor-pointer">
        {navList.map((item, index) => {
          return (
            <div key={index} onClick={() => console.log(item.link)}>
              {item.name}
            </div>
          )
        })}
      </div>

      <div className="flex justify-between">
        {connected ? (
          <>
            <div className="border border-[#7F56D9] border-solid text-[#475567] px-1 py-2 mx-3">Sui NetWork</div>
            <span
              onClick={() => setShowDisconnected(!showDisconnected)}
              className="bg-[#7f56D9] rounded-lg px-4 py-2 text-[#fff] cursor-pointer relative">
              {dealAddress(wallet.address)}
              {showDisconnected ? (
                <span
                  onClick={() => {
                    wallet.disconnect()
                    setShowModal(false)
                  }}
                  className="absolute right-0 buttom-0 mt-10 bg-[#7f56D9] rounded-lg px-4 py-2 text-[#fff] cursor-pointer">
                  DisConnect
                </span>
              ) : (
                <></>
              )}
            </span>
          </>
        ) : (
          <ConnectModal open={showModal} onOpenChange={(open) => setShowModal(open)}>
            <button className="bg-[#7f56D9] rounded-lg px-4 py-2 text-[#fff] cursor-pointer">
              Connect Wallet to Start
            </button>
          </ConnectModal>
        )}
      </div>
    </header>
  )
}
