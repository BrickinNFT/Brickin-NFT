import checkBox from '@/assets/checkBox.png'
import promptBg from '@/assets/promptBg.png'
export default function Prompt() {
  return (
    // <div className="flex  justify-end items-center border border-[green]">
    <div className="mt-[20px] w-full">
      <div className="w-full flex justify-between ">
        {/*左侧*/}
        <div className="flex flex-[2] justify-end">
          <div className="w-[380px] bg-[#fff] rounded-2xl flex flex-col justify-evenly">
            <div className="flex items-center text-[#344054] text-[24px] mt-4 cursor-pointer">
              <img className="pl-[25px] w-[60px]" src={checkBox} alt="" />
              <span className="pl-[15px]">Collections</span>
            </div>
            <span className="text-[#D0D5DD] pl-[25px] text-[24px] mt-4 cursor-not-allowed">Pool</span>
            <div className="h-[352px] flex flex-col justify-around text-[#344054] pl-[25px] text-[24px] border-0 border-t border-b border-t-[#EAECF0]  border-b-[#EAECF0]">
              <div className=" cursor-pointer">Changelog</div>
              <div className=" cursor-pointer">Slack Community</div>
              <div className=" cursor-pointer">Support</div>
              <div className=" cursor-pointer">API</div>
            </div>
            <div className="text-[#344054] pl-[25px] text-[24px] cursor-pointer">Log out</div>
          </div>
        </div>
        {/*右侧*/}
        <div className="flex-[3] flex flex-col items-center justify-between">
          <img className="h-[200px]" src={promptBg} alt="" />
          <div className=" font-bold text-[50px] text-center text-[#676C83] ">
            Your collection seems to be empty, let’s <span className="text-[#7F56D9]">create </span> your NFT collection
            on <span className="text-[#7F56D9]">SUI Network</span>
          </div>
          <div className="w-[151px] h-[44px] bg-[#7F56D9] rounded-[8px] text-[#fff] text-center leading-[44px] cursor-pointer">
            Click to Create
          </div>
        </div>
      </div>
    </div>
  )
}
