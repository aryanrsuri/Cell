import { serve } from "https://deno.land/std@0.192.0/http/server.ts";
// import { serveFile } from "https://deno.land/std@0.140.0/http/file_server.ts";
const HTML = await Deno.readFile(`${Deno.cwd()}/index.html`);

// serve(async (req) => {
//   return await serveFile(req, `${Deno.cwd()}/index.html`);
// });

serve(async () => {
  return new Response(HTML, {
    headers: {
      "content-type": "text/html",
    },
  });
});
