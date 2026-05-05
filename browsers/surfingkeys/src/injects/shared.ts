function matchUrl(url: string | RegExp): boolean {
  let regex: RegExp;
  if (typeof url === "string") {
    // Convert wildcard pattern to regex
    const escaped = url.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
    const pattern = escaped.replace(/\\\*/g, ".*");
    regex = new RegExp(`^${pattern}$`);
  } else if (url instanceof RegExp) {
    regex = url;
  }
  return regex.test(window.location.href);
}

export function inject(match: string | RegExp, callback: Function): void {
  if (matchUrl(match)) {
    setTimeout(() => {
      // hacky way to wait for page load
      callback();
    }, 500);
  }
}

// This pattern breaks the convention when using import "X.css"
export function injectCss(match: string | RegExp, css: string): void {
  if (matchUrl(match)) {
    console.error("injectCss", match, css);
    const style = document.createElement("style");
    style.textContent = css;
    document.head.appendChild(style);
  }
}

export function injectWithTm(match: string | RegExp, callback: Function): void {
  if (matchUrl(match)) {
    window.postMessage({
      type: "FROM_SURFINGKEYS",
      code: callback.toString(),
    });
  }
}
