using WGLMakie, Bonito, Observables
using GLMakie
using Downloads, FileIO
include("do_pop.jl")
include("csspop.jl")
#earth_img = load(Downloads.download("https://upload.wikimedia.org/wikipedia/commons/5/56/Blue_Marble_Next_Generation_%2B_topography_%2B_bathymetry.jpg"))
#GLMakie.activate!()
#fig = with_theme(theme_black()) do
#  do_tau(;resolution=(800, 800), fontsize=14)
#end
#save("raw_tau.png", fig)
years = [2000, 2005, 2010, 2015, 2020]
WGLMakie.activate!()
page = Page(offline=true, exportable=true)
app = Bonito.App() do session::Session
    index_slider1 = Bonito.Slider(1:5, style="width: 350px;")
    slider1 = DOM.div("Year: ", index_slider1, #index_slider1.value,
        style="color: #379dc3; background: #282828; border-radius: 5px 5px 5px 5px;")

    fig = with_theme(theme_black()) do
        dopop(index_slider1.value)
    end
    return Bonito.record_states(session, DOM.div(DOM.h1(" "), slider1, @lift("$(years[$index_slider1])"), fig,
      style=figstyle(; #bg = "#$(hex(colorant"white"))"
      )))
end

open("app_pop.html", "w") do io
    println(io, """
    $(headhtml(; #bg = "#$(hex(colorant"white"))",
      #notescolor ="#$(hex(colorant"white"))",
      #titlecolor ="#$(hex(colorant"black"))",
      #acolor = "#$(hex(colorant"gray50"))",
      #bga1 = 0.05,
      #bga2 = 0.1,
      #bga3 = 0.5,
      )
      )
    <body>
      <div class="loader">
          <div></div>
      </div>

      <div id="container"></div>
      $(credits(; #imgsrc = "MPI_BGC_wide_E_black_cmyk.png"
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