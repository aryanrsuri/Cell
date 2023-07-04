import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
import { serveFile } from "https://deno.land/std@0.140.0/http/file_server.ts";
const HTML = `
<!DOCTYPE html>
<html lang="en">

<head>
  <title></title>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="css/style.css" rel="stylesheet">
</head>

<body>


  <main>
    <div>

      Zig wasm
    </div>
  </main>
  <script>

    console.log("Hello World throuh JS");
  </script>

</body>

</html>
`;

const INDEX = await Deno.readFile("../App/index.html");
// serve(async (req) => {
//   return await serveFile(req, `${Deno.cwd()}/index.html`);
// });

serve(async () => {
  return new Response(INDEX, {
    headers: {
      "content-type": "text/html",
    },
  });
});
