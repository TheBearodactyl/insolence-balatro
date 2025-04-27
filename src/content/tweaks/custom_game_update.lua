local g_up = Game.update

local bearo_roto_dt = 0
local bearo_metro_dt = 0
local bearo_garry_dt = 0
local bearo_stop_dt = 0
local bearo_dash_dt = 0
function Game:update(dt)
    g_up(self, dt)

    local anim_timer = self.TIMERS.REAL * 1.1

    bearo_roto_dt = bearo_roto_dt + dt
    bearo_metro_dt = bearo_metro_dt + dt
    bearo_garry_dt = bearo_garry_dt + dt
    bearo_stop_dt = bearo_stop_dt + dt
    bearo_dash_dt = bearo_dash_dt + dt

    if G.P_CENTERS and G.P_CENTERS.j_bearo_roto and bearo_roto_dt > 0.1 then
        bearo_roto_dt = 0

        local rotoscoped_obj = G.P_CENTERS.j_bearo_roto

        if rotoscoped_obj.pos.x == 7 and rotoscoped_obj.pos.y == 9 then
            rotoscoped_obj.pos.x = 0
            rotoscoped_obj.pos.y = 0
        elseif rotoscoped_obj.pos.x < 8 then
            rotoscoped_obj.pos.x = rotoscoped_obj.pos.x + 1
        elseif rotoscoped_obj.pos.y < 9 then
            rotoscoped_obj.pos.x = 0
            rotoscoped_obj.pos.y = rotoscoped_obj.pos.y + 1
        end
    end

    if G.P_CENTERS and G.P_CENTERS.j_bearo_metroman and bearo_metro_dt > 0.1 then
        bearo_metro_dt = 0

        local metroman_obj = G.P_CENTERS.j_bearo_metroman

        if metroman_obj.pos.x == 10 and metroman_obj.pos.y == 7 then
            metroman_obj.pos.x = 0
            metroman_obj.pos.y = 0
        elseif metroman_obj.pos.x < 14 then
            metroman_obj.pos.x = metroman_obj.pos.x + 1
        elseif metroman_obj.pos.y < 7 then
            metroman_obj.pos.x = 0
            metroman_obj.pos.y = metroman_obj.pos.y + 1
        end
    end

    if G.P_CENTERS and G.P_CENTERS.j_bearo_garry and bearo_garry_dt > 0.1 then
        bearo_garry_dt = 0

        local garry_obj = G.P_CENTERS.j_bearo_garry

        if garry_obj.pos.x == 8 and garry_obj.pos.y == 3 then
            garry_obj.pos.x = 0
            garry_obj.pos.y = 0
        elseif garry_obj.pos.x < 9 then
            garry_obj.pos.x = garry_obj.pos.x + 1
        elseif garry_obj.pos.y < 4 then
            garry_obj.pos.x = 0
            garry_obj.pos.y = garry_obj.pos.y + 1
        end
    end

    if G.P_CENTERS and G.P_CENTERS.j_bearo_filthy and bearo_stop_dt > 0.025 then
        bearo_stop_dt = 0

        local stop_obj = G.P_CENTERS.j_bearo_filthy

        if stop_obj.pos.x == 0 and stop_obj.pos.y == 77 then
            stop_obj.pos.x = 0
            stop_obj.pos.y = 0
        elseif stop_obj.pos.x < 9 then
            stop_obj.pos.x = stop_obj.pos.x + 1
        elseif stop_obj.pos.y < 77 then
            stop_obj.pos.x = 0
            stop_obj.pos.y = stop_obj.pos.y + 1
        end
    end

    if G.P_CENTERS and G.P_CENTERS.j_bearo_mimendash and bearo_dash_dt > 0.025 then
        bearo_dash_dt = 0

        local dash_obj = G.P_CENTERS.j_bearo_mimendash

        if dash_obj.pos.x == 200 and dash_obj.pos.y == 18 then
            dash_obj.pos.x = 0
            dash_obj.pos.y = 0
        elseif dash_obj.pos.x < 200 then
            dash_obj.pos.x = dash_obj.pos.x + 1
        elseif dash_obj.pos.y < 18 then
            dash_obj.pos.x = 0
            dash_obj.pos.y = dash_obj.pos.y + 1
        end
    end

    if G.P_CENTERS and G.P_CENTERS.j_bearo_boobs then
        if BEARO.MOD.config and BEARO.MOD.config.adult_mode == true then
            G.P_CENTERS.j_bearo_boobs.soul_pos = { x = 10000000, y = 100000000 }
        elseif BEARO.MOD.config.adult_mode == false then
            G.P_CENTERS.j_bearo_boobs.soul_pos = { x = 12, y = 2 }
        end
    end
end
