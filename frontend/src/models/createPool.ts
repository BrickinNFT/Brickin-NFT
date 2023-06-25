import { proxy } from 'valtio'

export const poolInfo = proxy({
  step: 1,
  type: 1,
  nfts: 'Collection',
  tokens: 'Collection',
  startPrice: '25000000000',
  bondingCurve: 'Linear',
  delta: '1',
  fee: '100000000',
  maxVolume: '100',
  maxAccount: '100',
  nftNumber: '0',
})
