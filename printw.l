(de curses @ (pass native "libncursesw.so"))

(de main ()
   (setq *Msg "Just a string")
   (setq *W (curses "initscr" 'N))
   (setq *WC (curses "getmaxx" 'I *W))
   (setq *WR (curses "getmaxy" 'I *W))
   (curses "mvprintw" NIL (/ *WR 2) (/ (- *WC (length *Msg)) 2) "%s" *Msg)
   (curses "mvprintw" NIL (- *WR 2) 0
           "This screen has %d rows and %d columns\n"
           *WR *WC)
   (curses "printw" NIL (pack "Try resizing your window and then run this "
                              "program again") )
   (curses "refresh")
   (curses "getch")
   (curses "endwin") )
