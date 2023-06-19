import twitter from '@/assets/twitter.png'
import ins from '@/assets/in.png'
import fb from '@/assets/fb.png'
import github from '@/assets/github.png'

const links = [
  {
    name: 'twitter',
    imgSrc: twitter,
    link: '#',
  },
  {
    name: 'in',
    imgSrc: ins,
    link: '#',
  },
  {
    name: 'facebook',
    imgSrc: fb,
    link: '#',
  },
  {
    name: 'github',
    imgSrc: github,
    link: '#',
  },
]

export default function Footer() {
  return (
    <footer className="h-[85px] flex justify-between items-center border-solid border-[#7F56D9] border-0 border-t mt-auto">
      <div className="text-[#475467]">© 2023 Brickin. All rights reserved.</div>
      <div className="flex">
        {links.map((item, index) => {
          return (
            <img
              key={index}
              src={item.imgSrc}
              alt={item.name}
              className="h-[24px] mx-2 cursor-pointer"
              onClick={() => console.log(item.link)}
            />
          )
        })}
      </div>
    </footer>
  )
}
