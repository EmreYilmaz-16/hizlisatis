<cfcomponent>
    <cffunction name="saveBelge"  httpMethod="POST" access="remote" returntype="any" returnFormat="json">
        <cfdump var="#arguments#">
        <cfset e=structKeyArray(arguments)>
        <cfdump var="#e#">
        <cfset FormData=deserializeJSON(e[1])>
        <cfdump var="#FormData#">
<cfset attributes=FormData>
        <cfset dsn3=FormData.dsn3>
        <cfset dsn3_alias=FormData.dsn3>
        <cfset dsn2=FormData.dsn2>
        <cfset dsn2_alias=FormData.dsn2>
            <cfset attributes.LOCATION_IN=1>
            <cfset attributes.LOCATION_OUT=FormData.LOCATION_ID>
            <cfset attributes.department_out=FormData.STORE_ID>
            <cfset attributes.department_in =45>
            <cfset form.process_cat=87>
            <cfset attributes.process_cat = form.process_cat>
           <cfset PROJECT_HEAD="">
           <cfset PROJECT_HEAD_IN="">
           <cfset PROJECT_ID="">
           <cfset PROJECT_ID_IN="">
           <cfset attributes.QUANTITY=FormData.QUANTITY>
           <cfset attributes.uniq_relation_id_="">
           <cfset amount_other="">
           <cfset unit_other="">
           <cfset lot_no="">
           <cfset attributes.ref_no=FormData.P_ORDER_NO>
         <cfdump var="#attributes#">
        <cfset attributes.ROWW=" ,">
        <cfdump var="#listLen(attributes.ROWW)#">
        <cfinclude template="StokFisQuery.cfm">
        <cfinclude template="GenAttr.cfm">
        <cfinclude template="/AddOns/Partner/production/query/add_sub_product_fire.cfm">
    
    </cffunction>
    <cffunction name="filterNum" returntype="string" output="false" hint="filternum">
        <!--- 
        by Ozden Ozturk 20070316
        notes :
            float veya integer alanların temizliği için kullanılır, js filterNum fonksiyonuyla aynı işlevi gorur
        parameters :
            1) str:formatlı yazdırılacak sayı (int veya float)
            2) no_of_decimal:ondalikli hane sayisi (int)
        usage : 
            filternum('124587,787',4)
            veya
            filternum(attributes.money,4)
         --->
        <cfargument name="str" required="yes">
        <cfargument name="no_of_decimal" required="no" default="2">	
        <cfscript>
        
        if((isdefined("moneyformat_style") and moneyformat_style eq 0) or (not isdefined("moneyformat_style")) or not isdefined("session.ep"))
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;,';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(newStr,',','.','all');
            newStr = replace(newStr,',',' ','all');
        }
        else
        {
            if (not len(arguments.str)) return '';
            strCheck = '-;0;1;2;3;4;5;6;7;8;9;';
            newStr = '';
            for(f_ind_i=1; f_ind_i lte len(arguments.str); f_ind_i=f_ind_i+1 )
            {
                if(listfind(strCheck, mid(arguments.str,f_ind_i,1),';'))
                    newStr = newStr&mid(arguments.str,f_ind_i,1);
            }
            newStr = replace(str,',','','all');
        }
        </cfscript>
        <cfreturn wrk_round(newStr,no_of_decimal)>
    </cffunction>
    <cffunction name="wrk_round" returntype="string" output="false">
        <cfargument name="number" required="true">
        <cfargument name="decimal_count" required="no" default="2">
        <cfargument name="kontrol_float" required="no" default="0"><!--- ürün ağacında çok ufak değerler girildiğinde E- formatında yazılanlar bozulmasın diye eklendi SM20101007 --->
        <cfscript>
            if (not len(arguments.number)) return '';
            if(arguments.kontrol_float eq 0)
            {
                if (arguments.number contains 'E') arguments.number = ReplaceNoCase(NumberFormat(arguments.number), ',', '', 'all');
            }
            else
            {
                if (arguments.number contains 'E') 
                {
                    first_value = listgetat(arguments.number,1,'E-');
                    first_value = ReplaceNoCase(first_value,',','.');
                    last_value = ReplaceNoCase(listgetat(arguments.number,2,'E-'),'0','','all');
                    //if(last_value gt 5) last_value = 5;
                    for(kk_float=1;kk_float lte last_value;kk_float=kk_float+1)
                    {
                        zero_info = ReplaceNoCase(first_value,'.','');
                        first_value = '0.#zero_info#';
                    }
                    arguments.number = first_value;
                            first_value = listgetat(arguments.number,1,'.');
                arguments.number = "#first_value#.#Left(listgetat(arguments.number,2,'.'),8)#";
                    if(arguments.number lt 0.00000001) arguments.number = 0;
                    return arguments.number;
                }
            }
            if (arguments.number contains '-'){
                negativeFlag = 1;
                arguments.number = ReplaceNoCase(arguments.number, '-', '', 'all');}
            else negativeFlag = 0;
            if(not isnumeric(arguments.decimal_count)) arguments.decimal_count= 2;	
            if(Find('.', arguments.number))
            {
                tam = listfirst(arguments.number,'.');
                onda =listlast(arguments.number,'.');
                if(onda neq 0 and arguments.decimal_count eq 0) //yuvarlama sayısı sıfırsa noktadan sonraki ilk rakama gore tam kısımda yuvarlama yapılır
                {
                    if(Mid(onda, 1,1) gte 5) // yuvarlama 
                        tam= tam+1;	
                }
                else if(onda neq 0 and len(onda) gt arguments.decimal_count)
                {
                    if(Mid(onda,arguments.decimal_count+1,1) gte 5) // yuvarlama
                    {
                        onda = Mid(onda,1,arguments.decimal_count);
                        textFormat_new = "0.#onda#";
                        textFormat_new = textFormat_new+1/(10^arguments.decimal_count);
                        
                        decimal_place_holder = '_.';
                        for(decimal_index=1;decimal_index<=arguments.decimal_count;++decimal_index)
                            decimal_place_holder = '#decimal_place_holder#_';
                        textFormat_new = LSNumberFormat(textFormat_new,decimal_place_holder);
                            
                        if(listlen(textFormat_new,'.') eq 2)
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda =listlast(textFormat_new,'.');
                        }
                        else
                        {
                            tam = tam + listfirst(textFormat_new,'.');
                            onda = '';
                        }
                    }
                    else
                        onda= Mid(onda,1,arguments.decimal_count);
                }
            }
            else
            {
                tam = arguments.number;
                onda = '';
            }
            textFormat='';
            if(len(onda) and onda neq 0 and arguments.decimal_count neq 0)
                textFormat = "#tam#.#onda#";
            else
                textFormat = "#tam#";
            if (negativeFlag) textFormat =  "-#textFormat#";
            return textFormat;
        </cfscript>
    </cffunction>
</cfcomponent>