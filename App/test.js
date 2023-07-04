const fs = require("fs");
const source = fs.readFileSync("../main.wasm");
const typedArray = new Uint8Array(source);
//
// WebAssembly.compileStreaming(source)
//   .then((mod) => {
//     const imports = WebAssembly.Module.imports(mod);
//     console.log(imports[0]);
//   });
WebAssembly.instantiate(typedArray, {
  env: { main },
}).then((result) => {
  console.log(result.instance.exports.main);
});
