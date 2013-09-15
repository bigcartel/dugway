name: "Test Theme"
version: "1.2.3"
images: [
  variable: "logo"
  label: "Logo"
  description: "Good for an image up to 150 pixels wide"
,
  variable: "background_image"
  label: "Background Image"
  description: "Adds a repeating background image"
]
fonts: [
  variable: "header_font"
  label: "Header Font"
  default: "Helvetica"
,
  variable: "font"
  label: "Font"
  default: "Georgia"
]
colors: [
  variable: "background_color"
  label: "Background"
  default: "#222222"
,
  variable: "link_color"
  label: "Link Color"
  default: "red"
]
options: [
  variable: "show_search"
  label: "Show search"
  type: "boolean"
  default: false
  description: "Shows a search field"
,
  variable: "fixed_sidebar"
  label: "Fixed Sidebar"
  type: "boolean"
  default: true
  description: "Keeps the sidebar stationary while the page scrolls"
]
