/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        'uib-color': '#474554',
      },
      keyframes: {
        swing: {
          '0%': { transform: 'rotate(0deg)', 'animation-timing-function': 'ease-out' },
          '25%': { transform: 'rotate(70deg)', 'animation-timing-function': 'ease-in' },
          '50%': { transform: 'rotate(0deg)', 'animation-timing-function': 'linear' },
        },
        swing2: {
          '0%': { transform: 'rotate(0deg)', 'animation-timing-function': 'linear' },
          '50%': { transform: 'rotate(0deg)', 'animation-timing-function': 'ease-out' },
          '75%': { transform: 'rotate(-70deg)', 'animation-timing-function': 'ease-in' },
        },
      },
      animation: {
        swing: 'swing 1.2s linear infinite',
        swing2: 'swing2 1.2s linear infinite',
      },
    },
  },
  plugins: [
     function ({ addComponents }) {
      addComponents({
        '.newtons-cradle': {
          '@apply relative flex items-center justify-center': {},
          width: '50px',
          height: '50px',
        },
        '.newtons-cradle__dot': {
          '@apply relative flex items-center': {},
          height: '100%',
          width: '25%',
          'transform-origin': 'center top',
        },
        '.newtons-cradle__dot::after': {
          content: '""',
          '@apply block': {},
          width: '100%',
          height: '25%',
          'border-radius': '50%',
          'background-color': '#474554',
        },
        '.newtons-cradle__dot:first-child': {
          '@apply animate-swing': {},
        },
        '.newtons-cradle__dot:last-child': {
          '@apply animate-swing2': {},
        },
      });
    },
  ],
}

