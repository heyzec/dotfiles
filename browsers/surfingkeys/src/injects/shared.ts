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
    callback();
  }
}
