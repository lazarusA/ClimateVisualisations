figstyle(; bg = "#000000") = """
      display: flex;
      align-items: center;
      background-color: $(bg);
      color: white;
      justify-content: center;
      flex-direction: column;
      width: 100%;
"""
headhtml(; bg = "#000000", 
    notescolor = "gray50", titlecolor = "#ffffff",
    acolor = "#aaa", bga1 = 0.2, bga2 = 0.8, bga3 = 0.2) = """
  <head>
    <title>Density population</title>
    <meta charset="utf-8">
    <style type="text/css">
      html {
        height: 100%;
      }
      body {
        margin: 0;
        padding: 0;
        background: $(bg) center center no-repeat;
        color: #ffffff;
        font-family: sans-serif;
        font-size: 13px;
        line-height: 20px;
        height: 100%;
      }

      #info {
        font-size: 11px;
        position: absolute;
        bottom: 5px;
        background-color: rgba(0,0,0,$(bga2));
        color: $(titlecolor);
        border-radius: 3px;
        right: 10px;
        padding: 10px;

      }

      a {
        color: $(acolor);
        text-decoration: none;
      }
      a:hover {
        text-decoration: underline;
      }

      .bull {
        padding: 0 5px;
        color: gray;
      }
      .bull:hover {
        color: #fff;
      }

      #title {
        position: absolute;
        top: 125px;
        width: 200px;
        left: 20px;
        background-color: rgba(0,0,0,$(bga1));
        color: $(titlecolor);
        border-radius: 3px;
        font: 20px Gill Sans MT;
        padding: 10px;
        border-bottom: 1px solid rgba(255,255,255,0.4);
      }
      #notes {
      	position: absolute;
      	top: 225px;
      	left: 20px;
      	width: 200px;
        background-color: rgba(0,0,0,$(bga3));
        color: $(notescolor);
        border-radius: 3px;
        font: 12px Georgia;
        padding: 10px;
      }
      .content{
          display: none;
      }
      .loader{
          height: 100vh;
          width: 100vw;
          overflow: hidden;
          background-color: #16191e;
          position: absolute;
      }
      .loader>div{
          height: 100px;
          width: 100px;
          border: 15px solid #45474b;
          border-top-color: #2a88e6;
          position: absolute;
          margin: auto;
          top: 0;
          bottom: 0;
          left: 0;
          right: 0;
          border-radius: 50%;
          animation: spin 1.5s infinite linear;
      }
      @keyframes spin{
          100%{
              transform: rotate(360deg);
          }
      }

    </style>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
  </head>
"""
credits(; imgsrc= "MPI_BGC_wide_E_neg_cmyk.png") = """
  <div id="info">
  <strong>Created by <a href="https://github.com/lazarusA">Lazaro Alonso</a></strong>
  <span class="bull">&bull;</span>
  <a href="https://github.com/lazarusA/ClimateVisualisations/">Source code</a>
  <span class="bull">&bull;</span>
  Done with <a href="https://makie.juliaplots.org/stable/documentation/backends/wglmakie/">WGLMakie</a>
  <span class="bull">&bull;</span>
  <strong>MPI-BGI <a href="https://www.bgc-jena.mpg.de/en/bgi/gallery/">Project Vis</a></strong>
  <span class="bull">&bull;</span>
  <strong>License <a href="https://creativecommons.org/licenses/by-sa/4.0/">CC BY-SA 4.0</a></strong>
  <span class="bull">&bull;</span>
  <a href="https://www.bgc-jena.mpg.de/en/bgi/gallery/" style="color: green; font-size: 14px;"><img src="./imgs/logos/$(imgsrc)" height=60px;></a>
  </div>
"""
title_source = """
  <div id="title" align="left">
    <span style="font-size:100%">Density population</span>
    <br>
    <button onclick="showReference()">Reference</button>

  </div>
  <div id="notes">
    <p>
    Center for International Earth Science Information Network - CIESIN - Columbia University. 2018.
    Gridded Population of the World, Version 4 (GPWv4): Population Density Adjusted to Match 2015 Revision UN WPP Country Totals,
    Revision 11. Palisades, New York: NASA Socioeconomic Data and Applications Center (SEDAC). https://doi.org/10.7927/H4F47M65.
    Accessed 2 Aug 2022.
    </p>

  </div>
"""
script_ref = """
      <script>
        function showReference() {
          var x = document.getElementById("notes");
          if (x.style.display === "none") {
            x.style.display = "block";
          } else {
            x.style.display = "none";
          }
        }
      </script>
"""