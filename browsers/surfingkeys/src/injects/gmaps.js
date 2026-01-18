function runMe() {
  const originalOpen = XMLHttpRequest.prototype.open;
  const originalSend = XMLHttpRequest.prototype.send;

  XMLHttpRequest.prototype.open = function(method, url) {
    this._url = url;
    return originalOpen.apply(this, arguments);
  };

  XMLHttpRequest.prototype.send = function() {
    this.addEventListener("load", function() {
      window.dispatchEvent(
        new CustomEvent("XHR_INTERCEPT_EVENT", {
          detail: {
            url: this._url,
            response:
              this.responseType === "" || this.responseType === "text"
                ? this.responseText
                : null,
          },
        }),
      );
    });

    return originalSend.apply(this, arguments);
  };
}
// This must be injected direct into injects into the page context, so it affects page XHR
const fn = runMe.toString();
const s = document.createElement("script");
s.textContent = `(${fn})()`;
document.documentElement.appendChild(s);
s.remove();

function parseUsingConfig(item, config) {
  let output = {};
  for (const [key, path] of Object.entries(config)) {
    let value = item;
    for (const p of path) {
      if (!value || !(p in value)) {
        value = null;
        break;
      }
      value = value[p];
    }
    output[key] = value;
  }
  return output;
}

function parseFromInitState(item) {
  const config = {
    placeId: [78],
    name: [11],
    latitude: [208, 0, 3],
    longitude: [208, 0, 2],
    fullAddress: [18],
  };
  return parseUsingConfig(item, config);
}
function parseFromInitState2(item) {
  const config = {
    placeId: [],
    name: [1],
    latitude: [7, 3],
    longitude: [7, 2],
    fullAddress: [1],
  };
  return parseUsingConfig(item, config);
}

function parseFromPreviewPlace(item) {
  const config = {
    placeId: [],
    name: [11],
    latitude: [9, 3],
    longitude: [9, 2],
    fullAddress: [18],
  };
  return parseUsingConfig(item, config);
}

import JSON5 from "json5";
const places = [];

function stripXssiPrefix(text) {
  const xssiPrefix = ")]}'";
  if (!text.startsWith(xssiPrefix)) {
    console.warn("XSSI prefix not found");
  }
  return text.slice(xssiPrefix.length);
}

window.addEventListener("XHR_INTERCEPT_EVENT", (e) => {
  const { url, response } = e.detail;
  if (url.includes("/maps/preview/place")) {
    const json = JSON.parse(stripXssiPrefix(response));
    const data = json[6];
    console.assert(
      [148, 207, 244, 246].includes(data.length),
      `Unexpected preview place data length: ${data.length}`,
    );
    console.log(data);
    const place = parseFromPreviewPlace(data);
    places.push(place);
  }
  // if (url.includes("/search?tbm=map")) {
  //   var rspJson = JSON.parse(response.replace(`/*""*/`, ""));
  //   var e = rspJson.d;
  //   var cleanedData = e.replace(`)]}'`, "");
  //
  //   let parsedData = JSON.parse(cleanedData);
  //
  //   let entries = parsedData[64];
  //   for (let i = 0; i < entries.length; i++) {
  //     try {
  //       let entry = entries[i];
  //       let inner = entry[1];
  //       let item = formatDataItem(inner);
  //       console.log(item);
  //     } catch (err) {
  //       console.error("Error processing entry:", err);
  //     }
  //   }
  // }
});

if (
  window.location.hostname === "www.google.com" &&
  window.location.pathname.startsWith("/maps")
) {
  addEventListener("load", () => {
    const script = document.head.querySelector("script:not([src])");
    let text = script.textContent;
    let match = text.match(
      /(?<=window.APP_INITIALIZATION_STATE=).+?(?=;\s*window.APP_FLAGS)/,
    );
    const json = match[0];
    const appInitState = JSON5.parse(json);
    try {
      const data = JSON.parse(stripXssiPrefix(appInitState[3][6]));
      const place = parseFromInitState(data[6]);
      places.push(place);
      // console.log(
      //   `Managed to get from appInitState[3][6], and look: appInitState[5]: ${!!appInitState[5]}`,
      // );
    } catch (err) {
      if (appInitState[3] === null) {
        // console.error(`appInitState[3] is null, try appInitState[5] instead`);
        const data = appInitState[5][3][2];
        const place = parseFromInitState2(data);
        places.push(place);
      }
    }
  });
}

function getPlace() {
  const match = window.location.href.match(/(?<=place\/).+(?=\/@)/);
  const placeName = decodeURIComponent(match[0]).replace(/\+/g, " ");
  const place = places.find((p) => p.name === placeName);
  if (!place) {
    console.error("Place not found in cached places:", placeName);
    console.error(placeName);
    console.error(places);
    return;
  }
  return place;
}

// Google Maps coordinates reversed engineered
api.mapkey(
  "yc",
  "Copy coordinates",
  () => {
    if (!window.location.href.startsWith("https://www.google.com/maps/place")) {
      return;
    }
    const place = getPlace();
    api.Clipboard.write(`${place.latitude}, ${place.longitude}`);
  },
  {
    domain: /www\.google\.com/,
  },
);

// Copy obsidian link
api.mapkey(
  "yl",
  "Copy link",
  () => {
    if (!window.location.href.startsWith("https://www.google.com/maps/place")) {
      return;
    }
    const place = getPlace();
    const link = `[${place.name}](geo:${place.latitude},${place.longitude})`;
    api.Clipboard.write(link);
  },
  {
    domain: /www\.google\.com/,
  },
);

// See https://github.com/infokiller/web-search-navigator/issues/427#issuecomment-1236426192
if (window.location.hostname === "www.google.com") {
  const style = document.createElement("style");
  document.head.appendChild(style);
  style.textContent = `
.wsn-google-focused-link::before,
.wsn-google-focused-map::before {
    border-left: 3px solid #2586fc !important;
    content: "";
    display: block;
    height: 100%;
    margin-right: 10px;
    left: -10px;
    position: absolute;
}
`;
}

// Autoclose Seatalk
if (window.location.hostname === "link.seatalk.io") {
  let count = 1;
  function iter() {
    if (count >= 0) {
      document.querySelector(".content-wrapper > div > .text").innerHTML =
        `Closing in ${count} seconds...`;
      count--;
    } else {
      window.close();
    }
  }
  iter();
  setInterval(iter, 1000);
}

