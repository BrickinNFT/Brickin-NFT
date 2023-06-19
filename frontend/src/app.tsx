import { WalletProvider } from '@suiet/wallet-kit'
import '@suiet/wallet-kit/style.css'
export function rootContainer(container: any) {
  return <WalletProvider>{container}</WalletProvider>
}
