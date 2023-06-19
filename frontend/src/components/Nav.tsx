import checkBox from '@/assets/checkBox.png'

const nav = [
  { name: 'Colletions', link: '' },
  { name: 'Pool', link: '' },
  { name: 'Changelog', link: '' },
  { name: 'Slack Community', link: '' },
  { name: 'Suppport', link: '' },
  { name: 'API', link: '' },
  { name: 'Log out', link: '' },
]

interface Props {
  currentNav: string
}

export default function Nav(props: Props) {
  const { currentNav } = props
  return (
    <nav className="flex items-center">
      <div className=" rounded-2xl flex flex-col items-start w-[272px] bg-white border border-[#EAECF0] border-solid">
        <ul className="w-full">
          {nav.map((item, index) => {
            if (item.name === 'Changelog') {
              return (
                <li key={index} className="p-3 border-0 border-[#EAECF0] border-solid w-full border-t cursor-pointer">
                  {item.name}
                </li>
              )
            }
            if (item.name === 'API') {
              return (
                <li key={index} className="p-3 border-0 border-[#EAECF0] border-solid w-full border-b cursor-pointer">
                  {item.name}
                </li>
              )
            }
            if (item.name === currentNav) {
              return (
                <li key={index} className="flex items-center p-3 cursor-pointer">
                  <img src={checkBox} alt="" className="w-6 h-6 mr-2" />
                  {item.name}
                </li>
              )
            }
            return (
              <li key={index} className="p-3 cursor-pointer">
                {item.name}
              </li>
            )
          })}
        </ul>
      </div>
    </nav>
  )
}
