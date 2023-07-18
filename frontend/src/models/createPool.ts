import { proxy } from 'valtio'

export const poolInfo = proxy({
  step: 1,
  type: 1,
  nfts: '0xfdff2a83c72cc123ff4d2c396536998fcc0ce7626043bfc97de46291278b29ed',
  tokens: '0x85b8a77886e9560db21be3051d04fd0c67df5d58edfb1862389ad69750e3c1c0::cnyw::CNYW',
  startPrice: '25000000000',
  bondingCurve: 'Linear',
  delta: '1',
  fee: '100000000',
  maxVolume: '100',
  maxAccount: '100',
  nftNumber: '0',
  nft: '0x01c1d7f2049bac49db91e608c5735b958d5bd09a7d24881562aabcf0d3a2f162',
})
