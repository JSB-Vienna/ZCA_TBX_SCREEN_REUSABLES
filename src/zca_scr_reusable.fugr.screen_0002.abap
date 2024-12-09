* Process Before Output
PROCESS BEFORE OUTPUT.
  "Prepare screen data and layout
  MODULE d0000_pbo.

*  ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
*  COPY such a block for each subscreen and give the name you
*  entered in the graphical editor
*  PLEASE DELETE commented lines you don't need
*  ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
*  "What is it for ...
*  MODULE d0000_pbo_get_subscreen.
*  CALL SUBSCREEN sscr_...    "e. g. sscr_header
*                 INCLUDING zcl_ca_scr_fw_ctlr=>mv_repid
*                           zcl_ca_scr_fw_ctlr=>mv_dynnr.

  "Set GUI status
  MODULE d0000_pbo_set_status.


* Process After Input
PROCESS AFTER INPUT.
  "Handle exit function codes
  MODULE d0000_pai_fcode AT EXIT-COMMAND.

  "Get cursor position
  MODULE d0000_pai_get_cursor.

*  ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
*  COPY such a block for each subscreen and give the name you
*  entered in the graphical editor
*  DELETE commented lines you don't need
*  ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
*  "What is it for ...
*  CALL SUBSCREEN sscr_...    "e. g. sscr_header

  "Do checks and other things
  MODULE d0000_pai.

  "Handle function code
  MODULE d0000_pai_fcode.


*  ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
*  Activate this if you need to use an individual value-request
*  call. Implement this in method HANDLE_POV of the screen
*  controller class depending on ME->MO_SCREEN->MV_POV_FIELD.
*  ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !
* Process On Value-request
*PROCESS ON VALUE-REQUEST.
*  FIELD field_name_..._x MODULE d0000_pov.
*  FIELD field_name_..._y MODULE d0000_pov.
*  FIELD field_name_..._z MODULE d0000_pov.
