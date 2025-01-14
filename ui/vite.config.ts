import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
const ReactCompilerConfig = {/* ... */};

// https://vitejs.dev/config/
const _plugins = [react()];
// _plugins.push({
//   babel: {
//     plugins: [["babel-plugin-react-compiler", ReactCompilerConfig]]
//   }
// });
// const _plugins = [MillionLint.vite()];
export default defineConfig({
  plugins: _plugins,
  base: './',
  build: {
    outDir: 'build',
    sourcemap: false
  }
});