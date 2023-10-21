FUNCTION-POOL zca_scr_reusable.

* g l o b a l   d e f i n i t i o n s
DATA:
* s i n g l e   v a l u e s
  "! <p class="shorttext synchronized" lang="en">Object description for menu</p>
  gv_menu_object       TYPE gui_text ##needed,
  "! <p class="shorttext synchronized" lang="en">Screen field name the value-request was triggered</p>
  gv_pov_field         TYPE dynfnam ##needed ##decl_modul.


* INCLUDE LZCA_SCR_FW_COPY_PATTERND...       " Local class definition
