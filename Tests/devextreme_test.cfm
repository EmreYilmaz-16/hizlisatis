
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
<script>
  const customers = [{
  ID: 1,
  CompanyName: 'Super Mart of the West',
  Address: '702 SW 8th Street',
  City: 'Bentonville',
  State: 'Arkansas',
  Zipcode: 72716,
  Phone: '(800) 555-2797',
  Fax: '(800) 555-2171',
  Website: 'http://www.nowebsitesupermart.com',
}, {
  ID: 2,
  CompanyName: 'K&S Music',
  Address: '1000 Nicllet Mall',
  City: 'Minneapolis',
  State: 'Minnesota',
  Zipcode: 55403,
  Phone: '(612) 304-6073',
  Fax: '(612) 304-6074',
  Website: 'http://www.nowebsitemusic.com',
}, {
  ID: 3,
  CompanyName: "Tom's Club",
  Address: '999 Lake Drive',
  City: 'Issaquah',
  State: 'Washington',
  Zipcode: 98027,
  Phone: '(800) 955-2292',
  Fax: '(800) 955-2293',
  Website: 'http://www.nowebsitetomsclub.com',
}, {
  ID: 4,
  CompanyName: 'E-Mart',
  Address: '3333 Beverly Rd',
  City: 'Hoffman Estates',
  State: 'Illinois',
  Zipcode: 60179,
  Phone: '(847) 286-2500',
  Fax: '(847) 286-2501',
  Website: 'http://www.nowebsiteemart.com',
}, {
  ID: 5,
  CompanyName: 'Walters',
  Address: '200 Wilmot Rd',
  City: 'Deerfield',
  State: 'Illinois',
  Zipcode: 60015,
  Phone: '(847) 940-2500',
  Fax: '(847) 940-2501',
  Website: 'http://www.nowebsitewalters.com',
}, {
  ID: 6,
  CompanyName: 'StereoShack',
  Address: '400 Commerce S',
  City: 'Fort Worth',
  State: 'Texas',
  Zipcode: 76102,
  Phone: '(817) 820-0741',
  Fax: '(817) 820-0742',
  Website: 'http://www.nowebsiteshack.com',
}, {
  ID: 7,
  CompanyName: 'Circuit Town',
  Address: '2200 Kensington Court',
  City: 'Oak Brook',
  State: 'Illinois',
  Zipcode: 60523,
  Phone: '(800) 955-2929',
  Fax: '(800) 955-9392',
  Website: 'http://www.nowebsitecircuittown.com',
}, {
  ID: 8,
  CompanyName: 'Premier Buy',
  Address: '7601 Penn Avenue South',
  City: 'Richfield',
  State: 'Minnesota',
  Zipcode: 55423,
  Phone: '(612) 291-1000',
  Fax: '(612) 291-2001',
  Website: 'http://www.nowebsitepremierbuy.com',
}, {
  ID: 9,
  CompanyName: 'ElectrixMax',
  Address: '263 Shuman Blvd',
  City: 'Naperville',
  State: 'Illinois',
  Zipcode: 60563,
  Phone: '(630) 438-7800',
  Fax: '(630) 438-7801',
  Website: 'http://www.nowebsiteelectrixmax.com',
}, {
  ID: 10,
  CompanyName: 'Video Emporium',
  Address: '1201 Elm Street',
  City: 'Dallas',
  State: 'Texas',
  Zipcode: 75270,
  Phone: '(214) 854-3000',
  Fax: '(214) 854-3001',
  Website: 'http://www.nowebsitevideoemporium.com',
}, {
  ID: 11,
  CompanyName: 'Screen Shop',
  Address: '1000 Lowes Blvd',
  City: 'Mooresville',
  State: 'North Carolina',
  Zipcode: 28117,
  Phone: '(800) 445-6937',
  Fax: '(800) 445-6938',
  Website: 'http://www.nowebsitescreenshop.com',
}, {
  ID: 12,
  CompanyName: 'Braeburn',
  Address: '1 Infinite Loop',
  City: 'Cupertino',
  State: 'California',
  Zipcode: 95014,
  Phone: '(408) 996-1010',
  Fax: '(408) 996-1012',
  Website: 'http://www.nowebsitebraeburn.com',
}, {
  ID: 13,
  CompanyName: 'PriceCo',
  Address: '30 Hunter Lane',
  City: 'Camp Hill',
  State: 'Pennsylvania',
  Zipcode: 17011,
  Phone: '(717) 761-2633',
  Fax: '(717) 761-2334',
  Website: 'http://www.nowebsitepriceco.com',
}, {
  ID: 14,
  CompanyName: 'Ultimate Gadget',
  Address: '1557 Watson Blvd',
  City: 'Warner Robbins',
  State: 'Georgia',
  Zipcode: 31093,
  Phone: '(995) 623-6785',
  Fax: '(995) 623-6786',
  Website: 'http://www.nowebsiteultimategadget.com',
}, {
  ID: 15,
  CompanyName: 'Electronics Depot',
  Address: '2455 Paces Ferry Road NW',
  City: 'Atlanta',
  State: 'Georgia',
  Zipcode: 30339,
  Phone: '(800) 595-3232',
  Fax: '(800) 595-3231',
  Website: 'http://www.nowebsitedepot.com',
}, {
  ID: 16,
  CompanyName: 'EZ Stop',
  Address: '618 Michillinda Ave.',
  City: 'Arcadia',
  State: 'California',
  Zipcode: 91007,
  Phone: '(626) 265-8632',
  Fax: '(626) 265-8633',
  Website: 'http://www.nowebsiteezstop.com',
}, {
  ID: 17,
  CompanyName: 'Clicker',
  Address: '1100 W. Artesia Blvd.',
  City: 'Compton',
  State: 'California',
  Zipcode: 90220,
  Phone: '(310) 884-9000',
  Fax: '(310) 884-9001',
  Website: 'http://www.nowebsiteclicker.com',
}, {
  ID: 18,
  CompanyName: 'Store of America',
  Address: '2401 Utah Ave. South',
  City: 'Seattle',
  State: 'Washington',
  Zipcode: 98134,
  Phone: '(206) 447-1575',
  Fax: '(206) 447-1576',
  Website: 'http://www.nowebsiteamerica.com',
}, {
  ID: 19,
  CompanyName: 'Zone Toys',
  Address: '1945 S Cienega Boulevard',
  City: 'Los Angeles',
  State: 'California',
  Zipcode: 90034,
  Phone: '(310) 237-5642',
  Fax: '(310) 237-5643',
  Website: 'http://www.nowebsitezonetoys.com',
}, {
  ID: 20,
  CompanyName: 'ACME',
  Address: '2525 E El Segundo Blvd',
  City: 'El Segundo',
  State: 'California',
  Zipcode: 90245,
  Phone: '(310) 536-0611',
  Fax: '(310) 536-0612',
  Website: 'http://www.nowebsiteacme.com',
}];

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
</cftry>------>


<cfquery name="getPeriods" datasource="#dsn#">
  select PERIOD_YEAR,OUR_COMPANY_ID from workcube_metosan.SETUP_PERIOD  where PERIOD_YEAR<> YEAR(getdate())
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