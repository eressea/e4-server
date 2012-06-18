require "multis"

function process_orders_new()
    eressea.process.make_temp()
    eressea.process.update_long_order()
    eressea.process.settings()
    eressea.process.set_group()

    eressea.process.origin()
    eressea.process.set_help()
    eressea.process.set_prefix()
    eressea.process.set_stealth()
    eressea.process.set_status()
    eressea.process.set_spells()
    eressea.process.set_name()
--[[
  add_proc_order(p, K_GUARD, &guard_off_cmd, 0, NULL);
  add_proc_order(p, K_RESHOW, &reshow_cmd, 0, NULL);

  add_proc_global(p, &alliance_cmd, NULL);

  add_proc_global(p, &age_factions, "Parteienalter++");
  add_proc_order(p, K_MAIL, &mail_cmd, 0, "Botschaften");
]]
    eressea.process.contact()
    eressea.process.enter(false)
    eressea.process.use()
    eressea.process.give_control()
    eressea.process.leave()
    eressea.process.battle()
    eressea.process.siege()
    eressea.process.enter(false)
--[[
  add_proc_order(p, K_RESERVE, &reserve_cmd, 0, "Reservieren");
  add_proc_order(p, K_CLAIM, &claim_cmd, 0, NULL);
  add_proc_unit(p, &follow_unit, "Folge auf Einheiten setzen");

  add_proc_region(p, &economics, "Zerstoeren, Geben, Rekrutieren, Vergessen");

]]
    eressea.process.maintenance()
    eressea.process.quit()
    eressea.process.magic()
    eressea.process.study()
    eressea.process.produce()
    eressea.process.enter(true)
    eressea.process.movement()
--[[
  if (get_param_int(global.parameters, "work.auto", 0)) {
    p += 10;
    add_proc_region(p, &auto_work, "Arbeiten (auto)");
  }

  add_proc_order(p, K_GUARD, &guard_on_cmd, 0, "Bewache (an)");
#if XECMD_MODULE
  /* can do together with guard */
  add_proc_order(p, K_XE, &xecmd, 0, "Zeitung");
#endif

  p += 10;
  add_proc_global(p, &encounters, "Zufallsbegegnungen");
  p += 10;
  add_proc_unit(p, &monster_kills_peasants,
    "Monster fressen und vertreiben Bauern");

  p += 10;
  add_proc_global(p, &randomevents, "Zufallsereignisse");

  p += 10;

  add_proc_global(p, &monthly_healing, "Regeneration (HP)");
  add_proc_global(p, &regeneration_magiepunkte, "Regeneration (Aura)");
  if (!global.disabled[K_DEFAULT]) {
    add_proc_global(p, &defaultorders, "Defaults setzen");
  }
  add_proc_global(p, &demographics, "Nahrung, Seuchen, Wachstum, Wanderung");

]]
    eressea.process.restack()
    eressea.process.promotion()
    eressea.process.renumber()
end

function process(orders)
  local confirmed_multis = { }
  local suspected_multis = { }

  if open_game(get_turn())~=0 then
    print("could not read game")
    return -1
  end
  init_summary()

  -- kill multi-players (external script)
  kill_multis(confirmed_multis, false)
  mark_multis(suspected_multis, false)

  -- run the turn:
  if eressea.read_orders(orders) ~= 0 then
    print("could not read " .. orders)
    return -1
  end

  -- plan_monsters()

  if nmr_check(config.maxnmrs or 80)~=0 then
    return -1
  end

  process_orders()

  -- create new monsters:
  spawn_braineaters(0.25)

  -- post-turn updates:
  update_guards()
  update_scores()

  local localechange = { de = { "ii" } }
  change_locales(localechange)

  write_files(config.locales)

  file = "" .. get_turn() .. ".dat"
  if eressea.write_game(file)~=0 then
    print("could not write game")
    return -1
  end
  return 0
end
