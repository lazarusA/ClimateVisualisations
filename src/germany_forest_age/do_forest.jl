using GLMakie, Colors, ColorSchemes
using NCDatasets
ds = Dataset("germany_rep.nc")
lon = ds["x"][:]
lat = ds["y"][:]
data = replace(ds["ForestAge_TC010"][:,:], missing=>NaN)
pnts = [Point3f(lo, la, rand()) for (idx,lo) in enumerate(lon), (idy, la) in enumerate(lat) if !isnan(data[idx,idy])]
vals = [data[idx,idy] for (idx,lo) in enumerate(lon), (idy, la) in enumerate(lat) if !isnan(data[idx,idy])]

cmap = resample_cmap(:Signac, 16)[end:-1:1] # tol_rainbow
rectMesh = Rect3f(Vec3f(minimum(lon), minimum(lat),-100), Vec3f(4abs(minimum(lon)), 5abs(minimum(lon)), 100))

#with_theme(theme_ggplot2()) do 
function do_forest()
    fig = Figure(resolution = (1600, 1200))
    ax = LScene(fig[1,1], show_axis=false)
    pltobj = meshscatter!(ax, pnts; color = vals,
        marker=Rect3f(Vec3(-0.5, -0.5, 0), Vec3(1)),
        markersize=Vec3f.(650, 650, 250vals),
        colormap = cgrad(1.3*cmap, 16, categorical=true),
        colorrange = (10, 170),
        ambient = Vec3f(0.29, 0.29, 0.29),
        )
    mesh!(ax, rectMesh; color =:gainsboro, shading=false, transparency=false)
    cbar = Colorbar(fig[1,1, Top()], pltobj, label= "Years", width=Relative(0.3), 
    vertical=false, flipaxis = false)
    cbar.ticks = (15:10:165, string.(15:10:165))
    zoom!(ax.scene, cameracontrols(ax.scene), 0.65)
    #rotate!(ax.scene, 2.0)
    fig
end
do_forest()
#end