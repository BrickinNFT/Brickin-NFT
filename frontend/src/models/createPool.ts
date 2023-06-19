import { proxy } from 'valtio'

export const poolInfo = proxy({
  step: 1,
  type: 1,
  nfts: '',
  tokens: '',
  startPrice: '100',
  bondingCurve: 'Linear',
  delta: '1',
  fee: '100',
  maxVolume: '100',
  maxAccount: '100',
  nftNumber: '0',
})
