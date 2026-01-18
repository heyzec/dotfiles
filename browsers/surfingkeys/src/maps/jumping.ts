// GitHub

api.mapkey(
  "<Space>c",
  "Open Code tab",
  function () {
    document.querySelector('span[data-content="Code"]').click();
  },
  { domain: /github\.com/ },
);
api.mapkey(
  "<Space>i",
  "Open Issues tab",
  function () {
    document.querySelector('span[data-content="Issues"]').click();
  },
  { domain: /github\.com/ },
);
api.mapkey(
  "<Space>p",
  "Open Pull Requests tab",
  function () {
    document.querySelector('span[data-content="Pull requests"]').click();
  },
  { domain: /github\.com/ },
);
