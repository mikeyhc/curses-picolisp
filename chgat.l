(de curses @ (pass native "libncursesw.so"))

(de ncursesBits (M S)
   (>> (- (+ S 8)) M) )

(setq aBlink (ncursesBits 1 11))
(setq colorCyan 6)
(setq colorBlack 0)

(de main ()
   (setq *W (curses "initscr" 'N))
   (curses "start_color")
   (curses "init_pair" NIL 1 colorCyan colorBlack)
   (curses "printw" NIL "A Big string which I didn't care to type fully")
   (curses "mvchgat" NIL 0 0 -1 aBlink 1 0)
   (curses "refresh")
   (curses "getch")
   (curses "endwin") )
