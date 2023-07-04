Bun.serve({
  fetch(request: Request):
    | Response
    | Promise<Response> {
    return new Response(Bun.file("./index.html"));
  },

  port: process.env.PORT || 3000,
});
