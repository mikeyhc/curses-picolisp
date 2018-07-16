(de curses @ (pass native "libncursesw.so"))

(de keyF (X) (+ X 264))

(setq keyDown 258)
(setq keyUp 259)
(setq keyLeft 260)
(setq keyRight 261)

(setq height 3)
(setq width 10)

(de createNewwin (height width starty startx)
   (let (win (curses "newwin" 'N height width starty startx))
      (curses "box" NIL win 0 0)
      (curses "wrefresh" NIL win)
      win) )

(de destroyWin (win)
   (curses "wborder" NIL win 32 32 32 32 32 32 32 32)
   (curses "wrefresh" NIL win)
   (curses "delwin" NIL win) )

(local) *W *WR *WC *MW
(de main ()
   (setq *W (curses "initscr" 'N))
   (curses "cbreak")
   (curses "keypad" NIL *W 1)
   (setq *WR (curses "getmaxy" 'I *W))
   (setq *WC (curses "getmaxx" 'I *W))
   (let (starty (- *WR height)
         startx (- *WC width) )
      (curses "printw" NIL "Press F1 to exit")
      (curses "refresh")
      (setq *MW (createNewwin height width starty startx))
      (let (ch (curses "getch" 'I))
         (while (not (= ch (keyF 1)))
            (cond
               ((= ch keyLeft)
                (destroyWin *MW)
                (setq startx (- startx 1))
                (setq *MW (createNewwin height width starty startx)) )
               ((= ch keyRight)
                (destroyWin *MW)
                (setq startx (+ startx 1))
                (setq *MW (createNewwin height width starty startx)) )
               ((= ch keyUp)
                (destroyWin *MW)
                (setq starty (- starty 1))
                (setq *MW (createNewwin height width starty startx)) )
               ((= ch keyDown)
                (destroyWin *MW)
                (setq starty (+ starty 1))
                (setq *MW (createNewwin height width starty startx)) ) )
            (setq ch (curses "getch" 'I)) ) ) )
   (curses "endwin") )
(====)