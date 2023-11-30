--==============================================================================
--                            mono_eye.lua
--
--  Date    : 24/08/2018
--  Author  : IDEHARA Norimichi
--  Version : v0.1
--  License : Distributed under the terms of GNU GPL version 2 or later
--
--==============================================================================

require 'cairo'

-- Temperature Eye

function draw_temperature_eye(display)
    temperature = tonumber(${hwmon 4 temp 1})
    if temperature<35 then 
      temperature=35 
    elseif temperature>85 then 
      temperature=85 
    end
    if temperature<45 then
        cs = (temperature-35) / 10.
        pat = cairo_pattern_create_radial(70,150,0, 70,150,10)
        cairo_pattern_add_color_stop_rgba(pat, 0, cs,0,(1-cs),1)
        cairo_pattern_add_color_stop_rgba(pat, 1,  0, 0, 0     ,1)
        cairo_set_source(display, pat)
    elseif temperature<65 then
        cs = (temperature-45) / 20.
        pat = cairo_pattern_create_radial(70,150,0, 70,150,30*cs+10)
        cairo_pattern_add_color_stop_rgba(pat,   0, 1, 0, 0,1)
        cairo_pattern_add_color_stop_rgba(pat, 0.3*cs, 0.9, 0, 0,1)
        cairo_pattern_add_color_stop_rgba(pat,   1, 0, 0, 0,1)
        cairo_set_source(display, pat)
    else
        cs = (temperature-65) / 20.
        pat = cairo_pattern_create_radial(70,150,0, 70,150, 40)
        cairo_pattern_add_color_stop_rgba(pat, 0,  1-cs*0.1*2, cs*0.9*2, cs*2,1)
        cairo_pattern_add_color_stop_rgba(pat, cs/2.0+0.3,  0.9, 0,0,1)
        cairo_pattern_add_color_stop_rgba(pat, 1,  0, 0, 0,1)
        cairo_set_source(display, pat)
    end
    cairo_arc(display, 70, 150, 30, 0, 2*3.1415926) 
    cairo_fill(display)
    cairo_pattern_destroy(pat)
end 

-- main
   
function conky_main()
    if conky_window == nil then 
        return
    end

    local cs = cairo_xlib_surface_create(conky_window.display, conky_window.drawable, conky_window.visual, conky_window.width, conky_window.height)
    local display = cairo_create(cs)
    
    local updates = conky_parse('${updates}')
    update_num = tonumber(updates)
    
    if update_num > 2 then
        draw_temperature_eye(display)
    end

    cairo_destroy(display)
    cairo_surface_destroy(cs)
end

