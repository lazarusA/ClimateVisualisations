using WGLMakie, JSServe, Observables
using GLMakie
using Downloads, FileIO
include("do_forest.jl")
include("cssforest.jl")

#titlecolor = hex(colorant"steelblue4")

WGLMakie.activate!()
page = Page(offline=true, exportable=true)
app = JSServe.App() do session::Session
    fig = with_theme(theme_light()) do
        do_forest()
    end
    return JSServe.record_states(session, DOM.div(DOM.h1(" "), fig,
      style=figstyle(; bg = "#$(hex(colorant"white"))"
      )))
end

open("app_forest.html", "w") do io
    println(io, """
    $(headhtml(; bg = "#$(hex(colorant"white"))",
      notescolor ="#$(hex(colorant"white"))",
      titlecolor ="#$(hex(colorant"black"))",
      acolor = "#$(hex(colorant"gray50"))",
      bga1 = 0.05,
      bga2 = 0.1,
      bga3 = 0.5,
      )
      )
    <body>
      <div class="loader">
          <div></div>
      </div>

      <div id="container"></div>
      $(credits(; imgsrc = "MPI_BGC_wide_E_black_cmyk.png"
        )
      )
      $(title_source)
        """)
      show(io, MIME"text/html"(), page)
      show(io, MIME"text/html"(), app)
      println(io, """
      $(script_ref)
      <script>
          \$(window).on('load',function(){
              \$(".loader").fadeOut(1000);
              \$(".content").fadeIn(1000);
          });
      </script>
    </body>
    </html>
    """)
end
#License CC BY-SA 4.0