data = h5open("aggHealpix_t2m.h5", "r")

function do_viz(timev)
    mc = lift(timev) do idx
        datar = data["t2m/npower_5"]
        ds = read(datar)
        resol = Resolution(2^5)
        m, c = domesh(ds[:,idx]; resol=resol)
    end
    m = @lift($mc[1])
    colors = @lift($mc[2])
    tocel = 273.15
    fig = Figure(resolution = (1600, 1200), fontsize = 16)
    ax = LScene(fig[1,1], show_axis = false)
    pltobj = mesh!(ax, m; color = @lift($colors .- tocel),
        colormap =:seaborn_icefire_gradient,
        colorrange = (199 .- tocel, 323 .- tocel),
        transparency=false)
    Colorbar(fig[1, 1, Top()], pltobj,
        width=Relative(0.3), 
        vertical=false, flipaxis = false
        )
    fig, ax, pltobj
end