import { defineConfig } from 'umi'

export default defineConfig({
  routes: [
    { path: '/', component: 'prompt' },
    { path: '/prompt', component: 'prompt' },
    { path: '/createPool', component: 'createPool' },
    {
      path: '/processingScreen',
      component: 'processingScreen',
    },
    {
      path: '/successScreen',
      component: 'successScreen',
    },
    {
      path: '/currentPool',
      component: 'currentPool',
    },
  ],

  npmClient: 'yarn',
  tailwindcss: {},
  plugins: ['@umijs/plugins/dist/tailwindcss'],
  jsMinifier: 'terser',
  title: 'Brickin',
  favicons: ['/'],
})
