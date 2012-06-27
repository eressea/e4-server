#include <platform.h>

#include <kernel/types.h>
#include <kernel/config.h>

#include <kernel/alliance.h>
#include <kernel/battle.h>
#include <kernel/faction.h>
#include <kernel/order.h>
#include <kernel/region.h>
#include <kernel/unit.h>

#include <util/parser.h>

static void resolve_combat(battle * b)
{
}

static bool add_enemies(battle * b, const alliance * al)
{
  unit * u;
  region * r = b->region;
  bool found = false;
  for (u=r->units;u;u=u->next) {
    struct ally * ally = ally_find(al->allies, u->faction);
    if (ally && ally->status&ALLY_ENEMY) {
      fighter * fi = get_fighter(b, u);
      if (!fi) {
        side * s = get_side(b, u);
        if (!s) s = make_side(b, u->faction, 0, 0, 0);
        fi = make_fighter(b, u, s, false);
      }
      found = true;
    }
  }
  return found;
}

static void add_combatants(battle * b, region * r)
{
  direction_t dir = reldirection(r, b->region);
  unit *u;

  for (u=r->units;u;u=u->next) {
    order * ord;
    alliance * al = 0;

    for (ord=u->orders;ord;ord=ord->next) {
      if (get_keyword(ord)==K_ATTACK) {
        direction_t d;

        init_tokens(ord);
        skip_token();
        d = getdirection(u->faction->locale);
        if (d==dir) {
          al = f_get_alliance(u->faction);
          if (add_enemies(b, al)) {
            fighter * fi;
            side * s;
            /* TODO: first, find an enemy! */
            s = get_side(b, u);
            if (!s) s = make_side(b, u->faction, 0, 0, 0);
            fi = make_fighter(b, u, s, true);
          }
        }
      }
    }
  }
}

void do_battle_e4(void)
{
  region * r;
  battle b;

  battle_init(&b);

  for (r=regions; r; r=r->next) {
    region *rnext[MAXDIRECTIONS];
    int dir;

    b.region = r;
    add_combatants(&b, r);
    get_neighbours(r, rnext);
    for (dir=0;dir!=MAXDIRECTIONS;++dir) {
      region *rn = rnext[dir];
      add_combatants(&b, rn);
    }

    if (b.nsides>1) {
      resolve_combat(&b);
      battle_free(&b);
      battle_init(&b);
    }
  }
}
