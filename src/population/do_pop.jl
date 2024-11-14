using GLMakie
using FileIO
using CSV, DataFrames
using NCDatasets
using ForwardDiff: jacobian
using Downloads, FileIO
using GeometryBasics, Colors, ColorSchemes
using Images
using ArchGDAL
GLMakie.activate!()
#logo = load("./data/MPI_BGC_wide_D_black_rgb.png");
#logo = logo[15:end-15, 25:end-25];

#earth_img = load(Downloads.download("https://www.solarsystemscope.com/textures/download/8k_earth_daymap.jpg"))
#earth_img = load("../8k_earth_daymap.jpeg");
#ds = Dataset("./data/GTOPO30.43200.21600.nc");
dataset = ArchGDAL.read("/Users/lalonso/Documents/BGC25Visuals/populationDensity/data/gpw_v4_population_density_rev11_2020_15_min.tif")
# just in case you want to know more about the file structure
#ArchGDAL.read("filename.tif") do ds
#    println(ArchGDAL.gdalinfo(ds))
#end
dspop = Dataset("/Users/lalonso/Downloads/gpw-v4-population-density-adjusted-to-2015-unwpp-country-totals-rev11_totpop_15_min_nc/gpw_v4_population_density_adjusted_rev11_15_min.nc")
#ds = Dataset("/Users/lalonso/Documents/BGC25Visuals/populationDensity/data/ws10.daily.calc.era5.1440.720.2001.nc")
lon = dspop["longitude"][:]
lat = dspop["latitude"][:]
#heatmap(lon, lat, log2.(pop))
poslab = [1, 11, 101, 1001, 10001, 30_001]
#log10.(poslab)
#earth_img = load("../8k_earth_daymap.jpeg") #load("Land_shallow_topo_alpha_2048.png");
link_img = "https://upload.wikimedia.org/wikipedia/commons/2/25/Land_shallow_topo_alpha_2048.png"
earth_img = load(Downloads.download(link_img))

function dopop(idx_yearv)
    #link_img = "https://upload.wikimedia.org/wikipedia/commons/2/25/Land_shallow_topo_alpha_2048.png"
    #earth_img = load(Downloads.download(link_img))
    #idx_year = Observable(idx_yearv)
    idx_year = lift(idx_yearv) do idx
        return idx
    end
    pop = lift(idx_year) do idyear
        popt = dspop["UN WPP-Adjusted Population Density, v4.11 (2000, 2005, 2010, 2015, 2020): 15 arc-minutes"][:,:,idyear]
        #dataset_read = ArchGDAL.read(dataset)
        #pop = dataset_read[:, :, 1];
        popt = replace(popt, missing=>NaN)
        popt[popt.<0.0] .= NaN
        #popc = copy(pop)
        #minimum(pop[.!isnan.(pop)]) # = 0
        #maximum(pop[.!isnan.(pop)])
        popt = log10.(popt .+ 1)
        return popt
    end

    function SphereTess(; o=Point3f(0), r=1, tess=128)
        return uv_normal_mesh(Tesselation(Sphere(o, r), tess))
    end
    function toCartesian(lon, lat; r=1, cxyz=(0, 0, 0))
        x = cxyz[1] + r * cosd(lat) * cosd(lon)
        y = cxyz[2] + r * cosd(lat) * sind(lon)
        z = cxyz[3] + r * sind(lat)
        return x, y, z
    end

    f(x, y, z) = [1.0 - x^2 - y^2 - z^2]
    J(xx, yy, zz) = jacobian(x -> f(x[1], x[2], x[3]), [xx, yy, zz])
    points = @lift([Point3f(toCartesian(i, j)...) for (id, i) in enumerate(lon) for (jd, j) in enumerate(lat) if isnan($pop[id, jd]) != true])
    rots = @lift([J($points[i]...) for i in 1:length($points)])
    rots = @lift([Vec3f(-$rots[i]...) for i in 1:length($points)])
    values = @lift([$pop[id, jd] for (id, i) in enumerate(lon) for (jd, j) in enumerate(lat) if isnan($pop[id, jd]) != true])
    #valuesc = [popc[id, jd] for (id, i) in enumerate(lon) for (jd, j) in enumerate(lat) if isnan(popc[id, jd]) != true]

    #αvals = range(0.01,0.075, length=20)
    #α = lift(αindx) do idx
    #    return αvals[idx]
    #end
    #Observable(0.015)
    fig = Figure(resolution=(1400, 1400), fontsize = 24) # :ivory2, backgroundcolor=:ivory1
    ga = fig[1, 1] = GridLayout()
    ax = LScene(ga[1, 1]; show_axis=false)

    mesh!(ax, SphereTess(; o=Point3f(0), r=1.0);
        color=circshift(0.85earth_img, (0, 1024)),
        shading=true, transparency=true)
    mesh!(ax, SphereTess(; o=Point3f(0), r=0.99); color=(:steelblue4, 0.75), 
        shading=true,
        transparency=true, #lightposition=Vec3f(0, 0, 1.5),
        ambient = Vec3f(0.6, 0.6, 0.6),
        backlight = 1.0f0)
    sobj = meshscatter!(ax, points; marker=Rect3f(Vec3(-0.5, -0.5, 0), Vec3(1)),
        color=values, rotations=rots, shading=true,
        #colormap = cgrad(:linear_worb_100_25_c53_n256, rev=false), #backlight=5.0f0,
        colormap=cgrad(:CMRmap, rev=true),
        #colormap = cgrad(:tol_ylorbr, rev=false),
        markersize=@lift(Vec3f.(0.004, 0.004, 0.025*$values)),
        #lightposition=Vec3f(0, 0, 1.5)
        colorrange = (0, 4.48)
    )
    #zoom!(ax.scene, cameracontrols(ax.scene), 0.65)
    Colorbar(fig[1, 1, Top()], sobj, label="Persons per square kilometer", #ticklabelsize=18,
        ticks=(log10.(poslab), ["0", "10", "10²", "10³", "", "3×10⁴"]), #string.((poslab .- 1)))
        width=Relative(0.3), 
        vertical=false, flipaxis = false,
    )
    return fig
end

fig = dopop(Observable(1))
#figpop = with_theme(dopop, theme_ggplot2())
#save("world_population.png", fig)
