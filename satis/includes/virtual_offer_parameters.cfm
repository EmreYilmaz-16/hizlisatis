<cfquery name="getSettings" datasource="#dsn3#" result="Res">
    SELECT * FROM VIRTUAL_OFFER_SETTINGS
</cfquery>
<cfquery name="getQ" datasource="#dsn3#">
    SELECT * FROM VIRTUAL_PRODUCT_TREE_QUESTIONS 
</cfquery>
<cfquery name="getShMethods" datasource="#dsn#">
    select SHIP_METHOD_ID,SHIP_METHOD from SHIP_METHOD
</cfquery>
<cfquery name="getPyMethods" datasource="#dsn#">
    select PAYMETHOD_ID,PAYMETHOD,DUE_DAY from SETUP_PAYMETHOD
</cfquery>

<script>    
    <cfoutput>
      var generalParamsSatis={
          dataSources:{
              dsn:'#dsn#',
              dsn1:'#dsn1#',
              dsn2:'#dsn2#',
              dsn3:'#dsn3#'
          },
          userData:{
              user_id:#session.ep.USERID#,
              ourCompanyId:#session.ep.COMPANY_ID#,
              Money:'#session.ep.MONEY#',
              Money2:'#session.ep.MONEY2#',
              periodId:#session.ep.PERIOD_ID#,
              periodYear:#session.ep.PERIOD_YEAR#,
          },
          workingParams:{
              <cfloop list="#Res.COLUMNLIST#" item="ix">
                  #ix#: <cfif isNumeric(evaluate("getSettings.#ix#"))>#evaluate("getSettings.#ix#")#<cfelse>'#evaluate("getSettings.#ix#")#'</cfif>,
              </cfloop>
          },
          Questions:[
              <cfloop query="getQ">
                  {
                      QUESTION_ID:#QUESTION_ID#,
                      QUESTION:'#QUESTION#',
                      IS_REQUIRED:#IS_REQUIRED#
                  },
              </cfloop>
          ],
          SHIP_METHODS:[
              <cfloop query="getShMethods">
                  {
                      SHIP_METHOD_ID:#SHIP_METHOD_ID#,
                      SHIP_METHOD:'#SHIP_METHOD#'
                  },
              </cfloop>
          ],
          PAY_METHODS:[
              <cfloop query="getPyMethods">
                  {
                      PAYMETHOD_ID:#PAYMETHOD_ID#,
                      PAYMETHOD:'#PAYMETHOD#',
                      DUE_DAY:#DUE_DAY#
                  },
              </cfloop>
          ],
      };
    </cfoutput>
  </script>