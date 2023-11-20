module.exports = {
  content: [
    "./public/*.html",
    "./app/views/**/*.{erb,html}",
    "./app/components/**/*.{rb,erb,html}",
    "./app/javascript/**/*.js",
    "./config/initializers/heroicon.rb"
  ],
  theme: {
    extend: {
      screens: {
        standalone: { raw: "(display-mode: standalone)" }
      }
    }
  }
};
