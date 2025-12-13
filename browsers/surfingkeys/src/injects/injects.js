// ###############################################################################
// ## Injects (Poor man's Tampermonkey)
// ###############################################################################
const regex = /confluence\..+\..+/;
const domain = window.location.hostname; // e.g. "confluence.example.com"

if (window.location.protocol === "confluence.shopee.io") {
  const xpath = "//*[normalize-space(text())='Log in with Google']";
  const result = document.evaluate(
    xpath, // the XPath string
    document, // context node (document or element)
    null, // namespace resolver (usually null)
    XPathResult.FIRST_ORDERED_NODE_TYPE, // return type
    null,
  );
  const button = result.singleNodeValue;
  if (button) {
    // alert("Clicking");
    button.click();
  }
}

