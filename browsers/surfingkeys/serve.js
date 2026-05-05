// This script serves and watches src simultaneously
// Refer to https://esbuild.github.io/api/#live-reload

const esbuild = require("esbuild");

const config = esbuild.context({
  entryPoints: ["src/index.ts"],
  bundle: true,
  outfile: "dist/surfingkeys.js",
  loader: { ".css": "text" },
  // sourcemap: "inline", // sourcemap idea doesn't work because surfingkeys runs user code via Function
});

main();

async function main() {
  const ctx = await config;
  await ctx.watch();

  let { hosts, port } = await ctx.serve({
    servedir: "dist",
    port: parseInt(process.env.PORT),
  });
  console.log(`Serving on http://${hosts[0]}:${port}`);
}
