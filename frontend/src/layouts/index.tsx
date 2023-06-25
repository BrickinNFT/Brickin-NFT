import { Outlet } from 'umi'
import Header from '@/components/Header'
import Footer from '@/components/Footer'
// border-red-500 border border-solid
export default function Layout() {
  return (
    <div className="min-h-screen bg-gradient-to-b from-[#F3E3FA] to-[#D8ACEC]">
      <div className="container mx-auto flex flex-col justify-between min-h-screen">
        <Header></Header>
        <main className="flex-grow mb-4">
          <Outlet />
        </main>
        <Footer></Footer>
      </div>
    </div>
  )
}
