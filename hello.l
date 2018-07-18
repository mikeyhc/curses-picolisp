(de curses @ (pass native "libncursesw.so"))

(de main ()
   (curses "initscr")
   (curses "printw" NIL "Hello World !!!")
   (curses "refresh")
   (curses "getch")
   (curses "endwin") )
