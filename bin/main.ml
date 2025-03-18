let () =
  Dream.run ~interface:"0.0.0.0" ~port:8080
  @@ Dream.logger @@ Dream.livereload
  @@ Dream.router
       [ Dream.get "/" (Dream.from_filesystem "static" "index.html")
       ; Dream.get "/static/**" (Dream.static "static")
       ; Dream.get "/quiz" (fun _ -> Dream.html "Sample text") ]
