#include <platform.h>

#include <kernel/types.h>
#include <kernel/config.h>

#include <kernel/battle.h>
#include <kernel/faction.h>
#include <kernel/order.h>
#include <kernel/region.h>
#include <kernel/unit.h>

#include <util/parser.h>

static void resolve_combat(battle * b) {
}

void do_battle_e4(void) {
  region * r;
  battle b;

  for (r=regions; r; r=r->next) {
    region *rnext[MAXDIRECTIONS];
    int dir;
    int is_combat = 0;

    get_neighbours(r, rnext);
    for (dir=0;dir!=MAXDIRECTIONS;++dir) {
      region *rn = rnext[dir];
      if (rn) {
        unit *u;
        for (u=r->units;u;u=u->next) {
          order * ord;
          for (ord=u->orders;ord;ord=ord->next) {
            if (get_keyword(ord)==K_ATTACK) {
              direction_t d;
              init_tokens(ord);
              skip_token();
              d = getdirection(u->faction->locale);
              if (dir_invert(d)==dir) {
                if (!is_combat) {
                  is_combat = 1;
                  battle_init(&b);
                }
                /* make_fighter(&b, u); */
              }
            }
          }
        }
      }
    }

    if (is_combat) {
      resolve_combat(&b);
      battle_free(&b);
    }
  }
}