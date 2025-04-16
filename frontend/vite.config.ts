import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';
import path from 'path';
import { TanStackRouterVite } from '@tanstack/router-vite-plugin';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react(), TanStackRouterVite()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, 'src'), // `@` を `src` にマッピング
    },
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:3100', // バックエンドのアドレス
        changeOrigin: true,
        cookieDomainRewrite: '',
        secure: false,
      },
    },
  },
});
