(de curses @ (pass native "libncursesw.so"))

(setq width 30)
(setq height 10)

(de ncursesBits (M S)
   (>> (- (+ S 8)) M) )

(de ncursesMouseMask (B M)
   (>> (* (- B 1) -5) M) )

(setq reportMousePosition (ncursesMouseMask 6 8))

(setq allMouseEvents (- reportMousePosition 1))

(setq aReverse (ncursesBits 1 10))

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

(de reportChoice (MouseX MouseY)
   (let (I (+ *StartX 3)
         J (+ *StartY 1)
         Run T
         Choice NIL)
      (for ((C . L) choices (and L Run) (cdr L))
         (when (and (= MouseY (+ J C)) (>= MouseX I)
                    (<= MouseX (+ I (length (get choices C)))) )
            (setq Choice (if (= C (length choices)) -1 C))
            (setq Run NIL) ) )
      Choice ) )

(de main ()
   (setq *W (curses "initscr" 'N))
   (curses "clear")
   (curses "noecho")
   (curses "cbreak")
   (setq *StartX (/ (- 80 width) 2))
   (setq *StartY (/ (- 24 height) 2))
   (curses "attron" NIL aReverse)
   (curses "mvprintw" NIL 23 1 "Click on Exit to quit")
   (curses "refresh")
   (curses "attroff" NIL aReverse)

   (setq *MW (curses "newwin" 'N height width *StartY *StartX))
   (printMenu *MW 1)
   (curses "keypad" NIL *MW 1)
   (curses "mousemask" 'N allMouseEvents 0)

   (let (Running T)
      (while Running
         (let (C (curses "wgetch" 'I *MW))
            (when (= C 409)
               (when (= (curses "getmouse" 'N
                                '(Event (20 I (I . 3) I))) 0 )
                  (let (Choice (reportChoice (+ (get Event 2 1) 1)
                                             (+ (get Event 2 2) 1) ) )
                     (if (= Choice -1)
                        (setq Running NIL)
                        (unless (= Choice NIL)
                           (curses "mvprintw" NIL 22 1
                                   "Choice made is: %d String chosen is \"%s\""
                                   Choice (get choices Choice) )
                           (curses "refresh") ) )
                     (printMenu *MW Choice) ) ) ) ) ) )
   (curses "endwin") )
