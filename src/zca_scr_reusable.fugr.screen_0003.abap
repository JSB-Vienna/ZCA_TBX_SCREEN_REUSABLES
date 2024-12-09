* Process Before Output
PROCESS BEFORE OUTPUT.
  "Prepare screen data and layout
  MODULE d0000_pbo.


* Process After Input
PROCESS AFTER INPUT.
  "Do checks and other things
  MODULE d0000_pai.


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
