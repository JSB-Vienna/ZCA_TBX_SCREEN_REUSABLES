"! <p class="shorttext synchronized" lang="en">Call reusable screen, full screen or popup</p>
"!
"! @parameter iv_dynnr         | <p class="shorttext synchronized" lang="en">Screen number to be called</p>
"! @parameter iv_open_as       | <p class="shorttext synchronized" lang="en">Open as screen or popup -&gt; use ZCL_CA_C_SCR_FW=>OPEN_AS-*</p>
"! @parameter iv_menu_obj      | <p class="shorttext synchronized" lang="en">Object descriptor for menu (only for screen relevant)</p>
"! @parameter is_popup_corners | <p class="shorttext synchronized" lang="en">Definition of the popup corner points</p>
FUNCTION z_ca_call_reusable_screen.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DYNNR) TYPE  SYST_DYNNR
*"     REFERENCE(IV_OPEN_AS) TYPE  ABAP_BOOL OPTIONAL
*"     REFERENCE(IV_MENU_OBJ) TYPE  GUI_TEXT OPTIONAL
*"     REFERENCE(IS_POPUP_CORNERS) TYPE  ZCA_S_SCR_FW_POPUP_CORNERS
*"       OPTIONAL
*"----------------------------------------------------------------------
  CASE iv_open_as.
    WHEN zcl_ca_c_scr_fw=>open_as-screen.
      gv_menu_object = iv_menu_obj.
      CALL SCREEN iv_dynnr.

    WHEN zcl_ca_c_scr_fw=>open_as-popup.
      CALL SCREEN iv_dynnr STARTING AT is_popup_corners-starting_at_x  is_popup_corners-starting_at_y
                           ENDING   AT is_popup_corners-ending_at_x    is_popup_corners-ending_at_y.
  ENDCASE.
ENDFUNCTION.
