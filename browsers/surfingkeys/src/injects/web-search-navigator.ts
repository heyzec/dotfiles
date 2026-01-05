import { inject } from "./shared";
// @ts-ignore
import cssContent from "./web-search-navigator.css";

inject("https://www.google.com/search*", () => {
  const style = document.createElement("style");
  style.textContent = cssContent;
  document.head.appendChild(style);
});
