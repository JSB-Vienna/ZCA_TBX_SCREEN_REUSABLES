"! <p class="shorttext synchronized" lang="en">CA-TBX: Reusable screen with custom container</p>
"!
"! <p>Reuse this class as super class for your screen and redefine methods such as HANDLE_PBO,
"! HANDLE_PAI or HANDLE_FCODE to bring in your functionalities. There is no need to create an
"! own screen.</p>
CLASS zcl_ca_reusable_dia_cust_cnt DEFINITION PUBLIC
                                              INHERITING FROM zcl_ca_scr_fw_window_ctlr
                                              CREATE PUBLIC
                                              ABSTRACT.

* P U B L I C   S E C T I O N
  PUBLIC SECTION.
*   i n t e r f a c e s
    INTERFACES:
      zif_ca_scr_reusable.

*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Constructor</p>
      "!
      "! @parameter iv_mode     | <p class="shorttext synchronized" lang="en">Screen mode (use ZCL_CA_C_SCR_FW=>MODE-*)</p>
      "! @parameter iv_menu_obj | <p class="shorttext synchronized" lang="en">Object descriptor for GUI menu</p>
      "! @parameter iv_toolbar  | <p class="shorttext synchronized" lang="en">X = With appl. toolbar; 0 = Hide appl. toolbar</p>
      constructor
        IMPORTING
          iv_mode     TYPE syst_ucomm DEFAULT zcl_ca_c_scr_fw=>mode-display
          iv_menu_obj TYPE gui_text   DEFAULT 'List'(mob)
          iv_toolbar  TYPE abap_bool  DEFAULT abap_true.


* P R O T E C T E D   S E C T I O N
  PROTECTED SECTION.
*   a l i a s e s
    ALIASES:
*     Screen elements
      c_prog_name_scrs     FOR  zif_ca_scr_reusable~c_prog_name_screens,
      c_titlebar           FOR  zif_ca_scr_reusable~c_titlebar,
      c_pfstatus_popup     FOR  zif_ca_scr_reusable~c_pfstatus_popup,
      c_pfstatus_screen    FOR  zif_ca_scr_reusable~c_pfstatus_screen,
      c_scr_fname_ccont    FOR  zif_ca_scr_reusable~c_scr_fname_ccont,
*     Customer container
      mo_ccont_reuse       FOR  zif_ca_scr_reusable~mo_ccont_reuse.

*   i n s t a n c e   m e t h o d s
    METHODS:
      handle_pbo REDEFINITION,

      on_call_screen REDEFINITION,

      on_closed REDEFINITION,

      on_process_fcode REDEFINITION,

      on_set_status REDEFINITION.


* P R I V A T E   S E C T I O N
  PRIVATE SECTION.
*   i n s t a n c e   a t t r i b u t e s
    DATA:
*     s i n g l e   v a l u e s
      "! <p class="shorttext synchronized" lang="en">Object descriptor for menu</p>
      mv_menu_obj          TYPE gui_text.

ENDCLASS.



CLASS ZCL_CA_REUSABLE_DIA_CUST_CNT IMPLEMENTATION.


  METHOD constructor.
    "-----------------------------------------------------------------*
    "   Constructor
    "-----------------------------------------------------------------*
    super->constructor( iv_mode = iv_mode ).

    mv_menu_obj = iv_menu_obj.
    mv_repid    = c_prog_name_scrs.
    mv_dynnr    = SWITCH #( iv_toolbar
                                  WHEN abap_true  THEN '0100'
                                  WHEN abap_false THEN '0101' ).
  ENDMETHOD.                    "constructor


  METHOD handle_pbo.
    "-----------------------------------------------------------------*
    "   Handle Process Before Output - but set no GUI status!
    "-----------------------------------------------------------------*
    IF mo_ccont_reuse IS BOUND.
      RETURN.
    ENDIF.

    mo_ccont_reuse = zcl_ca_cfw_util=>create_custom_container( iv_cnt_name = c_scr_fname_ccont
                                                               iv_repid    = mv_repid
                                                               iv_dynnr    = mv_dynnr ).
  ENDMETHOD.                    "handle_pbo


  METHOD on_call_screen.
    "-----------------------------------------------------------------*
    "   Call simply the screen - nothing else
    "-----------------------------------------------------------------*
    CALL FUNCTION 'Z_CA_CALL_REUSABLE_SCREEN'
      EXPORTING
        iv_dynnr    = mv_dynnr
        iv_menu_obj = mv_menu_obj.
  ENDMETHOD.                    "on_call_screen


  METHOD on_closed.
    "-----------------------------------------------------------------*
    "   Release fields and instances for garbage collection
    "-----------------------------------------------------------------*
    super->on_closed( ).
    mo_ccont_reuse->free( ).
    FREE: mo_ccont_reuse,
          mv_repid,
          mv_dynnr.
  ENDMETHOD.                    "on_closed


  METHOD on_process_fcode.
    "-----------------------------------------------------------------*
    "   Handle function code
    "-----------------------------------------------------------------*
    IF iv_fcode EQ mo_fcodes->cancel OR
       iv_fcode EQ mo_fcodes->exit   OR
       iv_fcode EQ mo_fcodes->back.
      set_fcode_handled( ).
      close( ).
    ENDIF.
  ENDMETHOD.                    "on_process_fcode


  METHOD on_set_status.
    "-----------------------------------------------------------------*
    "   Activate functions depending on mode and set titlebar
    "-----------------------------------------------------------------*
    io_gui_status->set_pfstatus( iv_pfstatus       = c_pfstatus_screen
                                 iv_pfstatus_repid = c_prog_name_scrs ).

    io_gui_status->set_titlebar( iv_titlebar       = c_titlebar
                                 iv_titlebar_repid = c_prog_name_scrs ).
  ENDMETHOD.                    "on_set_status
ENDCLASS.
