import { defineConfig } from 'umi'

export default defineConfig({
  routes: [
    { path: '/', component: 'createPool' },
    { path: '/prompt', component: 'prompt' },
    {
      path: '/currentPool',
      component: 'currentPool',
    },
    { path: '/createPool', component: 'createPool' },
    {
      path: '/processingScreen',
      component: 'processingScreen',
    },
    {
      path: '/successScreen',
      component: 'successScreen',
    },
  ],

  npmClient: 'yarn',
  tailwindcss: {},
  plugins: ['@umijs/plugins/dist/tailwindcss'],
  jsMinifier: 'terser',
  title: 'Brickin',
  favicons: ['/'],
})
