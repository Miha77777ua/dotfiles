#include <curses.h>
#include <linux/limits.h>
#include <menu.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <dirent.h>
#include <sys/stat.h>

#define ESC 27
#define ENTER 10
#define SPACE 32
#define CTRL_N 14
#define CTRL_P 16
#define BORDERS 2
#define PADS_H 2
#define PADS_W 8
#define PADS_MENU 25
#define TEXT_W 33
#define TEXT_H 1

void read_packages(char *packages[][2], int *count, char *string_dir) {
  DIR *dir = opendir(string_dir);
  if (!dir) return;
  char path[PATH_MAX];
  struct dirent *entry;
  struct stat st;

  *count = 0;

  while ((entry = readdir(dir)) != NULL) {
    sprintf(path, "%s/%s", string_dir, entry->d_name);

    if (entry->d_name[0] == '.')
        continue;

    if (strcmp(entry->d_name, "installer") == 0)
        continue;

    if (strcmp(entry->d_name, "preview") == 0)
        continue;

    stat(path, &st);

    if (!S_ISDIR(st.st_mode))
        continue;

    packages[*count][0] = strdup(entry->d_name);
    packages[*count][1] = "[ ]";

    (*count)++;
  }

  closedir(dir);
}

void handle_resize(WINDOW *win, int h, int w) {
  int y = (LINES - h) / 2;
  int x = (COLS - w) / 2;

  erase();
  mvwin(win, y, x);
  mvprintw(LINES - 1, 0, "j/k or CTRL+N/CTRL+P: Move   SPACE: Toggle   ENTER: Install   q/ESC: Quit");

  refresh();
  wrefresh(win);
}

void popup(char *msg) {
  int h = 5;
  int w = 21;

  WINDOW *popup_win = newwin(h, w, (LINES - h) / 2, (COLS - w) / 2);

  box(popup_win, 0, 0);
  wattron(popup_win, A_BOLD);
  mvwprintw(popup_win, 2, 7, "%s", msg);
  wattroff(popup_win, A_BOLD);
  wrefresh(popup_win);
  wgetch(popup_win);
  delwin(popup_win);
}

int handle_stow(char *progs[][2], int len) {
  for (int i = 0; i < len; i++) {
    if (strcmp(progs[i][1], "[X]") == 0) {
      char command[64] = "stow --no-folding ";
      strcat(command, progs[i][0]);

      int code = system(command);

      if (code != 0) {
        return 1;
      }
    }
  }

  return 0;
}

char *choices[20][2];

int main(int argc, char* argv[]) {
  char *dir;
  int n_choices;
  int c;
  int win_h, win_w, menu_h, menu_w;
  ITEM **items;
  MENU *menu;
  ITEM *cur;
  WINDOW *win;
  WINDOW *sub;

  if (argc == 1) {
    printf("Usage: %s <path>\n", argv[0]);
    return 1;
  } else if (strcmp(argv[1], "-h") == 0 || strcmp(argv[1], "--help") == 0) {  
    printf("Usage: %s <path>\n", argv[0]);
    return 0;
  } else {
    dir = argv[1];
  }

  read_packages(choices, &n_choices, dir);

  initscr();
  cbreak();
  noecho();
  keypad(stdscr, TRUE);
  curs_set(0);
  set_escdelay(25);
  refresh();

  items = (ITEM **)calloc(n_choices + 1, sizeof(ITEM *));

  for (int i = 0; i < n_choices; i++) {
    items[i] = new_item(choices[i][0], choices[i][1]);
  }

  menu = new_menu(items);
 
  scale_menu(menu, &menu_h, &menu_w);

  win_h = menu_h + BORDERS + PADS_H + TEXT_H + 1;
  win_w = TEXT_W + BORDERS + PADS_W;

  win = newwin(win_h, win_w, (LINES - win_h) / 2, (COLS - win_w) / 2);
  sub = derwin(win, menu_h, menu_w, (BORDERS + PADS_H) / 2 + TEXT_H + 1, (BORDERS + PADS_MENU) / 2);
  box(win, 0, 0);
  
  set_menu_win(menu, win);
  set_menu_sub(menu, sub);
  set_menu_mark(menu, "");
  post_menu(menu);
  wattron(win, A_BOLD);
  mvwprintw(win, 2, 13, "Dotfiles stower");
  wattroff(win, A_BOLD);
	wrefresh(win);

  mvprintw(LINES - 1, 0, "j/k or CTRL+N/CTRL+P: Move   SPACE: Toggle   ENTER: Install   q/ESC: Quit");
  refresh();

	for(;;) {   
    c = getch();

    if (c == 'q' || c == ESC) {
      break;
    }

    if (c == ENTER) {
      int result = handle_stow(choices, n_choices);

      if (result == 1) {
        popup("Error on stowing!");
        break;
      }

      popup("Stowed!");

      break;
    }

    switch(c) {	
      case KEY_RESIZE:
        handle_resize(win, win_h, win_w);
        break;
      case KEY_DOWN:
      case 'j':
      case CTRL_N:
		    menu_driver(menu, REQ_DOWN_ITEM);
        wrefresh(win);
				break;
			case KEY_UP:
      case 'k':
      case CTRL_P:
				menu_driver(menu, REQ_UP_ITEM);
        wrefresh(win);
				break;
      case SPACE:
        cur = current_item(menu);
        int i = item_index(cur);

        if (strcmp(choices[i][1], "[ ]") == 0) { 
          choices[i][1] = "[X]";
        } else {
          choices[i][1] = "[ ]";
        }

        unpost_menu(menu);
        free_item(items[i]);
        items[i] = new_item(choices[i][0], choices[i][1]);
        set_menu_items(menu, items);
        set_current_item(menu, items[i]);
        post_menu(menu);
        wrefresh(win);
        break;
		}
	}	

  for (int i = 0; i < n_choices; i++) {
    free_item(items[i]);
    free(choices[i][0]);
  }
  
  unpost_menu(menu);
	free_menu(menu);
  free(items);
  delwin(sub);
  delwin(win);
	endwin();

  return 0;
}
