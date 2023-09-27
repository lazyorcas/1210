module.exports = {
  content: [
    "./public/*.html",
    "./app/views/**/*.{erb,html}",
    "./app/components/**/*.{erb,html}",
    "./config/initializers/heroicon.rb"
  ],
  theme: {
    extend: {
      screens: {
        standalone: { raw: "@media all and (display-mode: standalone)" }
      }
    }
  }
};
