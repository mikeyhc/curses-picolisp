(de curses @ (pass native "libncursesw.so"))

(de ncursesBits (M S)
   (>> (- (+ S 8)) M) )

(setq aReverse (ncursesBits 1 10))
(setq keyDown 258)
(setq keyUp 259)
(setq keyLeft 260)
(setq keyRight 261)

(de choices
   "Choice 1"
   "Choice 2"
   "Choice 3"
   "Choice 4"
   "Exit" )

(de printMenu (MenuWin Highlight)
   (let (X 2 Y 1)
      (curses "box" NIL MenuWin 0 0)
      (for ((C . L) choices L (cdr L))
         (ifn (= Highlight C)
            (curses "mvwprintw" NIL MenuWin Y X "%s" (car L))
            (curses "wattron" NIL MenuWin aReverse)
            (curses "mvwprintw" NIL MenuWin Y X "%s" (car L))
            (curses "wattroff" NIL MenuWin aReverse) )
         (inc 'Y) ) )
   (curses "wrefresh" NIL MenuWin) )

(de main ()
   (let (Highlight 1
         Choice 0
         Running T
         StartX NIL
         StartY NIL)
      (setq *W (curses "initscr" 'N))
      (curses "clear")
      (curses "noecho")
      (curses "cbreak")
      (setq *WR (curses "getmaxy" 'I *W))
      (setq *WC (curses "getmaxx" 'I *W))
      (setq StartX 0)
      (setq StartY 1)
      (setq *MW (curses "newwin" 'N (- *WR 2) *WC StartY StartX))
      (curses "keypad" NIL *MW 1)
      (curses "mvprintw" NIL 0 0
              (pack "Use arrow keys to go up and down, "
                    "Press enter to select a choice") )
      (curses "refresh")
      (printMenu *MW Highlight)
      (while Running
         (let (C (curses "wgetch" 'I *MW))
            (curses "mvprintw" NIL 24 0 "got key %d" C)
            (cond
               ((= C keyUp)
                (if (= Highlight 1)
                  (setq Highlight (length choices))
                  (dec 'Highlight) ) )
               ((= C keyDown)
                (if (= Highlight (length choices))
                  (setq Highlight 1)
                  (inc 'Highlight) ) )
               ((= C 10) (setq Choice Highlight))
               (T (curses "mvprintw" NIL 24 0
                          (pack "Character pressed is = %3d Hopefully it "
                                "can be printed as '%c'" c c) ) ) )
            (printMenu *MW Highlight)
            (unless (= Choice 0) (setq Running NIL)) ) )
      (curses "clrtoeol")
      (curses "mvprintw" NIL 23 0
              "You chose choice %d with choice string \"%s\"\n"
              Choice (get choices Choice) )
      (curses "refresh")
      (curses "getch")
      (curses "endwin") ) )
