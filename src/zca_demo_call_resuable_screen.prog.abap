*&---------------------------------------------------------------------*
*& Report zca_demo_call_resuable_screen
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zca_demo_call_resuable_screen.


CLASS lcl_demo_reuse_screen DEFINITION DEFERRED.


"! <p class="shorttext synchronized" lang="en">List of airlines</p>
CLASS lcl_list_airlines DEFINITION FINAL
                                   INHERITING FROM zcl_ca_salv_wrapper
                                   CREATE PUBLIC.
* P U B L I C   S E C T I O N
  PUBLIC SECTION.
*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Constructor</p>
      constructor
        IMPORTING
          io_container TYPE REF TO cl_gui_container
          ir_table     TYPE REF TO data,

      process REDEFINITION,

      on_link_click REDEFINITION.

*   i n s t a n c e   e v e n t s
    EVENTS:
      airline_selected
        EXPORTING
          VALUE(airline_url) TYPE s_carrurl.


* P R O T E C T E D   S E C T I O N
  PROTECTED SECTION.
*   i n s t a n c e   m e t h o d s
    METHODS:
      prepare_alv REDEFINITION.


* P R I V A T E   S E C T I O N
  PRIVATE SECTION.


ENDCLASS.                     "lcl_list_airlines  DEFINITION


CLASS lcl_list_airlines IMPLEMENTATION.

  METHOD constructor.
    "-----------------------------------------------------------------*
    "   Constructor
    "-----------------------------------------------------------------*
    super->constructor( io_container       = io_container
                        ir_table           = ir_table
                        iv_list_title      = 'Airlines'(als)
                        iv_register_events = abap_true ).
  ENDMETHOD.                    "constructor


  METHOD on_link_click.
    "-----------------------------------------------------------------*
    "   Handle link click
    "-----------------------------------------------------------------*
    "Local data definitions
    FIELD-SYMBOLS:
      <lt_airlines>        TYPE ty_scarr.

    "Is the ALV displayed in a container, it is necessary to provide the ALV metadata by an explicit
    "call of the SALV instance. Otherwise you receive no result.
    mo_salv->get_metadata( ).
    DATA(lt_sel_rows) = mo_salv->get_selections( )->get_selected_rows( ).

    ASSIGN mr_table->* TO <lt_airlines>.

    RAISE EVENT airline_selected
      EXPORTING
        airline_url = <lt_airlines>[ lt_sel_rows[ 1 ] ]-url.
  ENDMETHOD.                    "on_link_click


  METHOD prepare_alv.
    "-----------------------------------------------------------------*
    "   Prepare ALV - hide columns, set cell type, etc.
    "-----------------------------------------------------------------*
    LOOP AT mt_cols REFERENCE INTO DATA(lr_col).
      DATA(lo_table_col) = CAST cl_salv_column_table( lr_col->r_column ).
      CASE lr_col->columnname.
        WHEN 'CARRID' OR 'CARRNAME' ##no_text.
          lo_table_col->set_cell_type( if_salv_c_cell_type=>hotspot ).

        WHEN 'URL' ##no_text.
          "Hide column with homepage URL
          lo_table_col->set_visible( abap_false ).

        WHEN OTHERS.
          lo_table_col->set_technical( ).
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.                    "prepare_alv


  METHOD process.
    "-----------------------------------------------------------------*
    "   Controls the entire processing of this class
    "-----------------------------------------------------------------*
    "Local data definitions
    FIELD-SYMBOLS:
      <lt_airlines>        TYPE ty_scarr.

    TRY.
        prepare_alv( ).

        ASSIGN mr_table->* TO <lt_airlines>.

        RAISE EVENT airline_selected
          EXPORTING
            airline_url = <lt_airlines>[ 1 ]-url.

        mo_salv->display( ).

      CATCH cx_root INTO DATA(lx_catched).
        MESSAGE lx_catched TYPE zcx_ca_error=>c_msgty_e.
    ENDTRY.
  ENDMETHOD.                    "process

ENDCLASS.                     "lcl_list_airlines  IMPLEMENTATION



"! <p class="shorttext synchronized" lang="en">Demo class how to use/call the reusable screen with customer container</p>
CLASS lcl_demo_reuse_screen DEFINITION FINAL
                                       INHERITING FROM zcl_ca_reusable_dia_cust_cnt
                                       CREATE PUBLIC.
* P U B L I C   S E C T I O N
  PUBLIC SECTION.
*   i n s t a n c e   m e t h o d s
    METHODS:
      "! <p class="shorttext synchronized" lang="en">Constructor</p>
      constructor,

      "! <p class="shorttext synchronized" lang="en">Main method, that controls the entire processing</p>
      main,

      "! <p class="shorttext synchronized" lang="en">Handle event 'AIRLINE_SELECTED'</p>
      "!
      "! @parameter airline_url | <p class="shorttext synchronized" lang="en">URL of airline homepage</p>
      on_airline_selected
        FOR EVENT airline_selected OF lcl_list_airlines
        IMPORTING
          airline_url.


* P R O T E C T E D   S E C T I O N
  PROTECTED SECTION.
*   i n s t a n c e   m e t h o d s
    METHODS:
      handle_pbo REDEFINITION.


* P R I V A T E   S E C T I O N
  PRIVATE SECTION.
*   i n s t a n c e   a t t r i b u t e s
    DATA:
*     o b j e c t   r e f e r e n c e s
      "! <p class="shorttext synchronized" lang="en">Splitter container for displaying multiple infos to an airline</p>
      mo_splt_cnt      TYPE REF TO cl_gui_splitter_container,
      "! <p class="shorttext synchronized" lang="en">SALV list with available airlines</p>
      mo_list_airlines TYPE REF TO lcl_list_airlines,
      "! <p class="shorttext synchronized" lang="en">Homepage of airline</p>
      mo_airline_hp    TYPE REF TO cl_gui_html_viewer,

*     t a b l e s
      "! <p class="shorttext synchronized" lang="en">Airliens</p>
      mt_airlines      TYPE ty_scarr.

ENDCLASS.                     "lcl_demo_reuse_screen  DEFINITION


CLASS lcl_demo_reuse_screen IMPLEMENTATION.

  METHOD constructor.
    "-----------------------------------------------------------------*
    "   Constructor
    "-----------------------------------------------------------------*
    super->constructor( iv_menu_obj = 'Airline'(aln)
                        iv_toolbar  = abap_false ).
  ENDMETHOD.                    "constructor


  METHOD handle_pbo.
    "-----------------------------------------------------------------*
    "   Handling Process Before Output
    "-----------------------------------------------------------------*
    super->handle_pbo( iv_event ).

    IF mo_ccont_reuse IS NOT BOUND.
      RETURN.
    ENDIF.

    mo_splt_cnt = zcl_ca_cfw_util=>create_splitter_container( io_parent  = mo_ccont_reuse
                                                              iv_rows    = 1
                                                              iv_columns = 2 ).

    "Set container width of airlines list to a smaller amount
    zcl_ca_cfw_util=>set_column_width( io_splitter = mo_splt_cnt
                                       iv_id       = 1
                                       iv_width    = 15 ).  "in percent

    mo_airline_hp = NEW cl_gui_html_viewer( parent = mo_splt_cnt->get_container( row    = 1
                                                                                 column = 2 ) ).

    mo_list_airlines = NEW #( ir_table      = REF #( mt_airlines )
                              io_container  = mo_splt_cnt->get_container( row    = 1
                                                                          column = 1 ) ).

    SET HANDLER on_airline_selected FOR mo_list_airlines.

    mo_list_airlines->process( ).
  ENDMETHOD.                    "handle_pbo


  METHOD main.
    "-----------------------------------------------------------------*
    "   Main method, that controls the entire processing
    "-----------------------------------------------------------------*
    TRY.
        SELECT * INTO TABLE mt_airlines
                 FROM scarr.                            "#EC CI_NOWHERE
        IF mt_airlines IS INITIAL.
          "No data was found for the specified selection criteria
          RAISE EXCEPTION TYPE zcx_ca_dbacc
            EXPORTING
              textid   = zcx_ca_dbacc=>no_data
              mv_msgty = c_msgty_i.
        ENDIF.

        display( ).

      CATCH zcx_ca_error INTO DATA(lx_catched).
        MESSAGE lx_catched TYPE lx_catched->c_msgty_s DISPLAY LIKE lx_catched->mv_msgty.
    ENDTRY.
  ENDMETHOD.                    "main


  METHOD on_airline_selected.
    "-----------------------------------------------------------------*
    "   Handle event 'AIRLINE_SELECTED'
    "-----------------------------------------------------------------*
    TRY.
        mo_airline_hp->show_url(
                          EXPORTING
                            url                    = airline_url
*                            frame                  =
                            in_place               = abap_true
                          EXCEPTIONS
                            cntl_error             = 1
                            cnht_error_not_allowed = 2
                            cnht_error_parameter   = 3
                            dp_error_general       = 4
                            OTHERS                 = 5 ).
        IF sy-subrc NE 0.
          DATA(lx_error) =
               CAST zcx_ca_param(
                          zcx_ca_error=>create_exception(
                                           iv_excp_cls = zcx_ca_param=>c_zcx_ca_param
                                           iv_class    = 'MO_AIRLINE_HP'
                                           iv_method   = 'DETACH_URL_IN_BROWSER'
                                           iv_subrc    = sy-subrc ) ) ##no_text.
          IF lx_error IS BOUND.
            RAISE EXCEPTION lx_error.
          ENDIF.
        ENDIF.

      CATCH zcx_ca_error INTO DATA(lx_catched).
        MESSAGE lx_catched TYPE lx_catched->c_msgty_s DISPLAY LIKE lx_catched->mv_msgty.
    ENDTRY.
  ENDMETHOD.                    "on_airline_selected

ENDCLASS.                     "lcl_demo_reuse_screen  IMPLEMENTATION


*---------------------------------------------------------------------*
*     s t a r t - o f - s e l e c t i o n
*---------------------------------------------------------------------*
START-OF-SELECTION.
  NEW lcl_demo_reuse_screen( )->main( ).
