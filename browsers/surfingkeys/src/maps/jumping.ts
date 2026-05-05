// GitHub

api.mapkey("<Space>", "*[data-hotkey]", function () {
  const dataContents = [
    "Code",
    "Issues",
    "Pull requests",
    "Discussions",
    "Actions",
    "Wiki",
  ];

  // GitHub has built-in hotkeys, and these elements have a data-hotkey tag
  let cssSelector = "[data-hotkey]:has(";
  for (const dataContent of dataContents) {
    cssSelector += `> [data-content="${dataContent}"],`;
  }
  cssSelector = cssSelector.slice(0, -1) + ")";

  // this is a hack because surfingkeys cannot provide a custom function to map element to hint char to generate
  // consider create issues or PR
  api.Hints.setCharacters("cipdaw");

  api.Hints.create(cssSelector, function (element: HTMLElement) {
    element.click();
    api.Hints.setCharacters("asdfgqwertzxcvb"); // need to reset only after click, otherwise the hint char will not be detected
  });

  setTimeout(() => {
    api.Hints.setCharacters("asdfgqwertzxcvb");
  }, 1000);
});
