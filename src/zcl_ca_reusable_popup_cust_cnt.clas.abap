"! <p class="shorttext synchronized" lang="en">CA-TBX: Reusable popup with custom container</p>
"!
"! <p>Reuse this class as super class for your popup and redefine methods such as HANDLE_PBO,
"! HANDLE_PAI or HANDLE_FCODE to bring in your functionalities. There is no need to create an
"! own screen.</p>
CLASS zcl_ca_reusable_popup_cust_cnt DEFINITION PUBLIC
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
      "! @parameter iv_mode          | <p class="shorttext synchronized" lang="en">Screen mode (use ZCL_CA_C_SCR_FW=>MMODE_*)</p>
      "! @parameter iv_toolbar       | <p class="shorttext synchronized" lang="en">X = With appl. toolbar; ' ' = Hide appl. toolbar</p>
      "! @parameter is_popup_corners | <p class="shorttext synchronized" lang="en">Definition of the popup corner points</p>
      "! @raising   zcx_ca_param     | <p class="shorttext synchronized" lang="en">Common exception: Parameter error (INHERIT from this excep!)</p>
      constructor
        IMPORTING
          iv_mode          TYPE syst_ucomm DEFAULT zcl_ca_c_scr_fw=>mode-display
          iv_toolbar       TYPE abap_bool  DEFAULT abap_true
          is_popup_corners TYPE zca_s_scr_fw_popup_corners
        RAISING
          zcx_ca_param.


* P R O T E C T E D   S E C T I O N
  PROTECTED SECTION.
*   a l i a s e s
    ALIASES:
*     Screen elements
      c_prog_name_screens  FOR  zif_ca_scr_reusable~c_prog_name_screens,
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


ENDCLASS.



CLASS ZCL_CA_REUSABLE_POPUP_CUST_CNT IMPLEMENTATION.


  METHOD constructor.
    "-----------------------------------------------------------------*
    "   Constructor
    "-----------------------------------------------------------------*
    super->constructor( iv_mode          = iv_mode
                        iv_open_as       = abap_true
                        is_popup_corners = is_popup_corners ).

    mv_repid = c_prog_name_screens.
    mv_dynnr = SWITCH #( iv_toolbar
                           WHEN abap_true  THEN '0120'
                           WHEN abap_false THEN '0121' ).
  ENDMETHOD.                    "constructor


  METHOD handle_pbo.
    "-----------------------------------------------------------------*
    "   Handle Process Before Output - GUI status is set in ON_SET_STATUS!
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
        iv_dynnr         = mv_dynnr
        iv_open_as       = mv_open_as
        is_popup_corners = is_popup_corners.
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
       iv_fcode EQ mo_fcodes->enter.
      set_fcode_handled( ).
      close( ).
    ENDIF.
  ENDMETHOD.                    "on_process_fcode


  METHOD on_set_status.
    "-----------------------------------------------------------------*
    "   Activate functions depending on mode and set title bar
    "-----------------------------------------------------------------*
    "Deactivate functions depending on the active mode: MODIFY needs no ENTER, DISPLAY needs no SAVE
    io_gui_status->set_excl_fcode( it_fcodes = VALUE #( ( SWITCH #( mv_mode
                                                            WHEN mo_scr_options->mode-display
                                                              THEN mo_fcodes->save
                                                            WHEN mo_scr_options->mode-modify
                                                              THEN mo_fcodes->enter ) ) ) ).

    io_gui_status->set_pfstatus( iv_pfstatus       = c_pfstatus_popup
                                 iv_pfstatus_repid = c_prog_name_screens ).

    io_gui_status->set_titlebar( iv_titlebar       = c_titlebar
                                 iv_titlebar_repid = c_prog_name_screens ).
  ENDMETHOD.                    "on_set_status
ENDCLASS.
