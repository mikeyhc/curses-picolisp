(de curses @ (pass native "libncursesw.so"))

(de ncursesBits (M S)
   (>> (- (+ S 8)) M) )

(setq aBold (ncursesBits 1 13))

(local) *W *WR *WC *P
(de newpage ()
   (curses "printw" NIL "<-Press Any Key->")
   (curses "getch")
   (curses "clear")
   (curses "move" NIL 0 0) )

(de process (C)
   (let (y (curses "getcury" 'I *W)
         x (curses "getcurx" 'I *W) )
      (if (= y (- *WR 1))
         (newpage) )
      (ifn (and (= *P "/") (= C "*"))
         (curses "printw" NIL "%s" C)
         (curses "attron" NIL aBold)
         (setq y (curses "getcury" 'I *W))
         (setq x (curses "getcurx" 'I *W))
         (curses "move" NIL y (- x 1))
         (curses "printw" NIL "/%c" 47 C) )
      (curses "refresh")
      (if (and (= *P "*") (= C "/"))
         (curses "attroff" NIL aBold) )
      (setq *P C) ) )

(de main (CFile)
   (if CFile
    (in CFile
        (setq *W (curses "initscr" 'N))
        (setq *WR (curses "getmaxy" 'I *W))
        (setq *WC (curses "getmaxx" 'I *W))
        (while (char) (process @))
        (curses "getch")
        (curses "endwin") )
    (out 2 (prinl "Cannot open input file")) ) )
(====)