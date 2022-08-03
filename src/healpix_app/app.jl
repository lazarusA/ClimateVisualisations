using HDF5
using WGLMakie, JSServe, Observables
using Downloads, FileIO
using JSServe: onjs, evaljs, on_document_load, Slider
include("dogeoms.jl")
include("do_viz.jl")
include("css.jl")
#GLMakie.activate!()

WGLMakie.activate!()
page = Page(offline=true, exportable=true)
app = JSServe.App() do session::Session
    #index_slider1 = Slider(1:1:5, style="width: 350px;")
    #slider1 = DOM.div("power: ", index_slider1, index_slider1.value,
    #  style="color: #379dc3; background: #282828; border-radius: 5px 5px 5px 5px;")

    index_slider2 = JSServe.Slider(1:1:28, style="width: 350px;")
    slider2 = DOM.div("Day: ", index_slider2, index_slider2.value, 
      style="color: #379dc3; background: #282828; border-radius: 5px 5px 5px 5px;")
    fig, ax, pltobj = with_theme(theme_black()) do 
      do_viz(index_slider2.value)
    end
    rpage = JSServe.record_states(session, DOM.div(DOM.h1(" "), DOM.div(slider2), fig,
            style=figstyle(; #bg = "#$(hex(colorant"white"))"
        )))
    return rpage
end
open("appt2m_healpix.html", "w") do io
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