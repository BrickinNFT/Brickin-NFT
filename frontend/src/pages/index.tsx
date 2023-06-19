import bg from '@/assets/indexBg.png'

export default function Index() {
  return (
    <div className="flex justify-center items-center">
      <div className="flex-[4]">
        <div className="w-4/5 mx-auto">
          <div className="text-[#475467] text-[45px] font-bold">
            Connecting The World to You: Where Gaming and NFT Unite
          </div>
          <div className="text-[#475467] text-[20px] mt-6 mb-8">
            Explore a new dimension of gaming through our powerful and unique NFT integration sdk.
          </div>
          <div className="flex justify-between">
            <input
              type="text"
              placeholder="Enter your email"
              className="flex-[7] bg-white placeholder:text-[#667085] p-2 outline-none rounded-lg "
            />
            <button className="flex-[3] bg-[#7f56D9] rounded-lg px-4 py-2 text-[#fff] cursor-pointer ml-4">
              Learn More
            </button>
          </div>
          <div className="text-[#475467] text-[12px] my-2">We care about your data in our privacy policy</div>
        </div>
      </div>
      <div className="flex-[6] flex justify-center">
        <img src={bg} alt="bg" className="w-8/12" />
      </div>
    </div>
  )
}
