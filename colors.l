(de curses @ (pass native "libncursesw.so"))

(setq colorBlack 0)
(setq colorRed 1)

(de ncursesBits (M S)
   (>> (- (+ S 8)) M) )

(setq aColor (ncursesBits (- (>> 1 -8) 1) 0))

(de colorPair (n)
   (& (ncursesBits n 0) aColor) )

(de printInMiddle (Win StartY StartX Width String)
   (let (Y (curses "getmaxy" 'N Win)
         X (curses "getmaxx" 'N Win) )
      (unless (= StartX 0)
         (setq X StartX) )
      (unless (= StartY 0)
         (setq Y StartY) )
      (if (= Width 0)
         (setq Width 80) )
      (curses "mvwprintw" NIL Win Y (+ StartX
                                       (/ (- Width (length String)) 2) )
              "%s" String )
      (curses "refresh") ) )

(de main ()
   (setq *W (curses "initscr" 'N))
   (when (= (curses "has_colors" 'I) 0)
      (curses *W "endwin")
      (out 2 (prinl "Your terminal does not support color"))
      (bye 1))
   (curses "start_color")
   (curses "init_pair" NIL 1 colorRed colorBlack)
   (curses "attron" NIL (colorPair 1))
   (printInMiddle *W (/ (curses "getmaxy" 'N *W) 2) 0 0
      "Viola !!! In color ...")
   (curses "attroff" NIL (colorPair 1))
   (curses "getch")
   (curses "endwin") )
