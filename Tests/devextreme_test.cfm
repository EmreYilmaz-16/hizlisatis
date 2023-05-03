<cfif isDefined("attributes.page")>
  <cfswitch expression="#attributes.page#">
    <cfcase value="1"><cfinclude template="test_includes/eshipping_modern.cfm"></cfcase>
    <cfcase value="2"><cfinclude template="test_includes/makeTree.cfm"></cfcase>
    <cfcase value="3"><cfinclude template="test_includes/make_pump.cfm"></cfcase>
    <cfcase value="4"><cfinclude template="test_includes/make_pump_v2.cfm"></cfcase>
    <cfcase value="5"><cfinclude template="test_includes/kontrol.cfm"></cfcase>
    <cfcase value="6"><cfinclude template="test_includes/kontrolSatir.cfm"></cfcase>
    <cfcase value="7"><cfinclude template="test_includes/basket_guncelle_que.cfm"></cfcase>
  </cfswitch>
</cfif>

<cfabort>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/babel-polyfill/7.4.0/polyfill.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/exceljs/4.1.1/exceljs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.2/FileSaver.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.0.0/jspdf.umd.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.9/jspdf.plugin.autotable.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.7.1/jszip.js" integrity="sha512-NOmoi96WK3LK/lQDDRJmrobxa+NMwVzHHAaLfxdy0DRHIBc6GZ44CRlYDmAKzg9j7tvq3z+FGRlJ4g+3QC2qXg==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/event.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/supplemental.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/cldrjs/0.4.4/cldr/unresolved.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/message.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/number.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/currency.min.js"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/globalize/1.1.1/globalize/date.min.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.2.4/css/dx.common.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn3.devexpress.com/jslib/20.2.4/css/dx.light.css" />
    <script src="https://cdn3.devexpress.com/jslib/20.2.4/js/dx.all.js"></script>
<cf_box title="DevExtreme Test">
  <div class="demo-container">
    <div id="gridContainer"></div>
    <div class="options">
      <div class="caption">Options</div>
      <div class="option">
        <div id="autoExpand"></div>
      </div>
    </div>
  </div>
</cf_box>
,C.COMPANY_TELCODE,C.COMPANY_TEL1
<cfquery name="getCompanies" datasource="#dsn#">
  select C.*,SC.CITY_NAME,SCO.COUNTRY_NAME,SCT.COUNTY_NAME from COMPANY AS C
left join SETUP_CITY as SC ON SC.CITY_ID=C.CITY
left join SETUP_COUNTRY as SCO ON SCO.COUNTRY_ID=C.COUNTRY
left join SETUP_COUNTY as SCT ON SCT.COUNTY_ID=C.COUNTY
</cfquery>
<script>
  const customers = [
  <cfoutput query="getCompanies">
  {
  ID: #COMPANY_ID#,
  CompanyName: '#FULLNAME#',
  Address: '#COMPANY_ADDRESS#',
  City: '#CITY_NAME#',
  State: '#COUNTY_NAME#',
  Zipcode: '#COMPANY_POSTCODE#',
  Phone: '(#COMPANY_TELCODE#) #COMPANY_TEL1#',
  Fax: '(#COMPANY_TELCODE#) #COMPANY_FAX#',
  Website: '#HOMEPAGE#',
},</cfoutput> ];

</script>
    <script>
      $(() => {
  const dataGrid = $('#gridContainer').dxDataGrid({
    dataSource: customers,
    keyExpr: 'ID',
    allowColumnReordering: true,
    showBorders: true,
    grouping: {
      autoExpandAll: true,
    },
    searchPanel: {
      visible: true,
    },
    paging: {
      pageSize: 10,
    },
    groupPanel: {
      visible: true,
    },
    columns: [
      'CompanyName',
      'Phone',
      'Fax',
      'City',
      {
        dataField: 'State',
        groupIndex: 0,
      },
    ],
  }).dxDataGrid('instance');

  $('#autoExpand').dxCheckBox({
    value: true,
    text: 'Expand All Groups',
    onValueChanged(data) {
      dataGrid.option('grouping.autoExpandAll', data.value);
    },
  });
});

    </script>
<!----
<cfquery name="getCats" datasource="#dsn3#">
  select * from workcube_metosan_product.PRODUCT_CAT WHERE DETAIL IS NOT NULL AND  DETAIL <>'4077' AND DETAIL <>'4078' AND DETAIL <>''
</cfquery>

<cfoutput query="getCats">
  <cfloop list="#getCats.DETAIL#" item="li">
      #getCats.HIERARCHY# -- #li#
     <cfquery name="ins" datasource="#dsn3#">
     INSERT INTO PRODUCT_CAT_QUESTIONS(PRODUCT_CATID,QUESTION_ID) VALUES (#getCats.PRODUCT_CATID#,#li#)
      
     </cfquery>
  
  </cfloop>
  <cfquery name="Upd" datasource="#dsn3#">
      UPDATE workcube_metosan_product.PRODUCT_CAT SET DETAIL=NULL WHERE PRODUCT_CATID=#getCats.PRODUCT_CATID#
     </cfquery>
</cfoutput>----->
<!----
<cfquery name="getColation" datasource="#dsn#">
select SS.COLUMN_NAME,SS.DATA_TYPE,SS.CHARACTER_MAXIMUM_LENGTH,SS.TABLE_NAME,SS.COLLATION_NAME,sl.* from INFORMATION_SCHEMA.columns SS
LEFT JOIN (
select COLUMN_NAME,DATA_TYPE,CHARACTER_MAXIMUM_LENGTH,TABLE_NAME,COLLATION_NAME from INFORMATION_SCHEMA.columns where TABLE_SCHEMA='workcube_metosan_2023_1'
) AS SL ON SL.TABLE_NAME=SS.TABLE_NAME AND SL.COLUMN_NAME=SS.COLUMN_NAME

where SS.TABLE_SCHEMA='workcube_metosan_2022_1' AND SS.COLLATION_NAME IS NOT NULL AND SL.COLLATION_NAME<>SS.COLLATION_NAME
and ss.TABLE_NAME not in (select name from workcube_metosan.sys.views where schema_id=10)
</cfquery>

<cftry>
<cfoutput  query="getColation">


 ALTER TABLE workcube_metosan_2023_1.#TABLE_NAME# ALTER COLUMN  #COLUMN_NAME# 
  <cfif DATA_TYPE eq 'nvarchar'>
      NVARCHAR(<cfif CHARACTER_MAXIMUM_LENGTH eq -1>max<cfelse>#CHARACTER_MAXIMUM_LENGTH#</cfif>   
      )
      <cfelseif DATA_TYPE eq 'varchar'>
          VARCHAR(<cfif CHARACTER_MAXIMUM_LENGTH eq -1>max<cfelse>#CHARACTER_MAXIMUM_LENGTH#</cfif>   
              ) 
  </cfif>
  COLLATE SQL_Latin1_General_CP1_CI_AS
   <BR>
</cfoutput>
<cfcatch></cfcatch>
</cftry>


<cfquery name="getPeriods" datasource="#dsn#">
  select PERIOD_YEAR,OUR_COMPANY_ID from workcube_metosan.SETUP_PERIOD  where PERIOD_YEAR<> YEAR(getdate()) AND OUR_COMPANY_ID=1
</cfquery>

<cfquery name="getDepWorks" datasource="#dsn#">
            SELECT DISTINCT  O.RECORD_DATE,
                SR.DELIVER_PAPER_NO,SR.COMPANY_ID,C.NICKNAME,SR.DELIVERY_DATE,DEPARTMENT_LOCATION,COMMENT,SR.SHIP_RESULT_ID,DELIVER_DEPT,DELIVER_LOCATION,SRR.PREPARE_PERSONAL
                ,(SELECT COUNT(*) FROM #dsn3#.ORDER_ROW where ORDER_ID =O.ORDER_ID AND DELIVER_DEPT=ORR.DELIVER_DEPT AND DELIVER_LOCATION=ORR.DELIVER_LOCATION) AS TTS
                ,#dsn#.getEmployeeWithId(SR.RECORD_EMP) AS KAYDEDEN
                FROM #dsn3#.PRTOTM_SHIP_RESULT_ROW AS SRR
                LEFT JOIN #dsn3#.ORDER_ROW AS ORR ON ORR.ORDER_ROW_ID=SRR.ORDER_ROW_ID
                LEFT JOIN #dsn3#.ORDERS AS O ON O.ORDER_ID=ORR.ORDER_ID
                LEFT JOIN #dsn3#.PRTOTM_SHIP_RESULT AS SR ON SR.SHIP_RESULT_ID=SRR.SHIP_RESULT_ID
                LEFT JOIN (
                    SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dsn#_#year(now())#_1.STOCK_FIS AS SF 
                    LEFT JOIN #dsn#_#year(now())#_1.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
                    <cfloop query="getPeriods">
                      UNION
                      SELECT SFR.STOCK_ID,SUM(SFR.AMOUNT) AS AMOUNT,SF.REF_NO FROM #dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.STOCK_FIS AS SF 
                      LEFT JOIN #dsn#_#PERIOD_YEAR#_#OUR_COMPANY_ID#.STOCK_FIS_ROW AS SFR ON SFR.FIS_ID=SF.FIS_ID GROUP BY SFR.STOCK_ID,SF.REF_NO
                    </cfloop>
                    
                    
                ) AS SF ON SF.REF_NO=SR.DELIVER_PAPER_NO AND SF.STOCK_ID=ORR.STOCK_ID
                LEFT JOIN #dsn3#.STOCKS AS S ON S.STOCK_ID=ORR.STOCK_ID
                LEFT JOIN #dsn3#.PRODUCT_PLACE_ROWS AS PPR ON PPR.STOCK_ID=S.STOCK_ID
                LEFT JOIN #dsn3#.PRODUCT_PLACE AS PP ON PP.PRODUCT_PLACE_ID=PPR.PRODUCT_PLACE_ID
                LEFT JOIN #dsn#.COMPANY AS C ON C.COMPANY_ID=SR.COMPANY_ID
                INNER JOIN  #dsn#.STOCKS_LOCATION as SL ON SL.LOCATION_ID=ORR.DELIVER_LOCATION AND SL.DEPARTMENT_ID=ORR.DELIVER_DEPT
                WHERE 1=1             
                AND ORR.DELIVER_DEPT IN(44)
                AND ORR.DELIVER_LOCATION IN (2)
                AND ORR.QUANTITY>ISNULL(SF.AMOUNT,0)
                AND SRR.PREPARE_PERSONAL IS NULL
        </cfquery>

        <cfdump var="#getDepWorks#">
        ------>